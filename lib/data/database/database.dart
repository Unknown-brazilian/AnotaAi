import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../core/enums.dart';

part 'database.g.dart';

/// Registro de diária — tabela principal do app.
class WorkEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Dia do trabalho (normalizado para meia-noite local).
  DateTimeColumn get date => dateTime()();

  TextColumn get workerName => text().withDefault(const Constant(''))();
  TextColumn get employerName => text().withDefault(const Constant(''))();
  TextColumn get placeName => text().withDefault(const Constant(''))();
  TextColumn get serviceType => text().withDefault(const Constant(''))();

  IntColumn get paymentMode =>
      intEnum<PaymentMode>().withDefault(const Constant(0))();

  RealColumn get dailyRate => real().withDefault(const Constant(0))();
  RealColumn get hourlyRate => real().withDefault(const Constant(0))();

  IntColumn get currency => intEnum<Currency>().withDefault(const Constant(0))();

  /// Hora de entrada/saída como minutos desde a meia-noite (0–1439).
  /// Nulo quando o usuário não registrou horário.
  IntColumn get startMinutes => integer().nullable()();
  IntColumn get endMinutes => integer().nullable()();

  /// Valor a receber (derivado e persistido para facilitar agregações).
  RealColumn get amountDue => real().withDefault(const Constant(0))();

  /// Valor efetivamente pago (pode ser parcial).
  RealColumn get amountPaid => real().withDefault(const Constant(0))();

  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidDate => dateTime().nullable()();

  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get address => text().nullable()();

  /// Caminhos de fotos/comprovantes serializados como JSON (lista de strings).
  TextColumn get attachmentPaths => text().withDefault(const Constant('[]'))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Meta de poupança definida pelo usuário.
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get targetAmount => real()();

  /// Período da meta: 'week' | 'month' | 'quarter' | 'semester' | 'year'.
  TextColumn get period => text().withDefault(const Constant('month'))();
  IntColumn get currency => intEnum<Currency>().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Cache de cotações (Bitcoin e câmbio). Evita repetir chamadas de rede.
class PriceCaches extends Table {
  /// Par: 'BTCEUR', 'BTCGBP', 'EURBRL', 'GBPBRL'...
  TextColumn get pair => text()();

  /// Dia da cotação (meia-noite UTC). Para "cotação atual" usamos um registro
  /// especial com a data normalizada do dia corrente sobrescrito.
  DateTimeColumn get date => dateTime()();

  /// Preço de fechamento daquele dia.
  RealColumn get close => real()();

  @override
  Set<Column> get primaryKey => {pair, date};
}

@DriftDatabase(tables: [WorkEntries, SavingsGoals, PriceCaches])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Construtor usado em testes / restauração a partir de um arquivo específico.
  AppDatabase.forFile(File file) : super(NativeDatabase(file));

  /// Construtor para testes com um executor arbitrário (ex.: banco em memória).
  AppDatabase.forExecutor(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  // ---- WorkEntry CRUD ----

  Future<int> insertEntry(WorkEntriesCompanion entry) =>
      into(workEntries).insert(entry);

  Future<bool> updateEntry(WorkEntry entry) =>
      update(workEntries).replace(entry);

  Future<int> deleteEntry(int id) =>
      (delete(workEntries)..where((t) => t.id.equals(id))).go();

  Future<WorkEntry?> entryById(int id) =>
      (select(workEntries)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Todas as diárias, mais recentes primeiro.
  Stream<List<WorkEntry>> watchAllEntries() => (select(workEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();

  /// Diárias dentro de um intervalo [start, end) — usado nas agregações de
  /// período (semana/mês/trimestre/semestre/ano).
  Stream<List<WorkEntry>> watchEntriesBetween(DateTime start, DateTime end) {
    return (select(workEntries)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<List<WorkEntry>> entriesBetween(DateTime start, DateTime end) {
    return (select(workEntries)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Marca um conjunto de diárias como pagas/recebidas de uma vez (ação em lote
  /// usada na tela de Extrato: "selecionar de X a Y e marcar tudo").
  ///
  /// Ao marcar como pago, o valor recebido (`amountPaid`) passa a ser o valor
  /// devido integral; ao desmarcar, zera o recebido e a data de pagamento.
  Future<void> markPaidBulk(List<WorkEntry> entries,
      {required bool paid, DateTime? paidDate}) async {
    final when = paidDate ?? DateTime.now();
    await batch((b) {
      for (final e in entries) {
        b.update(
          workEntries,
          WorkEntriesCompanion(
            isPaid: Value(paid),
            amountPaid: Value(paid ? e.amountDue : 0),
            paidDate: Value(paid ? when : null),
          ),
          where: (t) => t.id.equals(e.id),
        );
      }
    });
  }

  // ---- Autocomplete: valores distintos do histórico ----

  Future<List<String>> distinctValues(GeneratedColumn<String> column) async {
    final query = selectOnly(workEntries, distinct: true)..addColumns([column]);
    final rows = await query.get();
    return rows
        .map((r) => r.read(column))
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .toList()
      ..sort();
  }

  Future<List<String>> distinctEmployers() => distinctValues(workEntries.employerName);
  Future<List<String>> distinctPlaces() => distinctValues(workEntries.placeName);
  Future<List<String>> distinctServiceTypes() => distinctValues(workEntries.serviceType);

  // ---- Gerenciamento de empregadores (renomear/mesclar em massa) ----
  //
  // Tudo opera sobre o campo de texto livre `employerName` — NÃO há tabela nova
  // nem mudança de schema. Como as telas leem de streams reativos
  // (`watchAllEntries`), um UPDATE em massa aqui propaga sozinho.

  /// Nomes de empregadores distintos (com `trim`, ignorando vazios) e a
  /// contagem de diárias de cada um, ordenado por nome.
  Future<List<({String name, int count})>> employersWithCounts() async {
    final count = workEntries.id.count();
    final query = selectOnly(workEntries)
      ..addColumns([workEntries.employerName, count])
      ..groupBy([workEntries.employerName])
      ..orderBy([OrderingTerm.asc(workEntries.employerName)]);
    final rows = await query.get();
    return rows
        .map((r) => (
              name: (r.read(workEntries.employerName) ?? '').trim(),
              count: r.read(count) ?? 0,
            ))
        .where((e) => e.name.isNotEmpty)
        .toList();
  }

  /// Renomeia em massa todas as diárias de [oldName] para [newName].
  /// Retorna o nº de linhas afetadas.
  Future<int> renameEmployer(String oldName, String newName) {
    return (update(workEntries)..where((t) => t.employerName.equals(oldName)))
        .write(WorkEntriesCompanion(employerName: Value(newName.trim())));
  }

  /// Mescla vários nomes ([fromNames]) em um só ([intoName]) — usado para
  /// juntar duplicados. Retorna o total de linhas afetadas.
  Future<int> mergeEmployers(List<String> fromNames, String intoName) async {
    final target = intoName.trim();
    var affected = 0;
    for (final from in fromNames) {
      if (from == target) continue;
      affected += await renameEmployer(from, target);
    }
    return affected;
  }

  // ---- SavingsGoal ----

  Future<SavingsGoal?> currentGoal() =>
      (select(savingsGoals)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .getSingleOrNull();

  Stream<SavingsGoal?> watchCurrentGoal() =>
      (select(savingsGoals)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watchSingleOrNull();

  Future<void> setGoal(SavingsGoalsCompanion goal) async {
    await delete(savingsGoals).go();
    await into(savingsGoals).insert(goal);
  }

  Future<void> clearGoal() => delete(savingsGoals).go();

  // ---- PriceCache ----

  Future<double?> cachedClose(String pair, DateTime day) async {
    final row = await (select(priceCaches)
          ..where((t) => t.pair.equals(pair) & t.date.equals(day)))
        .getSingleOrNull();
    return row?.close;
  }

  Future<void> cachePrice(String pair, DateTime day, double close) {
    return into(priceCaches).insertOnConflictUpdate(
      PriceCachesCompanion.insert(pair: pair, date: day, close: close),
    );
  }

  Future<void> cachePrices(String pair, Map<DateTime, double> closes) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        priceCaches,
        closes.entries
            .map((e) => PriceCachesCompanion.insert(
                pair: pair, date: e.key, close: e.value))
            .toList(),
      );
    });
  }
}

/// Abre o banco no diretório de documentos do app.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'anotai.sqlite'));
    // Garante que a lib nativa do sqlite3 seja carregada corretamente no Android.
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    return NativeDatabase.createInBackground(file);
  });
}
