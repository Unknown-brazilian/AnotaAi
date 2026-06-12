import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand.dart';
import '../../../core/format.dart';
import '../../../data/database/database.dart';
import '../../../domain/calc.dart';
import '../../../domain/services/location_service.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../entry/entry_form_screen.dart';

class EntryDetailScreen extends ConsumerWidget {
  final int entryId;
  const EntryDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(allEntriesProvider).value;
    final entry = entries?.where((e) => e.id == entryId).firstOrNull;

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(icon: Icons.search_off, message: 'Diária não encontrada.'),
      );
    }

    final hours = WorkCalc.hoursWorked(entry.startMinutes, entry.endMinutes);
    final attachments = (jsonDecode(entry.attachmentPaths) as List).cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diária'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EntryFormScreen(existing: entry)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _confirmDelete(context, ref, entry),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text(Fmt.money(entry.amountDue, entry.currency),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              PaidBadge(isPaid: entry.isPaid),
            ],
          ),
          const SizedBox(height: 4),
          Text(Fmt.weekday(entry.date),
              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16)),
          const Divider(height: 28),

          _row('Trabalhador', entry.workerName),
          _row('Patrão / empresa', entry.employerName),
          _row('Lugar / obra', entry.placeName),
          _row('Tipo de serviço', entry.serviceType),
          _row('Forma', entry.paymentMode.name == 'diaria' ? 'Por diária' : 'Por hora'),
          if (entry.startMinutes != null && entry.endMinutes != null)
            _row('Horário',
                '${Fmt.minutesToHHmm(entry.startMinutes!)} – ${Fmt.minutesToHHmm(entry.endMinutes!)}  (${Fmt.hours(hours)})'),
          _row('Já recebido', Fmt.money(entry.amountPaid, entry.currency)),
          if (!entry.isPaid)
            _row('Pendente',
                Fmt.money((entry.amountDue - entry.amountPaid).clamp(0, double.infinity), entry.currency)),
          if (entry.notes != null && entry.notes!.trim().isNotEmpty)
            _row('Observações', entry.notes!),

          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: entry.isPaid ? Brand.pending : Brand.paid,
            ),
            onPressed: () => ref
                .read(databaseProvider)
                .markPaidBulk([entry], paid: !entry.isPaid),
            icon: Icon(entry.isPaid ? Icons.schedule : Icons.check_circle),
            label: Text(entry.isPaid ? 'Marcar como pendente' : 'Marcar como pago'),
          ),

          // Localização
          if (entry.latitude != null && entry.longitude != null) ...[
            const Divider(height: 32),
            Text('Localização', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            if (entry.address != null) Text(entry.address!),
            Text('${entry.latitude!.toStringAsFixed(5)}, ${entry.longitude!.toStringAsFixed(5)}',
                style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openMaps(entry.latitude!, entry.longitude!),
                    icon: const Icon(Icons.map),
                    label: const Text('Abrir no Maps'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareLocation(entry),
                    icon: const Icon(Icons.share_location),
                    label: const Text('Compartilhar'),
                  ),
                ),
              ],
            ),
          ],

          // Fotos
          if (attachments.isNotEmpty) ...[
            const Divider(height: 32),
            Text('Fotos / comprovantes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _Attachments(filenames: attachments),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Future<void> _openMaps(double lat, double lng) async {
    final url = Uri.parse(LocationService.googleMapsUrl(lat, lng));
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareLocation(WorkEntry e) async {
    final url = LocationService.googleMapsUrl(e.latitude!, e.longitude!);
    final place = e.placeName.trim().isEmpty ? 'a obra' : e.placeName.trim();
    await SharePlus.instance.share(ShareParams(
      text: 'Local de $place:\n$url',
      subject: 'Localização da obra',
    ));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, WorkEntry e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir diária?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).deleteEntry(e.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _Attachments extends ConsumerWidget {
  final List<String> filenames;
  const _Attachments({required this.filenames});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(attachmentServiceProvider).dir(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox(height: 90);
        final dirPath = snap.data!.path;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filenames.map((name) {
            final path = p.join(dirPath, name);
            return GestureDetector(
              onTap: () => _viewFull(context, path),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _viewFull(BuildContext context, String path) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(
          child: InteractiveViewer(child: Image.file(File(path))),
        ),
      ),
    ));
  }
}
