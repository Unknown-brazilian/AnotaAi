import 'package:intl/intl.dart';

import '../core/format.dart';

/// Tipos de período suportados no Extrato/Relatório.
enum PeriodType { week, month, quarter, semester, year }

extension PeriodTypeLabel on PeriodType {
  String get label => switch (this) {
        PeriodType.week => 'Semana',
        PeriodType.month => 'Mês',
        PeriodType.quarter => 'Trimestre',
        PeriodType.semester => 'Semestre',
        PeriodType.year => 'Ano',
      };
}

/// Intervalo de datas meio-aberto: inclui [start], exclui [end].
///
/// Usar meio-aberto evita o clássico bug de "diária da meia-noite do último dia
/// contar duas vezes" nas agregações por período.
class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);

  bool contains(DateTime d) =>
      !d.isBefore(start) && d.isBefore(end);

  /// Dia "representativo" para rótulos (último dia do intervalo).
  DateTime get lastDay => end.subtract(const Duration(days: 1));
}

/// Calcula e navega por períodos a partir de uma data âncora.
class PeriodCalculator {
  /// Normaliza para meia-noite local (remove componente de hora).
  static DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Retorna o intervalo do período [type] que contém [anchor].
  static DateRange rangeFor(PeriodType type, DateTime anchor) {
    final a = dayStart(anchor);
    switch (type) {
      case PeriodType.week:
        // Semana de segunda a domingo (padrão pt-BR/Europa).
        final start = a.subtract(Duration(days: (a.weekday - DateTime.monday) % 7));
        return DateRange(start, start.add(const Duration(days: 7)));
      case PeriodType.month:
        final start = DateTime(a.year, a.month, 1);
        final end = DateTime(a.year, a.month + 1, 1);
        return DateRange(start, end);
      case PeriodType.quarter:
        final q = ((a.month - 1) ~/ 3); // 0..3
        final startMonth = q * 3 + 1;
        final start = DateTime(a.year, startMonth, 1);
        final end = DateTime(a.year, startMonth + 3, 1);
        return DateRange(start, end);
      case PeriodType.semester:
        final startMonth = a.month <= 6 ? 1 : 7;
        final start = DateTime(a.year, startMonth, 1);
        final end = DateTime(a.year, startMonth + 6, 1);
        return DateRange(start, end);
      case PeriodType.year:
        return DateRange(DateTime(a.year, 1, 1), DateTime(a.year + 1, 1, 1));
    }
  }

  /// Move a âncora para o período anterior (para navegação).
  static DateTime previousAnchor(PeriodType type, DateTime anchor) {
    final r = rangeFor(type, anchor);
    return r.start.subtract(const Duration(days: 1));
  }

  /// Move a âncora para o próximo período.
  static DateTime nextAnchor(PeriodType type, DateTime anchor) {
    final r = rangeFor(type, anchor);
    return r.end; // primeiro dia do período seguinte
  }

  /// Verdadeiro quando dá para avançar — ou seja, o próximo período NÃO começa
  /// no futuro. Usado para desabilitar o botão ">" no período atual.
  static bool hasNext(PeriodType type, DateTime anchor) {
    final nextStart = nextAnchor(type, anchor); // 1º dia do período seguinte
    return !nextStart.isAfter(dayStart(DateTime.now()));
  }

  /// Rótulo amigável do período (ex.: "Junho 2026", "1º Tri 2026").
  static String label(PeriodType type, DateTime anchor) {
    final r = rangeFor(type, anchor);
    switch (type) {
      case PeriodType.week:
        final df = DateFormat('dd/MM', Fmt.locale);
        return '${df.format(r.start)} – ${df.format(r.lastDay)}';
      case PeriodType.month:
        return toBeginningOfSentenceCase(
            DateFormat('MMMM yyyy', Fmt.locale).format(r.start))!;
      case PeriodType.quarter:
        final q = ((r.start.month - 1) ~/ 3) + 1;
        return '$qº Tri ${r.start.year}';
      case PeriodType.semester:
        final s = r.start.month <= 6 ? 1 : 2;
        return '$sº Sem ${r.start.year}';
      case PeriodType.year:
        return '${r.start.year}';
    }
  }
}
