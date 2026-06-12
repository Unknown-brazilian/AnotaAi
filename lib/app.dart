import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/strings.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/lock/lock_gate.dart';
import 'presentation/theme/app_theme.dart';

class AnotaiApp extends ConsumerWidget {
  const AnotaiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: S.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.materialThemeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en'),
        Locale('es'),
      ],
      // pt-BR é o idioma principal; estrutura pronta para EN/ES.
      locale: const Locale('pt', 'BR'),
      home: const LockGate(),
    );
  }
}
