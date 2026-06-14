import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/brand.dart';
import '../../../domain/summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/common.dart';
import 'employer_edit_screen.dart';

/// Agenda/histórico de patrões: nomes + contatos (telefone/WhatsApp/observações),
/// ligada ao campo de texto livre `employerName` das diárias pelo nome. Permite
/// adicionar, editar, renomear (propaga para todas as diárias) e mesclar.
class EmployersScreen extends ConsumerStatefulWidget {
  const EmployersScreen({super.key});

  @override
  ConsumerState<EmployersScreen> createState() => _EmployersScreenState();
}

class _EmployersScreenState extends ConsumerState<EmployersScreen> {
  final Set<String> _selected = {};
  bool _selectionMode = false;

  void _toggleSelection(String name) {
    setState(() {
      _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
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
        title: Text(
            _selectionMode ? t.selectedCount(_selected.length) : t.manageEmployers),
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
              padding: const EdgeInsets.only(top: 4, bottom: 96),
              children: [
                if (_selectionMode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(t.selectToMerge,
                        style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 13)),
                  ),
                ...employers.map((e) => _EmployerTile(
                      view: e,
                      selectionMode: _selectionMode,
                      selected: _selected.contains(e.name),
                      onTap: () => _selectionMode
                          ? _toggleSelection(e.name)
                          : _openEdit(e),
                      onLongPress: _selectionMode
                          ? null
                          : () => setState(() {
                                _selectionMode = true;
                                _selected.add(e.name);
                              }),
                    )),
              ],
            ),
      floatingActionButton: _selectionMode
          ? (_selected.length >= 2
              ? FloatingActionButton.extended(
                  onPressed: () => _merge(employers),
                  icon: const Icon(Icons.merge_type),
                  label: Text(t.mergeInto),
                )
              : null)
          : FloatingActionButton.extended(
              onPressed: () => _openEdit(null),
              icon: const Icon(Icons.person_add_alt),
              label: Text(t.addEmployer),
            ),
    );
  }

  void _openEdit(EmployerView? view) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EmployerEditScreen(existing: view)),
    );
  }

  Future<void> _merge(List<EmployerView> all) async {
    final t = AppLocalizations.of(context);
    final selected = all.where((g) => _selected.contains(g.name)).toList();
    final options = selected.where((g) => !g.isUnnamed).map((g) => g.name).toList();
    final controller =
        TextEditingController(text: options.isNotEmpty ? options.first : '');

    final target = await showDialog<String>(
      context: context,
      builder: (_) => _MergeDialog(
          count: selected.length, options: options, controller: controller),
    );
    if (target == null) return;
    final trimmed = target.trim();
    if (trimmed.isEmpty) return;

    final fromRaw = selected.expand((g) => g.rawNames).toList();
    final affected =
        await ref.read(databaseProvider).renameEmployerEverywhere(fromRaw, trimmed);
    ref.invalidate(employerSuggestionsProvider);
    _exitSelection();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.employerRenamed(affected))));
    }
  }
}

class _EmployerTile extends StatelessWidget {
  final EmployerView view;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _EmployerTile({
    required this.view,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final name = view.isUnnamed ? t.noName : view.name;
    final phone = view.info?.phone.trim() ?? '';
    final subtitleParts = <String>[
      view.entriesCount > 0 ? t.daysCount(view.entriesCount) : t.noEntriesYet,
      if (phone.isNotEmpty) phone,
    ];
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
            fontStyle: view.isUnnamed ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        subtitle: Text(subtitleParts.join(' · ')),
        trailing: selectionMode
            ? null
            : (phone.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: t.call,
                        icon: const Icon(Icons.call, color: Brand.paid, size: 22),
                        onPressed: () =>
                            launchPhone(context, Uri.parse('tel:$phone')),
                      ),
                      IconButton(
                        tooltip: t.whatsapp,
                        icon: const Icon(Icons.chat, color: Brand.paid, size: 22),
                        onPressed: () => launchPhone(context,
                            Uri.parse('https://wa.me/${digitsOnly(phone)}')),
                      ),
                    ],
                  )
                : const Icon(Icons.chevron_right)),
      ),
    );
  }
}

/// Diálogo de mesclagem: escolher o nome final entre os selecionados ou digitar.
class _MergeDialog extends StatefulWidget {
  final int count;
  final List<String> options;
  final TextEditingController controller;
  const _MergeDialog(
      {required this.count, required this.options, required this.controller});

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
                        onPressed: () =>
                            setState(() => widget.controller.text = o),
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

/// Só dígitos — para montar o link do WhatsApp (`wa.me/<numero>`).
String digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

/// Abre tel:/wa.me com fallback de SnackBar se não houver app que atenda.
Future<void> launchPhone(BuildContext context, Uri uri) async {
  final t = AppLocalizations.of(context);
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.couldNotLaunch)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.couldNotLaunch)));
    }
  }
}
