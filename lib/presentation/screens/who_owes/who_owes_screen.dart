import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../core/format.dart';
import '../../../domain/services/report_data.dart';
import '../../../domain/summary.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../export/export_screen.dart';

/// Agrupa o saldo pendente por patrão — "quanto o fulano ainda me deve".
class WhoOwesScreen extends ConsumerWidget {
  const WhoOwesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(employerBalancesProvider);
    final withPending = balances.where((b) => b.pendingSortKey > 0).toList();
    final settled = balances.where((b) => b.pendingSortKey <= 0).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Quem me deve')),
      body: balances.isEmpty
          ? const EmptyState(
              icon: Icons.person_search,
              message: 'Cadastre diárias para ver quanto cada patrão te deve.')
          : ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                if (withPending.isNotEmpty) ...[
                  const _SectionHeader('Com saldo em aberto'),
                  ...withPending.map((b) => _EmployerCard(balance: b)),
                ],
                if (settled.isNotEmpty) ...[
                  const _SectionHeader('Tudo quitado'),
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
    final openCount = balance.summary.totals.fold<int>(0, (s, t) => s + t.openCount);
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
                    child: Text('$openCount em aberto',
                        style: const TextStyle(color: Brand.pending, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ...balance.summary.totals.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text('${t.currency.code}:',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          children: [
                            Text('Trabalhado ${Fmt.money(t.due, t.currency)}',
                                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
                            Text('Recebido ${Fmt.money(t.paid, t.currency)}',
                                style: const TextStyle(color: Brand.paid, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(Fmt.money(t.pending, t.currency),
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
                label: const Text('Extrato p/ cobrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportEmployer(BuildContext context, EmployerBalance b) {
    final data = ReportData(
      title: 'Extrato — ${b.employerName}',
      workerName: b.entries.isNotEmpty ? b.entries.first.workerName : '',
      periodLabel: 'Patrão: ${b.employerName}',
      entries: b.entries,
      summary: b.summary,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExportScreen(data: data)),
    );
  }
}
