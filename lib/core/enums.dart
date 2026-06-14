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
/// trabalha no Reino Unido; USD para dólar.
///
/// IMPORTANTE: novos valores só podem ser ADICIONADOS ao final (o índice é
/// persistido pelo drift).
enum Currency {
  eur,
  gbp,
  usd;

  String get code => switch (this) {
        Currency.eur => 'EUR',
        Currency.gbp => 'GBP',
        Currency.usd => 'USD',
      };

  String get symbol => switch (this) {
        Currency.eur => '€',
        Currency.gbp => '£',
        Currency.usd => '\$',
      };

  /// Par usado na Binance para cotar Bitcoin nesta moeda.
  /// USD usa BTCUSDT (a Binance não tem BTCUSD).
  String get btcPair => switch (this) {
        Currency.usd => 'BTCUSDT',
        _ => 'BTC$code',
      };

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
