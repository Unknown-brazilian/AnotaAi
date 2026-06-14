import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../domain/summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';

/// Gerencia os nomes de patrões/empregadores (campo de texto livre
/// `employerName`). Renomear/mesclar é um UPDATE em massa; as demais telas leem
/// de streams reativos e se atualizam sozinhas. NÃO há tabela nova nem migração.
class EmployersScreen extends ConsumerStatefulWidget {
  const EmployersScreen({super.key});

  @override
  ConsumerState<EmployersScreen> createState() => _EmployersScreenState();
}

class _EmployersScreenState extends ConsumerState<EmployersScreen> {
  /// Nomes de exibição selecionados no modo de mesclagem.
  final Set<String> _selected = {};
  bool _selectionMode = false;

  void _toggleSelection(String displayName) {
    setState(() {
      if (_selected.contains(displayName)) {
        _selected.remove(displayName);
      } else {
        _selected.add(displayName);
      }
      if (_selected.isEmpty) _selectionMode = false;
    });
  }

  void _exitSelection() => setState(() {
        _selectionMode = false;
        _selected.clear();
      });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final employers = ref.watch(employersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectionMode ? t.selectedCount(_selected.length) : t.manageEmployers),
        leading: _selectionMode
            ? IconButton(icon: const Icon(Icons.close), onPressed: _exitSelection)
            : null,
        actions: [
          if (!_selectionMode && employers.length >= 2)
            IconButton(
              tooltip: t.merge,
              icon: const Icon(Icons.merge_type),
              onPressed: () => setState(() => _selectionMode = true),
            ),
        ],
      ),
      body: employers.isEmpty
          ? EmptyState(icon: Icons.badge_outlined, message: t.employersEmpty)
          : ListView(
              padding: const EdgeInsets.only(top: 4, bottom: 24),
              children: [
                if (_selectionMode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(t.selectToMerge,
                        style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
                  ),
                ...employers.map((e) => _EmployerTile(
                      group: e,
                      selectionMode: _selectionMode,
                      selected: _selected.contains(e.displayName),
                      onTap: () => _selectionMode
                          ? _toggleSelection(e.displayName)
                          : _rename(context, e),
                      onLongPress: _selectionMode
                          ? null
                          : () => setState(() {
                                _selectionMode = true;
                                _selected.add(e.displayName);
                              }),
                    )),
              ],
            ),
      floatingActionButton: _selectionMode && _selected.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () => _merge(context, employers),
              icon: const Icon(Icons.merge_type),
              label: Text(t.mergeInto),
            )
          : null,
    );
  }

  /// Diálogo de renomear (ou atribuir nome ao grupo "sem nome").
  Future<void> _rename(BuildContext context, EmployerGroup g) async {
    final t = AppLocalizations.of(context);
    final controller = TextEditingController(text: g.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => _NameDialog(
        title: g.isUnnamed ? t.assignName : t.renameEmployerTitle(g.displayName),
        initial: g.displayName,
        controller: controller,
      ),
    );
    if (newName == null) return;
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == g.displayName) return;

    // mergeEmployers cobre todas as variações brutas (ex.: com espaços) deste
    // grupo de uma vez; para "sem nome" as variações são valores vazios.
    final affected =
        await ref.read(databaseProvider).mergeEmployers(g.rawNames, trimmed);
    // O autocomplete é FutureProvider e precisa ser invalidado; as listas de
    // diárias (streams) atualizam sozinhas.
    ref.invalidate(employerSuggestionsProvider);
    if (context.mounted) _snack(context, t.employerRenamed(affected));
  }

  /// Mescla os nomes selecionados em um único nome final.
  Future<void> _merge(BuildContext context, List<EmployerGroup> all) async {
    final t = AppLocalizations.of(context);
    final selectedGroups =
        all.where((g) => _selected.contains(g.displayName)).toList();
    // Sugestões: os próprios nomes selecionados (sem o "sem nome").
    final options =
        selectedGroups.where((g) => !g.isUnnamed).map((g) => g.displayName).toList();
    final controller =
        TextEditingController(text: options.isNotEmpty ? options.first : '');

    final target = await showDialog<String>(
      context: context,
      builder: (ctx) => _MergeDialog(
        count: selectedGroups.length,
        options: options,
        controller: controller,
      ),
    );
    if (target == null) return;
    final trimmed = target.trim();
    if (trimmed.isEmpty) return;

    final fromRaw = selectedGroups.expand((g) => g.rawNames).toList();
    final affected = await ref.read(databaseProvider).mergeEmployers(fromRaw, trimmed);
    ref.invalidate(employerSuggestionsProvider);
    _exitSelection();
    if (context.mounted) _snack(context, t.employerRenamed(affected));
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _EmployerTile extends StatelessWidget {
  final EmployerGroup group;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _EmployerTile({
    required this.group,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final name = group.isUnnamed ? t.noName : group.displayName;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: selectionMode
            ? Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? Brand.orange : Theme.of(context).hintColor)
            : CircleAvatar(
                backgroundColor: Brand.orange.withValues(alpha: 0.15),
                child: const Icon(Icons.badge_outlined, color: Brand.orange, size: 20),
              ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: group.isUnnamed ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        subtitle: Text(t.daysCount(group.count)),
        trailing: selectionMode ? null : const Icon(Icons.edit_outlined, size: 20),
      ),
    );
  }
}

/// Diálogo simples de um campo de texto para (re)nomear.
class _NameDialog extends StatelessWidget {
  final String title;
  final String initial;
  final TextEditingController controller;

  const _NameDialog({required this.title, required this.initial, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: t.newEmployerName),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(t.save),
        ),
      ],
    );
  }
}

/// Diálogo de mesclagem: escolher o nome final entre os selecionados ou digitar.
class _MergeDialog extends StatefulWidget {
  final int count;
  final List<String> options;
  final TextEditingController controller;

  const _MergeDialog({required this.count, required this.options, required this.controller});

  @override
  State<_MergeDialog> createState() => _MergeDialogState();
}

class _MergeDialogState extends State<_MergeDialog> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(t.mergeIntoTitle(widget.count)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.mergeIntoHint, style: TextStyle(color: Theme.of(context).hintColor)),
          const SizedBox(height: 8),
          if (widget.options.isNotEmpty)
            Wrap(
              spacing: 8,
              children: widget.options
                  .map((o) => ActionChip(
                        label: Text(o),
                        onPressed: () => setState(() => widget.controller.text = o),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: t.newEmployerName),
            onSubmitted: (v) => Navigator.pop(context, v),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, widget.controller.text),
          child: Text(t.merge),
        ),
      ],
    );
  }
}
