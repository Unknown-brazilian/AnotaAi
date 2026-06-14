import 'package:flutter/material.dart';

import '../../core/brand.dart';
import '../../core/enums.dart';
import '../../core/format.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/database.dart';
import '../../domain/calc.dart';
import '../../domain/summary.dart';
import '../screens/detail/entry_detail_screen.dart';

/// Selo visual de pago/pendente.
class PaidBadge extends StatelessWidget {
  final bool isPaid;
  const PaidBadge({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final color = isPaid ? Brand.paid : Brand.pending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isPaid ? Icons.check_circle : Icons.schedule, size: 14, color: color),
          const SizedBox(width: 4),
          Text(isPaid ? t.paid : t.pending,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Item de lista de uma diária (abre o detalhe ao tocar).
class EntryTile extends StatelessWidget {
  final WorkEntry entry;
  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final hours = WorkCalc.hoursWorked(entry.startMinutes, entry.endMinutes);
    final subtitleParts = <String>[
      if (entry.placeName.trim().isNotEmpty) entry.placeName.trim(),
      if (entry.employerName.trim().isNotEmpty) entry.employerName.trim(),
      if (hours > 0) Fmt.hours(hours),
    ];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EntryDetailScreen(entryId: entry.id)),
        ),
        leading: CircleAvatar(
          backgroundColor: Brand.orange.withValues(alpha: 0.15),
          child: Text(
            '${entry.date.day}',
            style: const TextStyle(color: Brand.orange, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(Fmt.weekday(entry.date),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitleParts.isEmpty ? null : Text(subtitleParts.join(' · ')),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Fmt.money(entry.amountDue, entry.currency),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            PaidBadge(isPaid: entry.isPaid),
          ],
        ),
      ),
    );
  }
}

/// Cartão com os totais de uma moeda (a receber / recebido / pendente).
class CurrencyTotalsCard extends StatelessWidget {
  final CurrencyTotals totals;

  /// Taxa atual para BRL (quando o toggle "ver em Real" está ligado). Null
  /// quando desligado ou indisponível.
  final double? brlRate;

  const CurrencyTotalsCard({super.key, required this.totals, this.brlRate});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(t.inCurrency(totals.currency.code),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Brand.orange, fontSize: 16)),
                const Spacer(),
                Text(t.daysCount(totals.days),
                    style: TextStyle(color: Theme.of(context).hintColor)),
              ],
            ),
            if (totals.hours > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('${t.totalHours}: ${Fmt.hours(totals.hours)}',
                    style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
              ),
            const Divider(height: 20),
            // "A receber" = saldo em aberto (desconsidera o que já foi recebido).
            _line(context, t.toReceive, totals.pending, totals.currency, Brand.pending,
                bold: true),
            _line(context, t.received, totals.paid, totals.currency, Brand.paid),
          ],
        ),
      ),
    );
  }

  Widget _line(BuildContext context, String label, double value, Currency c,
      Color? color,
      {bool bold = false}) {
    final brl = brlRate == null ? null : value * brlRate!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: bold ? 15 : 14)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.money(value, c),
                  style: TextStyle(
                      fontSize: bold ? 17 : 15,
                      fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                      color: color)),
              if (brl != null)
                Text(Fmt.brl(brl),
                    style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mensagem de estado vazio.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
