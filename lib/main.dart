import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/format.dart';
import 'domain/services/settings_service.dart';
import 'presentation/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Formatação de datas para todos os idiomas suportados.
  await initializeDateFormatting('pt_BR');
  await initializeDateFormatting('en_US');
  await initializeDateFormatting('es_ES');

  final prefs = await SharedPreferences.getInstance();
  // Aplica o idioma salvo ao formatador antes do primeiro frame.
  Fmt.setFromLanguage(SettingsService(prefs).load().locale);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AnotaiApp(),
    ),
  );
}
