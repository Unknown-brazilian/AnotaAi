/// Enumerações centrais do domínio.
///
/// IMPORTANTE: a ordem dos valores é persistida pelo drift como índice inteiro
/// (`intEnum`). Nunca reordene nem remova valores existentes — apenas adicione
/// novos ao final, senão os registros antigos serão lidos com o enum errado.
library;

/// Forma de pagamento de uma diária.
enum PaymentMode {
  diaria,
  hora,
}

/// Moeda do registro. EUR é o padrão (público na zona do euro); GBP para quem
/// trabalha no Reino Unido.
enum Currency {
  eur,
  gbp;

  String get code => switch (this) {
        Currency.eur => 'EUR',
        Currency.gbp => 'GBP',
      };

  String get symbol => switch (this) {
        Currency.eur => '€',
        Currency.gbp => '£',
      };

  /// Par usado na Binance para cotar Bitcoin nesta moeda (ex.: BTCEUR).
  String get btcPair => 'BTC$code';

  static Currency fromCode(String code) =>
      Currency.values.firstWhere((c) => c.code == code.toUpperCase(),
          orElse: () => Currency.eur);
}

/// Modo de tema persistido (mapeia para [ThemeMode] na camada de UI).
enum AppThemeMode {
  system,
  light,
  dark,
}
