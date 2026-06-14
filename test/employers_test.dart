// Testes do gerenciamento de empregadores: DAO de renomear/mesclar (em massa,
// sobre o campo `employerName`) e o agrupamento usado na tela.
import 'package:anotai/core/enums.dart';
import 'package:anotai/data/database/database.dart';
import 'package:anotai/domain/summary.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forExecutor(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  WorkEntriesCompanion entryFor(String employer, {bool paid = false}) {
    return WorkEntriesCompanion.insert(
      date: DateTime(2026, 1, 1),
      employerName: Value(employer),
      currency: const Value(Currency.eur),
      dailyRate: const Value(100),
      amountDue: const Value(100),
      amountPaid: Value(paid ? 100 : 0),
      isPaid: Value(paid),
    );
  }

  test('renameEmployer atualiza todas as diárias do nome antigo', () async {
    await db.insertEntry(entryFor('Thiago Morais'));
    await db.insertEntry(entryFor('Thiago Morais'));
    await db.insertEntry(entryFor('Outro'));

    final affected = await db.renameEmployer('Thiago Morais', 'Cliente X');
    expect(affected, 2);

    final all = await db.select(db.workEntries).get();
    expect(all.where((e) => e.employerName == 'Cliente X').length, 2);
    expect(all.where((e) => e.employerName == 'Thiago Morais').length, 0);
  });

  test('mergeEmployers junta vários nomes em um só', () async {
    await db.insertEntry(entryFor('Joao'));
    await db.insertEntry(entryFor('João'));
    await db.insertEntry(entryFor('JOAO'));

    final affected = await db.mergeEmployers(['Joao', 'João', 'JOAO'], 'João Silva');
    expect(affected, 3);

    final counts = await db.employersWithCounts();
    expect(counts.length, 1);
    expect(counts.first.name, 'João Silva');
    expect(counts.first.count, 3);
  });

  test('employersWithCounts ignora vazios e conta certo', () async {
    await db.insertEntry(entryFor('A'));
    await db.insertEntry(entryFor('A'));
    await db.insertEntry(entryFor('B'));
    await db.insertEntry(entryFor('')); // sem nome → não entra na lista

    final counts = await db.employersWithCounts();
    final map = {for (final c in counts) c.name: c.count};
    expect(map, {'A': 2, 'B': 1});
  });

  test('EmployerGroup.fromEntries agrupa por trim e isola "sem nome"', () async {
    await db.insertEntry(entryFor('Cliente'));
    await db.insertEntry(entryFor('Cliente ')); // variação com espaço
    await db.insertEntry(entryFor(''));

    final entries = await db.watchAllEntries().first;
    final groups = EmployerGroup.fromEntries(entries);

    expect(groups.length, 2);
    final cliente = groups.firstWhere((g) => g.displayName == 'Cliente');
    expect(cliente.count, 2);
    // As duas variações brutas ("Cliente" e "Cliente ") ficam no mesmo grupo.
    expect(cliente.rawNames.toSet(), {'Cliente', 'Cliente '});
    // "Sem nome" vai por último.
    expect(groups.last.isUnnamed, isTrue);
  });

  test('renomear o grupo "sem nome" atribui nome às diárias vazias', () async {
    await db.insertEntry(entryFor(''));
    await db.insertEntry(entryFor(''));

    final affected = await db.mergeEmployers([''], 'Novo Cliente');
    expect(affected, 2);

    final counts = await db.employersWithCounts();
    expect(counts.single.name, 'Novo Cliente');
    expect(counts.single.count, 2);
  });
}
