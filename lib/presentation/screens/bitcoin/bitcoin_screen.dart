import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand.dart';
import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../../data/database/database.dart';
import '../../../domain/period.dart';
import '../../../domain/services/bitcoin_compare_service.dart';
import '../../../l10n/strings.dart';
import '../../providers/providers.dart';

/// Comparativo educativo "e se eu tivesse poupado em Bitcoin?" + meta de poupança.
class BitcoinScreen extends ConsumerWidget {
  const BitcoinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(periodTypeProvider);
    final anchor = ref.watch(periodAnchorProvider);
    final pct = ref.watch(settingsProvider).bitcoinSavingsPct;
    final comparison = ref.watch(bitcoinComparisonProvider);
    final goal = ref.watch(savingsGoalProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Bitcoin')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'E se você tivesse poupado ${(pct * 100).round()}% dos seus ganhos em Bitcoin?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // Período
          _periodNav(context, ref, type, anchor),
          comparison.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Não foi possível calcular agora: $e'),
            ),
            data: (result) => _comparisonBody(context, result),
          ),

          // Disclaimer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Brand.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Brand.orange),
                  SizedBox(width: 8),
                  Expanded(child: Text(S.btcDisclaimer, style: TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),

          // Botão referral
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              onPressed: _openBinance,
              icon: const Icon(Icons.currency_bitcoin),
              label: const Text(S.startSaving),
            ),
          ),

          const Divider(height: 40),

          // Meta de poupança
          _goalSection(context, ref, goal, type),
        ],
      ),
    );
  }

  Widget _periodNav(BuildContext context, WidgetRef ref, PeriodType type, DateTime anchor) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: PeriodType.values.map((t) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t.label),
                  selected: t == type,
                  onSelected: (_) => ref.read(periodTypeProvider.notifier).state = t,
                ),
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => ref.read(periodAnchorProvider.notifier).state =
                  PeriodCalculator.previousAnchor(type, anchor),
            ),
            Text(PeriodCalculator.label(type, anchor),
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
      ],
    );
  }

  Widget _comparisonBody(BuildContext context, BitcoinComparisonResult result) {
    if (result.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('Sem diárias no período para simular.'),
      );
    }
    return Column(
      children: [
        if (result.incomplete)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Resultado parcial: faltam cotações de alguns dias (sem internet).',
              style: TextStyle(fontSize: 12, color: Brand.pending),
            ),
          ),
        ...result.byCurrency.values.map((c) => _comparisonCard(context, c)),
      ],
    );
  }

  Widget _comparisonCard(BuildContext context, BitcoinComparison c) {
    final gainPositive = c.gainAbs >= 0;
    final color = gainPositive ? Brand.paid : Colors.redAccent;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Em ${c.currency.code}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Brand.orange)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _stat('Você teria poupado', Fmt.money(c.savedFiat, c.currency))),
                Expanded(
                    child: _stat('Valor hoje em Bitcoin', Fmt.money(c.currentValue, c.currency),
                        color: Brand.orange)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Bitcoin acumulado: ${Fmt.btc(c.accumulatedBtc)}',
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(gainPositive ? Icons.trending_up : Icons.trending_down, color: color),
                  const SizedBox(width: 8),
                  Text(gainPositive ? 'Valorização' : 'Desvalorização',
                      style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('${Fmt.money(c.gainAbs, c.currency)}  (${Fmt.signedPercent(c.gainPct)})',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  // ---- Meta de poupança ----

  Widget _goalSection(BuildContext context, WidgetRef ref, SavingsGoal? goal, PeriodType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_outlined, color: Brand.orange),
              const SizedBox(width: 8),
              const Text('Meta de poupança',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              TextButton(
                onPressed: () => _editGoal(context, ref, goal),
                child: Text(goal == null ? 'Definir' : 'Editar'),
              ),
            ],
          ),
          if (goal == null)
            const Text('Defina quanto quer guardar por período e acompanhe o avanço.',
                style: TextStyle(color: Colors.grey))
          else
            _goalProgress(context, ref, goal, type),
        ],
      ),
    );
  }

  Widget _goalProgress(BuildContext context, WidgetRef ref, SavingsGoal goal, PeriodType selectedType) {
    final goalType = _periodFromString(goal.period);
    final comparison = ref.watch(bitcoinComparisonProvider).value;
    final c = comparison?.byCurrency[goal.currency];
    // O progresso usa o "poupado em fiat" do período selecionado quando ele
    // bate com o período da meta.
    final saved = (goalType == selectedType) ? (c?.savedFiat ?? 0) : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meta: ${Fmt.money(goal.targetAmount, goal.currency)} por ${goalType.label.toLowerCase()}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (saved == null)
              Text('Selecione o período "${goalType.label}" acima para acompanhar a meta.',
                  style: const TextStyle(color: Brand.pending, fontSize: 12))
            else ...[
              LinearProgressIndicator(
                value: goal.targetAmount > 0
                    ? (saved / goal.targetAmount).clamp(0, 1).toDouble()
                    : 0,
                minHeight: 10,
                borderRadius: BorderRadius.circular(6),
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                color: Brand.orange,
              ),
              const SizedBox(height: 8),
              Text('Poupado: ${Fmt.money(saved, goal.currency)} de ${Fmt.money(goal.targetAmount, goal.currency)}'),
              if (c != null)
                Text('Equivalente hoje em Bitcoin: ${Fmt.money(c.currentValue, goal.currency)}',
                    style: const TextStyle(color: Brand.orange, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }

  PeriodType _periodFromString(String s) => switch (s) {
        'week' => PeriodType.week,
        'quarter' => PeriodType.quarter,
        'semester' => PeriodType.semester,
        'year' => PeriodType.year,
        _ => PeriodType.month,
      };

  Future<void> _editGoal(BuildContext context, WidgetRef ref, SavingsGoal? goal) async {
    final amountCtrl = TextEditingController(
        text: goal != null ? goal.targetAmount.toStringAsFixed(0) : '');
    var currency = goal?.currency ?? ref.read(settingsProvider).defaultCurrency;
    var period = goal?.period ?? 'month';

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Meta de poupança'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Quanto guardar',
                  prefixText: '${currency.symbol} ',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Moeda: '),
                  DropdownButton<Currency>(
                    value: currency,
                    onChanged: (v) => setLocal(() => currency = v!),
                    items: Currency.values
                        .map((c) => DropdownMenuItem(value: c, child: Text(c.code)))
                        .toList(),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: period,
                    onChanged: (v) => setLocal(() => period = v!),
                    items: const [
                      DropdownMenuItem(value: 'week', child: Text('Semana')),
                      DropdownMenuItem(value: 'month', child: Text('Mês')),
                      DropdownMenuItem(value: 'quarter', child: Text('Trimestre')),
                      DropdownMenuItem(value: 'semester', child: Text('Semestre')),
                      DropdownMenuItem(value: 'year', child: Text('Ano')),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            if (goal != null)
              TextButton(
                onPressed: () async {
                  await ref.read(databaseProvider).clearGoal();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Remover', style: TextStyle(color: Colors.red)),
              ),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                final amount =
                    double.tryParse(amountCtrl.text.replaceAll(',', '.').trim()) ?? 0;
                if (amount <= 0) return;
                await ref.read(databaseProvider).setGoal(SavingsGoalsCompanion.insert(
                      targetAmount: amount,
                      period: d.Value(period),
                      currency: d.Value(currency),
                    ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openBinance() async {
    await launchUrl(Uri.parse(AppConfig.binanceReferralUrl),
        mode: LaunchMode.externalApplication);
  }
}
