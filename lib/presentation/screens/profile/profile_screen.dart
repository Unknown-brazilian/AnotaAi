import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../domain/services/settings_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// Painel do usuário — o ÚNICO lugar onde o nome e a segurança (PIN/biometria)
/// podem ser alterados depois do cadastro inicial.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
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
              s.defaultWorkerName.isEmpty ? t.noName : s.defaultWorkerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),

          _header(t.identity),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(t.name),
            subtitle: Text(s.defaultWorkerName.isEmpty ? t.notSet : s.defaultWorkerName),
            trailing: const Icon(Icons.edit),
            onTap: () => _editName(context, ref, s),
          ),

          _header(t.security),
          SwitchListTile(
            secondary: const Icon(Icons.pin),
            title: Text(t.pinLock),
            subtitle: Text(s.pinEnabled ? t.enabled : t.disabled),
            value: s.pinEnabled,
            onChanged: (v) => _togglePin(context, ref, s, v),
          ),
          if (s.pinEnabled)
            ListTile(
              leading: const Icon(Icons.password),
              title: Text(t.changePin),
              onTap: () => _togglePin(context, ref, s, true, forceChange: true),
            ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(t.biometricLock),
            subtitle: Text(t.biometricsSub),
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
    final t = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: s.defaultWorkerName);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.yourName),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: t.name),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: Text(t.save)),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await ref.read(settingsProvider.notifier).update(s.copyWith(defaultWorkerName: result));
    }
  }

  Future<void> _togglePin(BuildContext context, WidgetRef ref, AppSettings s, bool enable,
      {bool forceChange = false}) async {
    final t = AppLocalizations.of(context);
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
        title: Text(forceChange ? t.changePin : t.definePin),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              autofocus: true,
              maxLength: 8,
              decoration: InputDecoration(labelText: t.pinHint),
            ),
            TextField(
              controller: confirmCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 8,
              decoration: InputDecoration(labelText: t.confirmPin),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.cancel)),
          FilledButton(
            onPressed: () {
              final a = ctrl.text.trim();
              final b = confirmCtrl.text.trim();
              if (a.length < 4) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(t.pinTooShort)));
                return;
              }
              if (a != b) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(t.pinMismatch)));
                return;
              }
              Navigator.pop(ctx, a);
            },
            child: Text(t.save),
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
    final t = AppLocalizations.of(context);
    if (!enable) {
      await ref.read(settingsProvider.notifier).update(s.copyWith(biometricEnabled: false));
      return;
    }
    final can = await ref.read(authServiceProvider).canCheckBiometrics();
    if (!can) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.noBiometricsConfigured)));
      }
      return;
    }
    await ref.read(settingsProvider.notifier).update(s.copyWith(biometricEnabled: true));
  }
}
