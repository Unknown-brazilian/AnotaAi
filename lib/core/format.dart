import 'package:intl/intl.dart';

import 'enums.dart';

/// Formatadores de moeda e data, sensíveis ao idioma.
///
/// [locale] é o locale do `intl` (ex.: 'pt_BR', 'en_US', 'es_ES') e é ajustado
/// pelo app conforme o idioma escolhido (ver [setFromLanguage]). Datas e números
/// passam a sair no formato do idioma selecionado.
class Fmt {
  Fmt._();

  static String locale = 'pt_BR';

  /// Converte o código de idioma do app ('pt'/'en'/'es') no locale do intl.
  static void setFromLanguage(String lang) {
    locale = switch (lang) {
      'en' => 'en_US',
      'es' => 'es_ES',
      _ => 'pt_BR',
    };
  }

  static String date(DateTime d) => DateFormat.yMd(locale).format(d);
  static String dateShort(DateTime d) => DateFormat('dd/MM', locale).format(d);
  static String weekday(DateTime d) =>
      toBeginningOfSentenceCase(DateFormat('EEEE, dd/MM', locale).format(d))!;

  /// Formata um valor com o símbolo da moeda (€/£/$), no formato do idioma.
  static String money(double value, Currency currency) {
    return NumberFormat.currency(
      locale: locale,
      symbol: '${currency.symbol} ',
      decimalDigits: 2,
    ).format(value);
  }

  /// Formata um valor em reais (R$).
  static String brl(double value) {
    return NumberFormat.currency(locale: locale, symbol: 'R\$ ', decimalDigits: 2)
        .format(value);
  }

  /// Formata uma quantidade de Bitcoin com até 8 casas (sem zeros à toa).
  /// Usa o sufixo "BTC" (em vez do símbolo ₿, que muitas fontes não têm).
  static String btc(double value) {
    return '${NumberFormat('0.########', locale).format(value)} BTC';
  }

  /// Percentual com sinal (ex.: +12,3%).
  static String signedPercent(double pct) {
    return '${NumberFormat('+0.0;-0.0', locale).format(pct)}%';
  }

  static String hours(double h) {
    final hh = h.floor();
    final mm = ((h - hh) * 60).round();
    return mm == 0 ? '${hh}h' : '${hh}h${mm.toString().padLeft(2, '0')}';
  }

  /// Converte minutos-do-dia (0–1439) em "HH:mm".
  static String minutesToHHmm(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}
