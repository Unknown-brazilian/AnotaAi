// Teste de fumaça básico das funções de cálculo do AnotAí.
import 'package:flutter_test/flutter_test.dart';
import 'package:anotai/core/enums.dart';
import 'package:anotai/domain/calc.dart';
import 'package:anotai/domain/period.dart';

void main() {
  test('hasNext bloqueia avanço para o futuro, permite voltar do passado', () {
    final now = DateTime.now();
    // Período que contém hoje → não pode avançar (próximo é futuro).
    expect(PeriodCalculator.hasNext(PeriodType.month, now), isFalse);
    // Período passado → pode avançar.
    final twoMonthsAgo = DateTime(now.year, now.month - 2, 15);
    expect(PeriodCalculator.hasNext(PeriodType.month, twoMonthsAgo), isTrue);
  });

  test('horas trabalhadas considera turno que vira a meia-noite', () {
    // 22:00 -> 06:00 = 8h
    expect(WorkCalc.hoursWorked(22 * 60, 6 * 60), 8.0);
    // 08:00 -> 17:00 = 9h
    expect(WorkCalc.hoursWorked(8 * 60, 17 * 60), 9.0);
  });

  test('valor a receber no modo hora = horas x valor/hora', () {
    final due = WorkCalc.amountDue(
      mode: PaymentMode.hora,
      dailyRate: 0,
      hourlyRate: 12,
      startMinutes: 8 * 60,
      endMinutes: 16 * 60,
    );
    expect(due, 96.0);
  });
}
