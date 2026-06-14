import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../bitcoin/bitcoin_screen.dart';
import '../calendar/calendar_screen.dart';
import '../entry/entry_form_screen.dart';
import '../report/report_screen.dart';
import '../who_owes/who_owes_screen.dart';
import 'home_screen.dart';

/// Casca principal com navegação inferior.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  // Índices das abas em que o botão "Nova diária" aparece.
  static const _homeTab = 0;
  static const _calendarTab = 3;

  static const _screens = [
    HomeScreen(),
    ReportScreen(),
    WhoOwesScreen(),
    CalendarScreen(),
    BitcoinScreen(),
  ];

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  void _newEntry() {
    DateTime? initial;
    // Na aba Calendário, importa o dia selecionado (se houver).
    if (_index == _calendarTab) {
      final sel = ref.read(calendarSelectedDayProvider);
      if (sel != null) {
        final day = DateTime(sel.year, sel.month, sel.day);
        if (day.isAfter(_today())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).futureDateBlocked)),
          );
          return;
        }
        initial = day;
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EntryFormScreen(initialDate: initial)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // FAB só nas abas Início e Calendário.
    final showFab = _index == _homeTab || _index == _calendarTab;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: _newEntry,
              icon: const Icon(Icons.add),
              label: Text(t.newEntry),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t.navHome),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: t.navReport),
          NavigationDestination(
              icon: const Icon(Icons.person_search_outlined),
              selectedIcon: const Icon(Icons.person_search),
              label: t.navWhoOwes),
          NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: t.navCalendar),
          NavigationDestination(
              icon: const Icon(Icons.currency_bitcoin),
              selectedIcon: const Icon(Icons.currency_bitcoin),
              label: t.navBitcoin),
        ],
      ),
    );
  }
}
