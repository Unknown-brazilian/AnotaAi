import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/enums.dart';
import 'binance_service.dart';

/// Conversão de EUR/GBP para Real (BRL).
///
/// Estratégia principal (sem depender de API de câmbio): derivar pela própria
/// Binance. Como `BTCBRL`, `BTCEUR` e `BTCGBP` existem, o câmbio sai da razão:
///
///   EUR→BRL = preço(BTCBRL) / preço(BTCEUR)
///   GBP→BRL = preço(BTCBRL) / preço(BTCGBP)
///
/// Se a Binance falhar, cai para uma API pública de câmbio (open.er-api.com).
class FxService {
  final BinanceService binance;
  final http.Client _client;

  FxService(this.binance, {http.Client? client})
      : _client = client ?? http.Client();

  /// Taxa atual de [from] (EUR/GBP) para BRL. Retorna null se indisponível.
  Future<double?> toBrlRate(Currency from) async {
    // 1) Via Binance (BTCBRL / BTCfrom).
    final btcBrl = await binance.currentPrice('BTCBRL');
    final btcFrom = await binance.currentPrice(from.btcPair);
    if (btcBrl != null && btcFrom != null && btcFrom > 0) {
      return btcBrl / btcFrom;
    }
    // 2) Fallback: API pública de câmbio.
    return _fallbackRate(from);
  }

  /// Converte um valor para BRL; retorna null se não houver câmbio disponível.
  Future<double?> convert(double amount, Currency from) async {
    final rate = await toBrlRate(from);
    return rate == null ? null : amount * rate;
  }

  Future<double?> _fallbackRate(Currency from) async {
    try {
      final uri = Uri.parse('https://open.er-api.com/v6/latest/${from.code}');
      final resp = await _client.get(uri).timeout(const Duration(seconds: 12));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>?;
        final brl = rates?['BRL'];
        if (brl != null) return (brl as num).toDouble();
      }
    } catch (_) {}
    return null;
  }

  void dispose() => _client.close();
}
