import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../providers/providers.dart';

/// Cadastro inicial (local), exibido UMA vez após a splash:
/// nome do trabalhador + segurança opcional (biometria/PIN).
///
/// Depois de concluído, o nome fica persistente e só pode ser alterado no
/// painel do usuário (Perfil).
class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _canBiometric = false;
  bool _biometricEnabled = false;
  String? _pin; // definido via diálogo
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Pré-preenche se já houver nome salvo (ex.: reonboarding).
    _nameCtrl.text = ref.read(settingsProvider).defaultWorkerName;
    ref.read(authServiceProvider).canCheckBiometrics().then((v) {
      if (mounted) setState(() => _canBiometric = v);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _setupPin() async {
    final ctrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Definir PIN'),
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
    if (pin != null) setState(() => _pin = pin);
  }

  Future<void> _finish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(settingsProvider.notifier);
    final service = ref.read(settingsServiceProvider);

    if (_pin != null) {
      await service.setPin(_pin!);
    }

    await notifier.update(ref.read(settingsProvider).copyWith(
          defaultWorkerName: _nameCtrl.text.trim(),
          pinEnabled: _pin != null,
          biometricEnabled: _biometricEnabled,
          onboarded: true,
        ));

    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Brand.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(28),
            children: [
              const SizedBox(height: 12),
              Image.asset(Brand.logoTwoTone, height: 56),
              const SizedBox(height: 28),
              const Text(
                'Bem-vindo!',
                style: TextStyle(color: Brand.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Vamos configurar o app em 10 segundos. Esses dados ficam só no seu aparelho.',
                style: TextStyle(color: Brand.white.withValues(alpha: 0.7), fontSize: 15),
              ),
              const SizedBox(height: 32),

              // Nome
              Text('Como você se chama?',
                  style: TextStyle(
                      color: Brand.white, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: Brand.white),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Seu nome',
                  prefixIcon: Icon(Icons.person, color: Brand.orange),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe seu nome para continuar' : null,
              ),
              const SizedBox(height: 28),

              // Segurança (opcional)
              Row(
                children: [
                  const Icon(Icons.lock_outline, color: Brand.orange, size: 20),
                  const SizedBox(width: 8),
                  Text('Proteger o app (opcional)',
                      style: TextStyle(
                          color: Brand.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'É um app financeiro — você pode bloquear a abertura com biometria e/ou PIN.',
                style: TextStyle(color: Brand.white.withValues(alpha: 0.6), fontSize: 13),
              ),
              const SizedBox(height: 10),

              if (_canBiometric)
                Card(
                  color: Brand.blackElevated,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.fingerprint, color: Brand.orange),
                    title: const Text('Biometria', style: TextStyle(color: Brand.white)),
                    subtitle: Text('Digital ou rosto do aparelho',
                        style: TextStyle(color: Brand.white.withValues(alpha: 0.6))),
                    value: _biometricEnabled,
                    onChanged: (v) => setState(() => _biometricEnabled = v),
                  ),
                ),
              Card(
                color: Brand.blackElevated,
                child: ListTile(
                  leading: const Icon(Icons.pin, color: Brand.orange),
                  title: Text(_pin == null ? 'Definir PIN' : 'PIN definido ✓',
                      style: const TextStyle(color: Brand.white)),
                  subtitle: Text(_pin == null ? 'Toque para criar um PIN' : 'Toque para alterar',
                      style: TextStyle(color: Brand.white.withValues(alpha: 0.6))),
                  trailing: const Icon(Icons.chevron_right, color: Brand.white),
                  onTap: _setupPin,
                ),
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _saving ? null : _finish,
                icon: _saving
                    ? const SizedBox(
                        width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: const Text('Começar a usar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
