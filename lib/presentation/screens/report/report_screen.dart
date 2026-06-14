import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../core/format.dart';
import '../../../data/database/database.dart';
import '../../../domain/period.dart';
import '../../../domain/services/report_data.dart';
import '../../../domain/summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../export/export_screen.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool _showBrl = false;
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final type = ref.watch(periodTypeProvider);
    final anchor = ref.watch(periodAnchorProvider);
    final entriesAsync = ref.watch(entriesInPeriodProvider);
    final summary = ref.watch(periodSummaryProvider);
    final settings = ref.watch(settingsProvider);
    final brlRate = _showBrl
        ? ref.watch(brlRateProvider(settings.defaultCurrency)).value
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.navReport),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: t.export,
            onPressed: summary.isEmpty
                ? null
                : () => _openExport(entriesAsync.value ?? [], summary, type, anchor, settings.defaultWorkerName),
          ),
        ],
      ),
      body: Column(
        children: [
          _periodSelector(context, type),
          _periodNav(type, anchor),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(t.error(e))),
              data: (entries) {
                return ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    // Toggle BRL
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(t.showInBrl),
                          const Spacer(),
                          Switch(value: _showBrl, onChanged: (v) => setState(() => _showBrl = v)),
                        ],
                      ),
                    ),
                    if (summary.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: EmptyState(
                          icon: Icons.receipt_long,
                          message: t.noEntriesPeriod,
                        ),
                      )
                    else ...[
                      if (summary.isMultiCurrency)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            t.multiCurrencyNote,
                            style: const TextStyle(fontSize: 12, color: Brand.pending),
                          ),
                        ),
                      ...summary.totals.map((t) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: CurrencyTotalsCard(totals: t, brlRate: brlRate),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(t.entries,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      ...entries.map((e) => _selectableTile(e)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selected.isEmpty
          ? null
          : _bulkBar(entriesAsync.value ?? []),
    );
  }

  Widget _periodSelector(BuildContext context, PeriodType type) {
    final loc = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: PeriodType.values.map((pt) {
          final sel = pt == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(loc.periodName(pt)),
              selected: sel,
              onSelected: (_) => ref.read(periodTypeProvider.notifier).state = pt,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _periodNav(PeriodType type, DateTime anchor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => ref.read(periodAnchorProvider.notifier).state =
                PeriodCalculator.previousAnchor(type, anchor),
          ),
          Text(PeriodCalculator.label(type, anchor),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            // Não navega para períodos futuros.
            onPressed: PeriodCalculator.hasNext(type, anchor)
                ? () => ref.read(periodAnchorProvider.notifier).state =
                    PeriodCalculator.nextAnchor(type, anchor)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _selectableTile(WorkEntry entry) {
    final selected = _selected.contains(entry.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Card(
        color: selected ? Brand.orange.withValues(alpha: 0.12) : null,
        child: ListTile(
          leading: Checkbox(
            value: selected,
            onChanged: (v) => setState(() {
              v == true ? _selected.add(entry.id) : _selected.remove(entry.id);
            }),
          ),
          title: Text(Fmt.date(entry.date)),
          subtitle: Text([
            if (entry.employerName.toString().trim().isNotEmpty) entry.employerName,
            if (entry.placeName.toString().trim().isNotEmpty) entry.placeName,
          ].join(' · ')),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.money(entry.amountDue, entry.currency),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              PaidBadge(isPaid: entry.isPaid),
            ],
          ),
          onTap: () => setState(() {
            selected ? _selected.remove(entry.id) : _selected.add(entry.id);
          }),
        ),
      ),
    );
  }

  Widget _bulkBar(List entries) {
    final t = AppLocalizations.of(context);
    final selectedEntries = entries.where((e) => _selected.contains(e.id)).toList();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Row(
          children: [
            Text(t.selectedCount(_selected.length)),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await ref.read(databaseProvider).markPaidBulk(
                    selectedEntries.cast(), paid: false);
                setState(_selected.clear);
              },
              child: Text(t.pending),
            ),
            const SizedBox(width: 4),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(databaseProvider).markPaidBulk(
                    selectedEntries.cast(), paid: true);
                setState(_selected.clear);
              },
              icon: const Icon(Icons.check),
              label: Text(t.markPaidShort),
            ),
          ],
        ),
      ),
    );
  }

  void _openExport(List entries, WorkSummary summary, PeriodType type,
      DateTime anchor, String worker) {
    final t = AppLocalizations.of(context);
    final data = ReportData(
      title: t.statementTitle,
      workerName: worker,
      periodLabel: t.periodLabelFull(type, PeriodCalculator.label(type, anchor)),
      entries: entries.cast(),
      summary: summary,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExportScreen(data: data)),
    );
  }
}
