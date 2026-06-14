import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../domain/summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// Formulário de adicionar/editar um patrão (nome + contato).
///
/// - Renomear o nome propaga para TODAS as diárias e mantém o contato ligado
///   (via `renameEmployerEverywhere`).
/// - Opcionalmente salva/atualiza o contato no aparelho (sync com Google).
class EmployerEditScreen extends ConsumerStatefulWidget {
  /// Patrão existente; null = novo cadastro.
  final EmployerView? existing;
  const EmployerEditScreen({super.key, this.existing});

  @override
  ConsumerState<EmployerEditScreen> createState() => _EmployerEditScreenState();
}

class _EmployerEditScreenState extends ConsumerState<EmployerEditScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _notes;

  String? _deviceContactId;
  late bool _syncToDevice;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final info = widget.existing?.info;
    // Para o grupo "sem nome" começa vazio (o usuário vai atribuir um nome).
    final initialName = (widget.existing?.isUnnamed ?? false)
        ? ''
        : (widget.existing?.name ?? '');
    _name = TextEditingController(text: initialName);
    _phone = TextEditingController(text: info?.phone ?? '');
    _notes = TextEditingController(text: info?.notes ?? '');
    _deviceContactId = info?.deviceContactId;
    _syncToDevice = _deviceContactId != null;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isNew = widget.existing == null;
    final hasContactRecord = widget.existing?.info != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? t.addEmployer : t.editEmployer),
        actions: [
          if (hasContactRecord)
            IconButton(
              tooltip: t.removeContact,
              icon: const Icon(Icons.delete_outline),
              onPressed: _saving ? null : _removeContact,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OutlinedButton.icon(
            onPressed: _saving ? null : _importFromContacts,
            icon: const Icon(Icons.contacts),
            label: Text(t.importFromContacts),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            autofocus: isNew,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: t.employerCompany,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: t.phoneField,
              prefixIcon: const Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: t.notes,
              prefixIcon: const Icon(Icons.notes),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            secondary: const Icon(Icons.sync),
            title: Text(t.syncToDevice),
            subtitle: Text(t.syncToDeviceSub),
            value: _syncToDevice,
            onChanged: _saving ? null : (v) => setState(() => _syncToDevice = v),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: Brand.orange, foregroundColor: Brand.black),
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Brand.black))
                : const Icon(Icons.save),
            label: Text(t.save),
          ),
        ],
      ),
    );
  }

  Future<void> _importFromContacts() async {
    final t = AppLocalizations.of(context);
    final picked = await ref.read(contactsServiceProvider).pickContact();
    if (picked == null) {
      if (mounted) _snack(t.contactsPermissionDenied);
      return;
    }
    setState(() {
      if (_name.text.trim().isEmpty) _name.text = picked.name;
      _phone.text = picked.phone;
      _deviceContactId = picked.id;
      _syncToDevice = true;
    });
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      _snack(t.nameEmptyError);
      return;
    }
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final orig = widget.existing;

    // Renomeia diárias + agenda quando o nome mudou (ou atribui nome ao grupo
    // "sem nome", cujas rawNames são valores vazios).
    if (orig != null && (orig.isUnnamed || orig.name != name)) {
      await db.renameEmployerEverywhere(orig.rawNames, name);
    }

    // Salva/atualiza no aparelho (e, por sync, na conta Google) se pedido.
    var contactId = _deviceContactId;
    if (_syncToDevice) {
      final saved = await ref.read(contactsServiceProvider).saveToDevice(
            existingId: contactId,
            name: name,
            phone: _phone.text,
          );
      if (saved != null) {
        contactId = saved;
      } else if (mounted) {
        _snack(t.contactsPermissionDenied);
      }
    }

    await db.upsertEmployer(
      name: name,
      phone: _phone.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      deviceContactId: contactId,
    );
    ref.invalidate(employerSuggestionsProvider);

    if (mounted) {
      _snack(t.contactSaved);
      Navigator.of(context).pop();
    }
  }

  Future<void> _removeContact() async {
    final t = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.removeContact),
        content: Text(t.removeContactConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true), child: Text(t.remove)),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(databaseProvider).deleteEmployerByName(widget.existing!.name);
    if (mounted) Navigator.of(context).pop();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
