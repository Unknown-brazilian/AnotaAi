import '../core/enums.dart';

/// Cálculos de horas e de valor a receber de uma diária.
class WorkCalc {
  WorkCalc._();

  /// Horas trabalhadas a partir de minutos de entrada/saída (0–1439).
  ///
  /// Se a saída for menor que a entrada, assume-se que o turno virou a
  /// meia-noite (ex.: entrou 22:00, saiu 06:00 → 8h).
  static double hoursWorked(int? startMinutes, int? endMinutes) {
    if (startMinutes == null || endMinutes == null) return 0;
    var diff = endMinutes - startMinutes;
    if (diff < 0) diff += 24 * 60; // turno que cruza a meia-noite
    return diff / 60.0;
  }

  /// Valor a receber derivado do modo de pagamento.
  ///
  /// - Modo diária: o próprio valor da diária.
  /// - Modo hora: horas trabalhadas × valor/hora.
  static double amountDue({
    required PaymentMode mode,
    required double dailyRate,
    required double hourlyRate,
    int? startMinutes,
    int? endMinutes,
  }) {
    switch (mode) {
      case PaymentMode.diaria:
        return dailyRate;
      case PaymentMode.hora:
        return hoursWorked(startMinutes, endMinutes) * hourlyRate;
    }
  }

  /// Formata horas como "8h" ou "8h30".
  static String formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return m == 0 ? '${h}h' : '${h}h${m.toString().padLeft(2, '0')}';
  }
}
