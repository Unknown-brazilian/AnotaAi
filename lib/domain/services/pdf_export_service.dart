import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/enums.dart';
import '../../core/format.dart';
import '../calc.dart';
import 'report_data.dart';

/// Gera o extrato em PDF — layout limpo, pensado para um leigo (o trabalhador
/// manda pro patrão ou guarda pro contador).
class PdfExportService {
  static const _orange = PdfColor.fromInt(0xFFF7931A);
  static const _black = PdfColor.fromInt(0xFF0D0D0D);
  static const _paid = PdfColor.fromInt(0xFF2E9E5B);
  static const _pending = PdfColor.fromInt(0xFFB37400);
  static const _grey = PdfColor.fromInt(0xFF666666);

  Future<Uint8List> build(ReportData data) async {
    final doc = pw.Document();
    final logo = await _loadLogo();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => ctx.pageNumber == 1 ? _header(data, logo) : pw.Container(),
        footer: (ctx) => _footer(ctx),
        build: (ctx) => [
          _infoBlock(data),
          pw.SizedBox(height: 14),
          _entriesTable(data),
          pw.SizedBox(height: 18),
          _totals(data),
        ],
      ),
    );
    return doc.save();
  }

  Future<pw.MemoryImage?> _loadLogo() async {
    try {
      final bytes = await rootBundle.load('assets/brand/logo_anotai_twotone.png');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  // Cabeçalho: faixa preta com o logo (twotone funciona em fundo escuro).
  pw.Widget _header(ReportData data, pw.MemoryImage? logo) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const pw.BoxDecoration(color: _black),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (logo != null)
            pw.Image(logo, height: 34)
          else
            pw.Text('AnotAí',
                style: pw.TextStyle(
                    color: _orange,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold)),
          pw.Text(data.title,
              style: const pw.TextStyle(
                  color: PdfColors.white, fontSize: 13)),
        ],
      ),
    );
  }

  pw.Widget _infoBlock(ReportData data) {
    pw.Widget line(String label, String value) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 3),
          child: pw.Row(children: [
            pw.SizedBox(
                width: 90,
                child: pw.Text(label,
                    style: const pw.TextStyle(color: _grey, fontSize: 10))),
            pw.Expanded(
                child: pw.Text(value,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold))),
          ]),
        );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (data.workerName.trim().isNotEmpty)
          line('Trabalhador', data.workerName),
        line('Período', data.periodLabel),
        line('Dias trabalhados', '${data.summary.totalDays}'),
      ],
    );
  }

  pw.Widget _entriesTable(ReportData data) {
    final headers = ['Data', 'Local', 'Patrão', 'Serviço', 'Horas', 'A receber', 'Pago', 'Status'];

    final rows = data.entries.map((e) {
      final hours = WorkCalc.hoursWorked(e.startMinutes, e.endMinutes);
      return [
        Fmt.date(e.date),
        e.placeName,
        e.employerName,
        e.serviceType,
        hours > 0 ? Fmt.hours(hours) : '—',
        Fmt.money(e.amountDue, e.currency),
        Fmt.money(e.amountPaid, e.currency),
        e.isPaid ? 'Pago' : 'Pendente',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle: pw.TextStyle(
          color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: _black),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellHeight: 20,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(52),
        4: const pw.FixedColumnWidth(38),
        5: const pw.FixedColumnWidth(58),
        6: const pw.FixedColumnWidth(52),
        7: const pw.FixedColumnWidth(48),
      },
    );
  }

  pw.Widget _totals(ReportData data) {
    final blocks = <pw.Widget>[];
    for (final t in data.summary.totals) {
      blocks.add(_currencyTotalBox(t.currency, t.due, t.paid, t.pending));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Totais',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Wrap(spacing: 12, runSpacing: 12, children: blocks),
        if (data.brlLine != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(data.brlLine!,
              style: const pw.TextStyle(fontSize: 10, color: _grey)),
        ],
      ],
    );
  }

  pw.Widget _currencyTotalBox(
      Currency c, double due, double paid, double pending) {
    pw.Widget row(String label, String value, PdfColor color) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(width: 16),
              pw.Text(value,
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold, color: color)),
            ],
          ),
        );
    return pw.Container(
      width: 200,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.7),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text('Em ${c.code}',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold, color: _orange)),
          pw.Divider(height: 8, color: PdfColors.grey300),
          row('A receber', Fmt.money(due, c), _black),
          row('Já recebido', Fmt.money(paid, c), _paid),
          row('Pendente', Fmt.money(pending, c), _pending),
        ],
      ),
    );
  }

  pw.Widget _footer(pw.Context ctx) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
        'Gerado pelo AnotAí · página ${ctx.pageNumber}/${ctx.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: _grey),
      ),
    );
  }
}
