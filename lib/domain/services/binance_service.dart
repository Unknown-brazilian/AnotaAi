import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/brand.dart';
import '../../core/enums.dart';
import '../../data/database/database.dart';

/// Acesso à API pública de market data da Binance (sem chave) + cache local.
///
/// Pares usados: `BTCEUR`, `BTCGBP` (cotação do Bitcoin por moeda) e `BTCBRL`
/// (para derivar o câmbio em Real). Todas as cotações são gravadas em
/// [PriceCaches] para não repetir chamadas de rede.
class BinanceService {
  final AppDatabase db;
  final http.Client _client;

  BinanceService(this.db, {http.Client? client})
      : _client = client ?? http.Client();

  static const _base = AppConfig.binanceApiBase;

  /// Normaliza uma data para a "chave de dia" em UTC (meia-noite UTC).
  static DateTime dayKey(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  /// Preço atual de um par (ex.: BTCEUR). Atualiza o cache do dia corrente.
  /// Em caso de falha de rede, devolve o último valor em cache (se houver).
  Future<double?> currentPrice(String pair) async {
    try {
      final uri = Uri.parse('$_base/api/v3/ticker/price?symbol=$pair');
      final resp = await _client.get(uri).timeout(const Duration(seconds: 12));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final price = double.tryParse(data['price'].toString());
        if (price != null) {
          // Guarda como cotação "de hoje" para uso offline posterior.
          await db.cachePrice(pair, _today(), price);
          return price;
        }
      }
    } catch (_) {
      // Sem rede: cai no cache abaixo.
    }
    return db.cachedClose(pair, _today());
  }

  /// Cotação atual do Bitcoin na moeda do registro.
  Future<double?> btcCurrent(Currency currency) =>
      currentPrice(currency.btcPair);

  /// Garante que todos os fechamentos diários do par no intervalo [fromDay,
  /// toDay] (inclusive) estejam em cache, buscando apenas o que falta.
  Future<void> ensureDailyRange(String pair, DateTime fromDay, DateTime toDay) async {
    final from = dayKey(fromDay);
    final to = dayKey(toDay);
    if (to.isBefore(from)) return;

    // Verifica se já está tudo em cache antes de gastar rede.
    var allCached = true;
    for (var d = from; !d.isAfter(to); d = d.add(const Duration(days: 1))) {
      if (await db.cachedClose(pair, d) == null) {
        allCached = false;
        break;
      }
    }
    if (allCached) return;

    // A Binance devolve no máximo 1000 velas por chamada → paginar.
    var cursor = from;
    while (!cursor.isAfter(to)) {
      final windowEnd = cursor.add(const Duration(days: 999));
      final end = windowEnd.isAfter(to) ? to : windowEnd;
      final closes = await _fetchKlines(pair, cursor, end);
      if (closes.isEmpty) break; // par inexistente ou sem dados
      await db.cachePrices(pair, closes);
      cursor = end.add(const Duration(days: 1));
    }
  }

  /// Fechamento de um dia específico (lê do cache; chame [ensureDailyRange]
  /// antes para popular).
  Future<double?> closeOn(String pair, DateTime day) =>
      db.cachedClose(pair, dayKey(day));

  /// Busca velas diárias (klines) da Binance e devolve um mapa dia→fechamento.
  Future<Map<DateTime, double>> _fetchKlines(
      String pair, DateTime fromDay, DateTime toDay) async {
    final result = <DateTime, double>{};
    try {
      final startMs = dayKey(fromDay).millisecondsSinceEpoch;
      final endMs = dayKey(toDay)
          .add(const Duration(days: 1))
          .millisecondsSinceEpoch;
      final uri = Uri.parse(
          '$_base/api/v3/klines?symbol=$pair&interval=1d&startTime=$startMs&endTime=$endMs&limit=1000');
      final resp = await _client.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return result;
      final list = jsonDecode(resp.body) as List<dynamic>;
      for (final k in list) {
        // Formato kline: [openTime, open, high, low, close, ...].
        final openTime = (k[0] as num).toInt();
        final close = double.tryParse(k[4].toString());
        if (close == null) continue;
        final day = DateTime.fromMillisecondsSinceEpoch(openTime, isUtc: true);
        result[DateTime.utc(day.year, day.month, day.day)] = close;
      }
    } catch (_) {
      // Mantém o que já foi coletado.
    }
    return result;
  }

  DateTime _today() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day);
  }

  void dispose() => _client.close();
}
