import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../core/format.dart';
import '../../../domain/services/report_data.dart';
import '../../../domain/summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../export/export_screen.dart';

/// Agrupa o saldo pendente por patrão — "quanto o fulano ainda me deve".
class WhoOwesScreen extends ConsumerWidget {
  const WhoOwesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final balances = ref.watch(employerBalancesProvider);
    final withPending = balances.where((b) => b.pendingSortKey > 0).toList();
    final settled = balances.where((b) => b.pendingSortKey <= 0).toList();

    return Scaffold(
      appBar: AppBar(title: Text(t.whoOwesMe)),
      body: balances.isEmpty
          ? EmptyState(
              icon: Icons.person_search,
              message: t.whoOwesEmpty)
          : ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                if (withPending.isNotEmpty) ...[
                  _SectionHeader(t.withOpenBalance),
                  ...withPending.map((b) => _EmployerCard(balance: b)),
                ],
                if (settled.isNotEmpty) ...[
                  _SectionHeader(t.allSettled),
                  ...settled.map((b) => _EmployerCard(balance: b)),
                ],
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );
}

class _EmployerCard extends StatelessWidget {
  final EmployerBalance balance;
  const _EmployerCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final openCount = balance.summary.totals.fold<int>(0, (s, x) => s + x.openCount);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.badge_outlined, color: Brand.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(balance.employerName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                if (openCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Brand.pending.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.openCount(openCount),
                        style: const TextStyle(color: Brand.pending, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ...balance.summary.totals.map((ct) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text('${ct.currency.code}:',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          children: [
                            Text(t.worked(Fmt.money(ct.due, ct.currency)),
                                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                            Text(t.receivedAmount(Fmt.money(ct.paid, ct.currency)),
                                style: const TextStyle(color: Brand.paid, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(Fmt.money(ct.pending, ct.currency),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Brand.pending, fontSize: 15)),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => _exportEmployer(context, balance),
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: Text(t.statementToCharge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportEmployer(BuildContext context, EmployerBalance b) {
    final t = AppLocalizations.of(context);
    final data = ReportData(
      title: t.employerStatementTitle(b.employerName),
      workerName: b.entries.isNotEmpty ? b.entries.first.workerName : '',
      periodLabel: t.employerLabel(b.employerName),
      entries: b.entries,
      summary: b.summary,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExportScreen(data: data)),
    );
  }
}
