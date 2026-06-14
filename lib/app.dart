import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/format.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/lock/lock_gate.dart';
import 'presentation/theme/app_theme.dart';

class AnotaiApp extends ConsumerWidget {
  const AnotaiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    // Mantém datas/números no formato do idioma escolhido.
    Fmt.setFromLanguage(settings.locale);

    return MaterialApp(
      title: 'AnotAí',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.materialThemeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
      // Idioma escolhido nas configurações (pt padrão).
      locale: Locale(settings.locale),
      home: const LockGate(),
    );
  }
}
