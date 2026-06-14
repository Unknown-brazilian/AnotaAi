import '../core/enums.dart';
import '../data/database/database.dart';
import 'calc.dart';

/// Totais de uma moeda dentro de um conjunto de diárias.
///
/// Moedas diferentes (EUR e GBP) NUNCA são somadas — cada uma tem seu próprio
/// [CurrencyTotals], conforme exigido no Extrato.
class CurrencyTotals {
  final Currency currency;
  double due = 0; // valor total do trabalho (bruto)
  double paid = 0; // total já recebido
  double toReceive = 0; // saldo a receber — desconsidera diárias já marcadas como recebidas
  int days = 0; // diárias (no modo diária, equivale a dias)
  double hours = 0; // horas (somadas dos registros por hora)
  int openCount = 0; // quantas diárias ainda em aberto

  CurrencyTotals(this.currency);

  /// Mantido por compatibilidade; igual a [toReceive] no fluxo normal.
  double get pending => toReceive;
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
      // "A receber" só conta o que NÃO foi marcado como recebido (saldo das
      // diárias em aberto). Diária marcada como paga é desconsiderada.
      if (!e.isPaid) {
        t.openCount += 1;
        final balance = e.amountDue - e.amountPaid;
        if (balance > 0) t.toReceive += balance;
      }
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

/// Um empregador na tela de gerenciamento: nome de exibição (já com `trim`),
/// quantas diárias tem e quais valores brutos de `employerName` caem neste
/// grupo (pode haver variações com espaços). Renomear/mesclar usa [rawNames]
/// para alcançar todas as variações de uma vez.
class EmployerGroup {
  /// Nome com `trim`; vazio significa "sem nome".
  final String displayName;
  final int count;
  final List<String> rawNames;

  EmployerGroup(this.displayName, this.count, this.rawNames);

  bool get isUnnamed => displayName.isEmpty;

  /// Agrupa as diárias por `employerName.trim()`, incluindo o grupo "sem nome"
  /// (entradas com nome vazio), ordenado por nome (sem nome por último).
  static List<EmployerGroup> fromEntries(List<WorkEntry> entries) {
    final groups = <String, ({int count, Set<String> raw})>{};
    for (final e in entries) {
      final key = e.employerName.trim();
      final g = groups.putIfAbsent(key, () => (count: 0, raw: <String>{}));
      groups[key] = (count: g.count + 1, raw: g.raw..add(e.employerName));
    }
    final result = groups.entries
        .map((kv) => EmployerGroup(kv.key, kv.value.count, kv.value.raw.toList()))
        .toList();
    result.sort((a, b) {
      if (a.isUnnamed != b.isUnnamed) return a.isUnnamed ? 1 : -1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    return result;
  }
}

/// Patrão na tela de gerenciamento/agenda: combina a contagem de diárias
/// (derivada das entradas) com o registro de contato da agenda ([info], pode
/// ser nulo). Um patrão pode aparecer só por ter diárias, só por estar na
/// agenda (cadastro proativo, 0 diárias), ou ambos.
class EmployerView {
  final String name; // nome com `trim`; vazio = "sem nome"
  final int entriesCount;
  final List<String> rawNames; // variações brutas vindas das diárias
  final Employer? info;

  EmployerView(this.name, this.entriesCount, this.rawNames, this.info);

  bool get isUnnamed => name.isEmpty;
  bool get hasContact =>
      info != null &&
      (info!.phone.trim().isNotEmpty || (info!.notes?.trim().isNotEmpty ?? false));

  /// Combina as diárias (agrupadas por nome) com a agenda de contatos.
  static List<EmployerView> combine(
      List<WorkEntry> entries, List<Employer> agenda) {
    final byName = {for (final e in agenda) e.name.trim(): e};
    final groups = EmployerGroup.fromEntries(entries);
    final seen = <String>{};
    final views = <EmployerView>[];
    for (final g in groups) {
      seen.add(g.displayName);
      views.add(EmployerView(
          g.displayName, g.count, g.rawNames, byName[g.displayName]));
    }
    // Patrões cadastrados na agenda sem nenhuma diária ainda.
    for (final e in agenda) {
      final n = e.name.trim();
      if (n.isEmpty || seen.contains(n)) continue;
      views.add(EmployerView(n, 0, [e.name], e));
    }
    views.sort((a, b) {
      if (a.isUnnamed != b.isUnnamed) return a.isUnnamed ? 1 : -1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return views;
  }
}
