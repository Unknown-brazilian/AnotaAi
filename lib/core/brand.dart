import 'package:flutter/material.dart';

/// Identidade visual da marca AnotAí — laranja sobre preto.
class Brand {
  Brand._();

  /// Laranja da marca (mesmo tom do Bitcoin).
  static const Color orange = Color(0xFFF7931A);
  static const Color orangeDark = Color(0xFFD97D08);

  /// Preto base usado no fundo escuro e na splash.
  static const Color black = Color(0xFF0D0D0D);
  static const Color blackElevated = Color(0xFF1A1A1A);

  /// Branco do texto.
  static const Color white = Color(0xFFF4F4F5);

  static const Color paid = Color(0xFF2E9E5B); // verde — pago
  static const Color pending = Color(0xFFE0A800); // âmbar — pendente

  // Caminhos de assets de marca.
  static const String logoTwoTone = 'assets/brand/logo_anotai_twotone.png';
  static const String iconForeground = 'assets/icon/icon_foreground.png';
}

/// Constantes do app que não são texto traduzível.
class AppConfig {
  AppConfig._();

  /// Versão exibida do app (fonte única — manter em sincronia com pubspec.yaml).
  static const String appVersion = '1.1.0';

  /// Endereço Lightning para doações (Bitcoin). Mantido Bitcoin-only.
  static const String lightningAddress = 'opt_out@walletofsatoshi.com';

  /// Link de referral da Binance (já embutido conforme o prompt).
  static const String binanceReferralUrl =
      'https://account.binance.com/register?ref=LNBOT&?registerChannel=user_center';

  /// Percentual padrão de poupança em Bitcoin (20%).
  static const double defaultBitcoinSavingsPct = 0.20;

  /// Base da API pública da Binance (market data, sem chave).
  static const String binanceApiBase = 'https://api.binance.com';
}
