import 'dart:typed_data';

import 'package:excel/excel.dart';

import '../../core/format.dart';
import '../calc.dart';
import 'report_data.dart';

/// Gera o extrato em planilha (.xlsx) usando o pacote `excel`.
class XlsExportService {
  Future<Uint8List> build(ReportData data) async {
    final excel = Excel.createExcel();
    final sheetName = 'Extrato';
    final sheet = excel[sheetName];
    // Remove a aba padrão "Sheet1" criada automaticamente.
    if (excel.sheets.containsKey('Sheet1') && sheetName != 'Sheet1') {
      excel.delete('Sheet1');
    }

    // Cabeçalho informativo.
    sheet.appendRow([TextCellValue(data.title)]);
    if (data.workerName.trim().isNotEmpty) {
      sheet.appendRow([TextCellValue('Trabalhador'), TextCellValue(data.workerName)]);
    }
    sheet.appendRow([TextCellValue('Período'), TextCellValue(data.periodLabel)]);
    sheet.appendRow([TextCellValue('Dias trabalhados'), IntCellValue(data.summary.totalDays)]);
    sheet.appendRow([]);

    // Tabela de diárias.
    sheet.appendRow([
      TextCellValue('Data'),
      TextCellValue('Local'),
      TextCellValue('Patrão'),
      TextCellValue('Serviço'),
      TextCellValue('Moeda'),
      TextCellValue('Horas'),
      TextCellValue('A receber'),
      TextCellValue('Pago'),
      TextCellValue('Status'),
    ]);

    for (final e in data.entries) {
      final hours = WorkCalc.hoursWorked(e.startMinutes, e.endMinutes);
      sheet.appendRow([
        TextCellValue(Fmt.date(e.date)),
        TextCellValue(e.placeName),
        TextCellValue(e.employerName),
        TextCellValue(e.serviceType),
        TextCellValue(e.currency.code),
        DoubleCellValue(double.parse(hours.toStringAsFixed(2))),
        DoubleCellValue(double.parse(e.amountDue.toStringAsFixed(2))),
        DoubleCellValue(double.parse(e.amountPaid.toStringAsFixed(2))),
        TextCellValue(e.isPaid ? 'Pago' : 'Pendente'),
      ]);
    }

    sheet.appendRow([]);
    // Totais por moeda (moedas diferentes ficam em linhas separadas).
    sheet.appendRow([TextCellValue('Totais por moeda')]);
    sheet.appendRow([
      TextCellValue('Moeda'),
      TextCellValue('A receber'),
      TextCellValue('Já recebido'),
      TextCellValue('Pendente'),
    ]);
    for (final t in data.summary.totals) {
      sheet.appendRow([
        TextCellValue(t.currency.code),
        DoubleCellValue(double.parse(t.due.toStringAsFixed(2))),
        DoubleCellValue(double.parse(t.paid.toStringAsFixed(2))),
        DoubleCellValue(double.parse(t.pending.toStringAsFixed(2))),
      ]);
    }
    if (data.brlLine != null) {
      sheet.appendRow([]);
      sheet.appendRow([TextCellValue(data.brlLine!)]);
    }

    final bytes = excel.encode();
    return Uint8List.fromList(bytes ?? <int>[]);
  }
}
