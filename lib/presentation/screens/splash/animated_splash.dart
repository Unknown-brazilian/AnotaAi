import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/brand.dart';
import '../../../l10n/strings.dart';
import '../../providers/providers.dart';

/// Tela de abertura animada (fundo preto, animações laranja) com dica rotativa.
///
/// Dura ~5s, com transição suave; tocar na tela pula direto para a home — útil
/// para quem abre o app várias vezes ao dia.
class AnimatedSplash extends ConsumerStatefulWidget {
  final VoidCallback onDone;
  const AnimatedSplash({super.key, required this.onDone});

  @override
  ConsumerState<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends ConsumerState<AnimatedSplash>
    with TickerProviderStateMixin {
  late final AnimationController _logo;
  late final AnimationController _pulse;
  late final String _tip;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _tip = _pickTip();

    _logo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    // Onda/pulso laranja contínuo atrás do logo.
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // Duração total de ~5s (tempo de ler a dica com calma).
    Future.delayed(const Duration(milliseconds: 5000), _finish);
  }

  /// Sorteia uma dica diferente da exibida na abertura anterior.
  String _pickTip() {
    final prefs = ref.read(sharedPreferencesProvider);
    final last = prefs.getInt('lastTipIndex') ?? -1;
    final tips = S.splashTips;
    int idx;
    final rnd = Random();
    do {
      idx = rnd.nextInt(tips.length);
    } while (idx == last && tips.length > 1);
    prefs.setInt('lastTipIndex', idx);
    return tips[idx];
  }

  void _finish() {
    if (_done || !mounted) return;
    _done = true;
    widget.onDone();
  }

  @override
  void dispose() {
    _logo.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _logo, curve: Curves.easeOut);
    final scale = Tween(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _logo, curve: Curves.easeOutBack));

    return GestureDetector(
      onTap: _finish, // tocar para pular
      child: Scaffold(
        backgroundColor: Brand.black,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(flex: 3),
                  // Pulso laranja + logo.
                  SizedBox(
                    height: 200,
                    width: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, _) => CustomPaint(
                            size: const Size(260, 200),
                            painter: _PulsePainter(_pulse.value),
                          ),
                        ),
                        FadeTransition(
                          opacity: fade,
                          child: ScaleTransition(
                            scale: scale,
                            child: Image.asset(
                              Brand.logoTwoTone,
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Dica rotativa.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: FadeTransition(
                      opacity: fade,
                      child: Text(
                        _tip,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Brand.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  // Dica de "toque para pular".
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Text(
                      'Toque para pular',
                      style: TextStyle(
                        color: Brand.white.withValues(alpha: 0.45),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Desenha anéis laranja que expandem e somem — efeito de onda.
class _PulsePainter extends CustomPainter {
  final double t; // 0..1
  _PulsePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      final radius = 40 + phase * 90;
      final opacity = (1 - phase) * 0.5;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Brand.orange.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_PulsePainter old) => old.t != t;
}
