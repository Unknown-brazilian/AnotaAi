// Teste de fumaça básico das funções de cálculo do AnotAí.
import 'package:flutter_test/flutter_test.dart';
import 'package:anotai/core/enums.dart';
import 'package:anotai/domain/calc.dart';

void main() {
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
