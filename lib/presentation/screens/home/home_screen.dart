import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/summary.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import '../entry/entry_form_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late bool _showBrl;

  @override
  void initState() {
    super.initState();
    // Valor inicial vem da configuração; depois o toggle é controlado localmente
    // (pode ser ligado/desligado sem ficar preso na config global).
    _showBrl = ref.read(settingsProvider).showBrl;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
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
            tooltip: t.profileShort,
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            tooltip: t.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: monthEntries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(t.error(e))),
        data: (entries) {
          final summary = WorkSummary.fromEntries(entries);
          return ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(t.monthSummary,
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
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: EmptyState(
                    icon: Icons.note_add_outlined,
                    message: t.noEntriesMonth,
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
                  label: Text(t.newEntry),
                ),
              ),
              if (_showBrl && brlRate == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    t.brlUnavailable,
                    style: const TextStyle(fontSize: 12, color: Brand.pending),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(t.recentEntries,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
