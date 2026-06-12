import '../core/enums.dart';
import '../data/database/database.dart';
import 'calc.dart';

/// Totais de uma moeda dentro de um conjunto de diárias.
///
/// Moedas diferentes (EUR e GBP) NUNCA são somadas — cada uma tem seu próprio
/// [CurrencyTotals], conforme exigido no Extrato.
class CurrencyTotals {
  final Currency currency;
  double due = 0; // total a receber
  double paid = 0; // total já recebido
  int days = 0; // diárias (no modo diária, equivale a dias)
  double hours = 0; // horas (somadas dos registros por hora)
  int openCount = 0; // quantas diárias ainda em aberto

  CurrencyTotals(this.currency);

  double get pending => (due - paid).clamp(0, double.infinity);
}

/// Resumo agregado de um período (ou de um patrão).
class WorkSummary {
  final Map<Currency, CurrencyTotals> byCurrency = {};
  int totalDays = 0; // dias com pelo menos uma diária

  CurrencyTotals _of(Currency c) =>
      byCurrency.putIfAbsent(c, () => CurrencyTotals(c));

  bool get isEmpty => byCurrency.isEmpty;
  bool get isMultiCurrency => byCurrency.length > 1;

  List<CurrencyTotals> get totals =>
      byCurrency.values.toList()..sort((a, b) => a.currency.index - b.currency.index);

  /// Constrói o resumo a partir das diárias. [days] conta dias distintos.
  factory WorkSummary.fromEntries(List<WorkEntry> entries) {
    final s = WorkSummary._();
    final distinctDays = <String>{};
    for (final e in entries) {
      final t = s._of(e.currency);
      t.due += e.amountDue;
      t.paid += e.amountPaid;
      t.days += 1;
      t.hours += WorkCalc.hoursWorked(e.startMinutes, e.endMinutes);
      if (!e.isPaid) t.openCount += 1;
      distinctDays.add('${e.date.year}-${e.date.month}-${e.date.day}');
    }
    s.totalDays = distinctDays.length;
    return s;
  }

  WorkSummary._();
}

/// Saldo pendente agrupado por patrão (tela "Quem me deve").
class EmployerBalance {
  final String employerName;
  final WorkSummary summary;
  final List<WorkEntry> entries;

  EmployerBalance(this.employerName, this.summary, this.entries);

  /// Total pendente somando todas as moedas em aberto (apenas para ordenar a
  /// lista; a exibição continua separando por moeda).
  double get pendingSortKey =>
      summary.totals.fold(0.0, (sum, t) => sum + t.pending);

  static List<EmployerBalance> groupByEmployer(List<WorkEntry> entries) {
    final map = <String, List<WorkEntry>>{};
    for (final e in entries) {
      final name = e.employerName.trim().isEmpty ? 'Sem nome' : e.employerName.trim();
      map.putIfAbsent(name, () => []).add(e);
    }
    final result = map.entries
        .map((kv) => EmployerBalance(kv.key, WorkSummary.fromEntries(kv.value), kv.value))
        .toList();
    // Quem mais deve aparece primeiro.
    result.sort((a, b) => b.pendingSortKey.compareTo(a.pendingSortKey));
    return result;
  }
}
