import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/brand.dart';
import '../../../data/database/database.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';

/// Visão de calendário: marca os dias trabalhados (verde = pago, âmbar =
/// pendente) e abre as diárias do dia ao tocar.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  CalendarFormat _format = CalendarFormat.month;

  static DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final entries = ref.watch(allEntriesProvider).value ?? const [];
    final byDay = <DateTime, List<WorkEntry>>{};
    for (final e in entries) {
      byDay.putIfAbsent(_dayKey(e.date), () => []).add(e);
    }

    final selected = _selected;
    final dayEntries = selected == null ? const <WorkEntry>[] : (byDay[_dayKey(selected)] ?? const []);

    return Scaffold(
      appBar: AppBar(title: Text(t.calendar)),
      body: Column(
        children: [
          TableCalendar<WorkEntry>(
            locale: 'pt_BR',
            firstDay: DateTime(2015),
            // Sem dias futuros: não se registra diária no futuro.
            lastDay: DateTime.now(),
            focusedDay: _focused,
            calendarFormat: _format,
            availableCalendarFormats: {
              CalendarFormat.month: t.fmtMonth,
              CalendarFormat.twoWeeks: t.fmtTwoWeeks,
              CalendarFormat.week: t.fmtWeek,
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (d) => selected != null && isSameDay(selected, d),
            eventLoader: (d) => byDay[_dayKey(d)] ?? const [],
            onFormatChanged: (f) => setState(() => _format = f),
            onDaySelected: (sel, foc) {
              setState(() {
                _selected = sel;
                _focused = foc;
              });
              // Publica o dia para o FAB "Nova diária" importar a data.
              ref.read(calendarSelectedDayProvider.notifier).state = sel;
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Brand.orangeDark,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Brand.orange,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders<WorkEntry>(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();
                final allPaid = events.every((e) => e.isPaid);
                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: allPaid ? Brand.paid : Brand.pending,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selected == null
                ? EmptyState(
                    icon: Icons.touch_app,
                    message: t.tapADay)
                : dayEntries.isEmpty
                    ? EmptyState(
                        icon: Icons.event_busy, message: t.noEntriesDay)
                    : ListView(
                        children: dayEntries.map((e) => EntryTile(entry: e)).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
