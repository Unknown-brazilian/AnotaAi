import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../l10n/strings.dart';
import '../../../domain/summary.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../entry/entry_form_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showBrl = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    _showBrl = _showBrl || settings.showBrl;
    final monthEntries = ref.watch(currentMonthEntriesProvider);
    final recent = ref.watch(allEntriesProvider);
    final brlRate = _showBrl
        ? ref.watch(brlRateProvider(settings.defaultCurrency)).value
        : null;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Image.asset(Brand.logoTwoTone, height: 28,
            color: Theme.of(context).brightness == Brightness.light
                ? Brand.black
                : null),
        actions: [
          IconButton(
            tooltip: S.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: monthEntries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (entries) {
          final summary = WorkSummary.fromEntries(entries);
          return ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text('Resumo do mês',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    Row(
                      children: [
                        const Text('R\$', style: TextStyle(fontSize: 13)),
                        Switch(
                          value: _showBrl,
                          onChanged: (v) => setState(() => _showBrl = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (summary.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: EmptyState(
                    icon: Icons.note_add_outlined,
                    message:
                        'Nenhuma diária neste mês ainda.\nToque em "Nova diária" para começar.',
                  ),
                )
              else
                ...summary.totals.map((t) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: CurrencyTotalsCard(totals: t, brlRate: brlRate),
                    )),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EntryFormScreen()),
                  ),
                  icon: const Icon(Icons.add, size: 26),
                  label: const Text('Nova diária'),
                ),
              ),
              if (_showBrl && brlRate == null)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Câmbio do Real indisponível agora (sem internet).',
                    style: TextStyle(fontSize: 12, color: Brand.pending),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text('Diárias recentes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...?recent.value?.take(10).map((e) => EntryTile(entry: e)),
              if ((recent.value ?? []).isEmpty)
                const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
