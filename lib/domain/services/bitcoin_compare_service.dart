import '../../core/enums.dart';
import '../../data/database/database.dart';
import 'binance_service.dart';

/// Resultado do comparativo "e se eu tivesse poupado em Bitcoin" para UMA moeda.
class BitcoinComparison {
  final Currency currency;

  /// Quanto teria sido separado em fiat (% × ganhos do período).
  final double savedFiat;

  /// Bitcoin acumulado comprando a cada diária pela cotação de fechamento do dia.
  final double accumulatedBtc;

  /// Cotação atual do Bitcoin nessa moeda.
  final double currentBtcPrice;

  const BitcoinComparison({
    required this.currency,
    required this.savedFiat,
    required this.accumulatedBtc,
    required this.currentBtcPrice,
  });

  /// Valor atual em fiat do Bitcoin acumulado.
  double get currentValue => accumulatedBtc * currentBtcPrice;

  /// Ganho (ou perda) absoluto em relação ao que foi poupado.
  double get gainAbs => currentValue - savedFiat;

  /// Ganho/perda percentual.
  double get gainPct => savedFiat > 0 ? (gainAbs / savedFiat) * 100 : 0;
}

class BitcoinComparisonResult {
  final Map<Currency, BitcoinComparison> byCurrency;

  /// Verdadeiro quando faltou cotação de algum dia (ex.: sem internet e sem
  /// cache) — a UI avisa que o resultado é parcial.
  final bool incomplete;

  const BitcoinComparisonResult(this.byCurrency, {this.incomplete = false});

  bool get isEmpty => byCurrency.isEmpty;
}

/// Calcula o comparativo educativo de poupança em Bitcoin.
class BitcoinCompareService {
  final BinanceService binance;
  BitcoinCompareService(this.binance);

  /// Para o conjunto de [entries] e o percentual [pct] (ex.: 0.20):
  /// 1. separa por moeda;
  /// 2. para cada diária, compra `pct × valor` em BTC pela cotação de
  ///    FECHAMENTO do dia daquela diária (par conforme a moeda);
  /// 3. soma o BTC acumulado e calcula o valor atual.
  Future<BitcoinComparisonResult> compute(
      List<WorkEntry> entries, double pct) async {
    if (entries.isEmpty) return const BitcoinComparisonResult({});

    final byCurrency = <Currency, List<WorkEntry>>{};
    for (final e in entries) {
      byCurrency.putIfAbsent(e.currency, () => []).add(e);
    }

    final result = <Currency, BitcoinComparison>{};
    var incomplete = false;

    for (final entry in byCurrency.entries) {
      final currency = entry.key;
      final list = entry.value;
      final pair = currency.btcPair;

      // Popula o cache de cotações históricas para todo o intervalo de uma vez.
      list.sort((a, b) => a.date.compareTo(b.date));
      await binance.ensureDailyRange(pair, list.first.date, list.last.date);

      final currentPrice = await binance.currentPrice(pair);

      var savedFiat = 0.0;
      var btc = 0.0;
      for (final e in list) {
        final portion = e.amountDue * pct;
        if (portion <= 0) continue;
        savedFiat += portion;
        final close = await binance.closeOn(pair, e.date);
        if (close == null || close <= 0) {
          incomplete = true;
          continue; // sem cotação daquele dia — ignora na soma de BTC
        }
        btc += portion / close;
      }

      result[currency] = BitcoinComparison(
        currency: currency,
        savedFiat: savedFiat,
        accumulatedBtc: btc,
        currentBtcPrice: currentPrice ?? 0,
      );
      if (currentPrice == null) incomplete = true;
    }

    return BitcoinComparisonResult(result, incomplete: incomplete);
  }
}
