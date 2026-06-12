import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../domain/services/settings_service.dart';
import '../../providers/providers.dart';

/// Painel do usuário — o ÚNICO lugar onde o nome e a segurança (PIN/biometria)
/// podem ser alterados depois do cadastro inicial.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do usuário')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Brand.orange.withValues(alpha: 0.18),
              child: Text(
                _initials(s.defaultWorkerName),
                style: const TextStyle(
                    color: Brand.orange, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              s.defaultWorkerName.isEmpty ? 'Sem nome' : s.defaultWorkerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),

          _header('Identidade'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Nome'),
            subtitle: Text(s.defaultWorkerName.isEmpty ? 'Não definido' : s.defaultWorkerName),
            trailing: const Icon(Icons.edit),
            onTap: () => _editName(context, ref, s),
          ),

          _header('Segurança'),
          SwitchListTile(
            secondary: const Icon(Icons.pin),
            title: const Text('Bloqueio por PIN'),
            subtitle: Text(s.pinEnabled ? 'Ativado' : 'Desativado'),
            value: s.pinEnabled,
            onChanged: (v) => _togglePin(context, ref, s, v),
          ),
          if (s.pinEnabled)
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Alterar PIN'),
              onTap: () => _togglePin(context, ref, s, true, forceChange: true),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Bloqueio por biometria'),
            subtitle: const Text('Digital ou rosto do aparelho'),
            value: s.biometricEnabled,
            onChanged: (v) => _toggleBiometric(context, ref, s, v),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '🙂';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(text,
            style: const TextStyle(
                color: Brand.orange, fontWeight: FontWeight.bold, fontSize: 13)),
      );

  Future<void> _editName(BuildContext context, WidgetRef ref, AppSettings s) async {
    final ctrl = TextEditingController(text: s.defaultWorkerName);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seu nome'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Salvar')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await ref.read(settingsProvider.notifier).update(s.copyWith(defaultWorkerName: result));
    }
  }

  Future<void> _togglePin(BuildContext context, WidgetRef ref, AppSettings s, bool enable,
      {bool forceChange = false}) async {
    final service = ref.read(settingsServiceProvider);
    if (!enable) {
      await service.clearPin();
      await ref.read(settingsProvider.notifier).update(s.copyWith(pinEnabled: false));
      return;
    }
    final ctrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(forceChange ? 'Alterar PIN' : 'Definir PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              autofocus: true,
              maxLength: 8,
              decoration: const InputDecoration(labelText: 'PIN (mín. 4 dígitos)'),
            ),
            TextField(
              controller: confirmCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 8,
              decoration: const InputDecoration(labelText: 'Confirme o PIN'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final a = ctrl.text.trim();
              final b = confirmCtrl.text.trim();
              if (a.length < 4) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('O PIN precisa ter ao menos 4 dígitos.')));
                return;
              }
              if (a != b) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Os PINs não conferem.')));
                return;
              }
              Navigator.pop(ctx, a);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (pin != null) {
      await service.setPin(pin);
      await ref.read(settingsProvider.notifier).update(s.copyWith(pinEnabled: true));
    }
  }

  Future<void> _toggleBiometric(
      BuildContext context, WidgetRef ref, AppSettings s, bool enable) async {
    if (!enable) {
      await ref.read(settingsProvider.notifier).update(s.copyWith(biometricEnabled: false));
      return;
    }
    final can = await ref.read(authServiceProvider).canCheckBiometrics();
    if (!can) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este aparelho não tem biometria configurada.')));
      }
      return;
    }
    await ref.read(settingsProvider.notifier).update(s.copyWith(biometricEnabled: true));
  }
}
