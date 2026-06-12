import 'package:intl/intl.dart';

import 'enums.dart';

/// Formatadores de moeda e data (pt-BR).
class Fmt {
  Fmt._();

  static final _date = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _dateShort = DateFormat('dd/MM', 'pt_BR');
  static final _weekday = DateFormat('EEEE, dd/MM', 'pt_BR');

  static String date(DateTime d) => _date.format(d);
  static String dateShort(DateTime d) => _dateShort.format(d);
  static String weekday(DateTime d) =>
      toBeginningOfSentenceCase(_weekday.format(d))!;

  /// Formata um valor com o símbolo da moeda (€/£), padrão pt-BR (1.234,56).
  static String money(double value, Currency currency) {
    final f = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '${currency.symbol} ',
      decimalDigits: 2,
    );
    return f.format(value);
  }

  /// Formata um valor em reais (R$).
  static String brl(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ', decimalDigits: 2)
        .format(value);
  }

  /// Formata uma quantidade de Bitcoin com até 8 casas (sem zeros à toa).
  static String btc(double value) {
    final f = NumberFormat('0.########', 'pt_BR');
    return '₿ ${f.format(value)}';
  }

  /// Percentual com sinal (ex.: +12,3%).
  static String signedPercent(double pct) {
    final f = NumberFormat('+0.0;-0.0', 'pt_BR');
    return '${f.format(pct)}%';
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
