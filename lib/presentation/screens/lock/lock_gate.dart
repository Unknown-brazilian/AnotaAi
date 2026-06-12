import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../providers/providers.dart';
import '../home/home_shell.dart';
import '../onboarding/onboarding_screen.dart';
import '../splash/animated_splash.dart';

enum _Phase { splash, onboarding, locked, unlocked }

/// Orquestra a sequência de abertura: splash animada → (cadastro inicial, só na
/// primeira vez) → bloqueio (se ligado) → home.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key});

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> {
  _Phase _phase = _Phase.splash;

  void _onSplashDone() {
    final s = ref.read(settingsProvider);
    setState(() {
      // Primeira abertura → cadastro inicial. Depois, bloqueio (se ligado).
      if (!s.onboarded) {
        _phase = _Phase.onboarding;
      } else {
        _phase = (s.pinEnabled || s.biometricEnabled) ? _Phase.locked : _Phase.unlocked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _Phase.splash => AnimatedSplash(onDone: _onSplashDone),
      _Phase.onboarding =>
        OnboardingScreen(onDone: () => setState(() => _phase = _Phase.unlocked)),
      _Phase.locked =>
        LockScreen(onUnlocked: () => setState(() => _phase = _Phase.unlocked)),
      _Phase.unlocked => const HomeShell(),
    };
  }
}

/// Tela de bloqueio: biometria e/ou PIN.
class LockScreen extends ConsumerStatefulWidget {
  final VoidCallback onUnlocked;
  const LockScreen({super.key, required this.onUnlocked});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pinCtrl = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    if (s.biometricEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
    }
  }

  Future<void> _tryBiometric() async {
    final ok = await ref.read(authServiceProvider).authenticate();
    if (ok && mounted) widget.onUnlocked();
  }

  Future<void> _tryPin() async {
    final ok = await ref
        .read(settingsServiceProvider)
        .verifyPin(_pinCtrl.text.trim());
    if (ok) {
      widget.onUnlocked();
    } else {
      setState(() => _error = 'PIN incorreto');
    }
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    return Scaffold(
      backgroundColor: Brand.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Brand.logoTwoTone, height: 64),
              const SizedBox(height: 12),
              const Icon(Icons.lock_outline, color: Brand.orange, size: 40),
              const SizedBox(height: 8),
              const Text('App bloqueado',
                  style: TextStyle(color: Brand.white, fontSize: 18)),
              const SizedBox(height: 28),
              if (s.biometricEnabled)
                OutlinedButton.icon(
                  onPressed: _tryBiometric,
                  icon: const Icon(Icons.fingerprint, color: Brand.orange),
                  label: const Text('Usar biometria',
                      style: TextStyle(color: Brand.white)),
                ),
              if (s.pinEnabled) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    autofocus: !s.biometricEnabled,
                    style: const TextStyle(color: Brand.white, fontSize: 22, letterSpacing: 8),
                    decoration: InputDecoration(
                      hintText: 'PIN',
                      errorText: _error,
                    ),
                    onSubmitted: (_) => _tryPin(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(onPressed: _tryPin, child: const Text('Entrar')),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
