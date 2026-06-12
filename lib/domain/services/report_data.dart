import '../../data/database/database.dart';
import '../summary.dart';

/// Dados prontos para exportação (PDF/XLS) — montados pela tela de Extrato ou
/// pela tela "Quem me deve" (extrato de um patrão).
class ReportData {
  /// Ex.: "Extrato de diárias" ou "Extrato — João da Construtora".
  final String title;

  /// Nome do trabalhador (cabeçalho).
  final String workerName;

  /// Período legível (ex.: "Junho 2026" ou "Todas as diárias em aberto").
  final String periodLabel;

  final List<WorkEntry> entries;
  final WorkSummary summary;

  /// Linha opcional com conversão em BRL (já formatada), quando o toggle estiver
  /// ligado.
  final String? brlLine;

  ReportData({
    required this.title,
    required this.workerName,
    required this.periodLabel,
    required this.entries,
    required this.summary,
    this.brlLine,
  });
}
