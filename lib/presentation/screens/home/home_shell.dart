import 'package:flutter/material.dart';

import '../../../l10n/strings.dart';
import '../bitcoin/bitcoin_screen.dart';
import '../calendar/calendar_screen.dart';
import '../entry/entry_form_screen.dart';
import '../report/report_screen.dart';
import '../who_owes/who_owes_screen.dart';
import 'home_screen.dart';

/// Casca principal com navegação inferior.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    ReportScreen(),
    WhoOwesScreen(),
    CalendarScreen(),
    BitcoinScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EntryFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nova diária'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: S.navHome),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: S.navReport),
          NavigationDestination(
              icon: Icon(Icons.person_search_outlined),
              selectedIcon: Icon(Icons.person_search),
              label: 'Quem deve'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: S.navCalendar),
          NavigationDestination(
              icon: Icon(Icons.currency_bitcoin),
              selectedIcon: Icon(Icons.currency_bitcoin),
              label: S.navBitcoin),
        ],
      ),
    );
  }
}
