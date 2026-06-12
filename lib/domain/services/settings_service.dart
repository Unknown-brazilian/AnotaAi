import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/brand.dart';
import '../../core/enums.dart';

/// Snapshot imutável das configurações do app.
@immutable
class AppSettings {
  final Currency defaultCurrency;
  final String defaultWorkerName;
  final AppThemeMode themeMode;
  final String locale; // 'pt' (estrutura pronta para 'en'/'es')
  final double bitcoinSavingsPct; // 0.0–1.0
  final bool showBrl;
  final bool pinEnabled;
  final bool biometricEnabled;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  /// Verdadeiro depois que o usuário concluiu o cadastro inicial (nome +
  /// segurança). Enquanto falso, o app mostra a tela de onboarding após a splash.
  final bool onboarded;

  const AppSettings({
    this.defaultCurrency = Currency.eur,
    this.defaultWorkerName = '',
    this.themeMode = AppThemeMode.system,
    this.locale = 'pt',
    this.bitcoinSavingsPct = AppConfig.defaultBitcoinSavingsPct,
    this.showBrl = false,
    this.pinEnabled = false,
    this.biometricEnabled = false,
    this.reminderEnabled = false,
    this.reminderHour = 19,
    this.reminderMinute = 0,
    this.onboarded = false,
  });

  ThemeMode get materialThemeMode => switch (themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  AppSettings copyWith({
    Currency? defaultCurrency,
    String? defaultWorkerName,
    AppThemeMode? themeMode,
    String? locale,
    double? bitcoinSavingsPct,
    bool? showBrl,
    bool? pinEnabled,
    bool? biometricEnabled,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? onboarded,
  }) {
    return AppSettings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      defaultWorkerName: defaultWorkerName ?? this.defaultWorkerName,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      bitcoinSavingsPct: bitcoinSavingsPct ?? this.bitcoinSavingsPct,
      showBrl: showBrl ?? this.showBrl,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      onboarded: onboarded ?? this.onboarded,
    );
  }
}

/// Persiste configurações em [SharedPreferences]; o PIN fica em
/// [FlutterSecureStorage] (armazenamento criptografado).
class SettingsService {
  static const _kCurrency = 'defaultCurrency';
  static const _kWorker = 'defaultWorkerName';
  static const _kTheme = 'themeMode';
  static const _kLocale = 'locale';
  static const _kBtcPct = 'bitcoinSavingsPct';
  static const _kShowBrl = 'showBrl';
  static const _kPinEnabled = 'pinEnabled';
  static const _kBiometric = 'biometricEnabled';
  static const _kReminder = 'reminderEnabled';
  static const _kReminderH = 'reminderHour';
  static const _kReminderM = 'reminderMinute';
  static const _kOnboarded = 'onboarded';
  static const _kPin = 'anotai_pin';

  final SharedPreferences prefs;
  final FlutterSecureStorage secure;

  SettingsService(this.prefs, {FlutterSecureStorage? secure})
      : secure = secure ?? const FlutterSecureStorage();

  AppSettings load() {
    return AppSettings(
      defaultCurrency: Currency.values[prefs.getInt(_kCurrency) ?? 0],
      defaultWorkerName: prefs.getString(_kWorker) ?? '',
      themeMode: AppThemeMode.values[prefs.getInt(_kTheme) ?? 0],
      locale: prefs.getString(_kLocale) ?? 'pt',
      bitcoinSavingsPct:
          prefs.getDouble(_kBtcPct) ?? AppConfig.defaultBitcoinSavingsPct,
      showBrl: prefs.getBool(_kShowBrl) ?? false,
      pinEnabled: prefs.getBool(_kPinEnabled) ?? false,
      biometricEnabled: prefs.getBool(_kBiometric) ?? false,
      reminderEnabled: prefs.getBool(_kReminder) ?? false,
      reminderHour: prefs.getInt(_kReminderH) ?? 19,
      reminderMinute: prefs.getInt(_kReminderM) ?? 0,
      onboarded: prefs.getBool(_kOnboarded) ?? false,
    );
  }

  Future<void> save(AppSettings s) async {
    await prefs.setInt(_kCurrency, s.defaultCurrency.index);
    await prefs.setString(_kWorker, s.defaultWorkerName);
    await prefs.setInt(_kTheme, s.themeMode.index);
    await prefs.setString(_kLocale, s.locale);
    await prefs.setDouble(_kBtcPct, s.bitcoinSavingsPct);
    await prefs.setBool(_kShowBrl, s.showBrl);
    await prefs.setBool(_kPinEnabled, s.pinEnabled);
    await prefs.setBool(_kBiometric, s.biometricEnabled);
    await prefs.setBool(_kReminder, s.reminderEnabled);
    await prefs.setInt(_kReminderH, s.reminderHour);
    await prefs.setInt(_kReminderM, s.reminderMinute);
    await prefs.setBool(_kOnboarded, s.onboarded);
  }

  // ---- PIN (armazenamento seguro) ----

  Future<void> setPin(String pin) => secure.write(key: _kPin, value: pin);
  Future<String?> getPin() => secure.read(key: _kPin);
  Future<void> clearPin() => secure.delete(key: _kPin);
  Future<bool> verifyPin(String pin) async => (await getPin()) == pin;
}
