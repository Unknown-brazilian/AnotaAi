import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/brand.dart';
import '../../../domain/services/report_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// Gera o extrato em PDF/XLS e oferece compartilhamento direto (WhatsApp etc.).
class ExportScreen extends ConsumerStatefulWidget {
  final ReportData data;
  const ExportScreen({super.key, required this.data});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).exportFail(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _safeName(String ext) {
    final base = widget.data.periodLabel
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    return 'anotai_extrato_$base.$ext';
  }

  Future<File> _writeTemp(String name, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _pdfShare() => _run(() async {
        final bytes = await ref.read(pdfExportServiceProvider).build(widget.data);
        final file = await _writeTemp(_safeName('pdf'), bytes);
        await SharePlus.instance.share(ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          text: '${widget.data.title} — ${widget.data.periodLabel}',
        ));
      });

  Future<void> _pdfPreview() => _run(() async {
        final bytes = await ref.read(pdfExportServiceProvider).build(widget.data);
        await Printing.layoutPdf(onLayout: (_) async => bytes, name: _safeName('pdf'));
      });

  Future<void> _xlsShare() => _run(() async {
        final bytes = await ref.read(xlsExportServiceProvider).build(widget.data);
        final file = await _writeTemp(_safeName('xlsx'), bytes);
        await SharePlus.instance.share(ShareParams(
          files: [
            XFile(file.path,
                mimeType:
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          ],
          text: '${widget.data.title} — ${widget.data.periodLabel}',
        ));
      });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final d = widget.data;
    return Scaffold(
      appBar: AppBar(title: Text(t.exportTitle)),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(d.periodLabel),
                      if (d.workerName.trim().isNotEmpty) Text('${t.worker}: ${d.workerName}'),
                      Text('${t.daysCount(d.entries.length)} · ${t.dayCount(d.summary.totalDays)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(t.pdfRecommended,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _busy ? null : _pdfShare,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(t.pdfGenerateShare),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : _pdfPreview,
                icon: const Icon(Icons.visibility),
                label: Text(t.pdfPreview),
              ),
              const Divider(height: 32),
              Text(t.spreadsheet, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy ? null : _xlsShare,
                icon: const Icon(Icons.table_chart),
                label: Text(t.xlsGenerateShare),
              ),
            ],
          ),
          if (_busy)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Brand.orange),
                    const SizedBox(height: 12),
                    Text(t.generatingFile, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
