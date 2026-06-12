/// Textos da interface, centralizados em pt-BR.
///
/// i18n: o app já roda com `flutter_localizations` + `intl` no locale pt-BR
/// (formatação de datas/números). Os textos da UI ficam aqui em um único lugar
/// para facilitar adicionar Inglês e Espanhol depois — basta criar um mapa por
/// idioma e selecionar pela configuração `locale`. Mantemos pt-BR ativo agora.
class S {
  S._();

  // Dicas rotativas da tela de abertura (sorteadas a cada abertura).
  static const List<String> splashTips = [
    'Registre sua diária assim que terminar o trabalho — leva 10 segundos.',
    'Marque quais dias o patrão já pagou e veja na hora o que ainda falta receber.',
    'Veja na tela "Quem me deve" quanto cada patrão ainda te deve.',
    'Salve a localização da obra e mande pro colega abrir direto no Google Maps.',
    'Gere um extrato em PDF e compartilhe no WhatsApp num toque.',
    'Veja seus ganhos convertidos em reais, além de euro e libra.',
    'Anexe a foto do comprovante pra ter prova do que recebeu.',
    'Faça backup dos seus dados pra não perder nada se trocar de celular.',
    'Descubra quanto você teria poupando 20% dos seus ganhos em Bitcoin.',
    'Trabalha por hora? O app calcula o valor a partir da entrada e saída.',
  ];

  static const appName = 'AnotAí';

  // Nav
  static const navHome = 'Início';
  static const navReport = 'Extrato';
  static const navWhoOwes = 'Quem me deve';
  static const navCalendar = 'Calendário';
  static const navBitcoin = 'Bitcoin';
  static const settings = 'Configurações';

  // Comuns
  static const newEntry = 'Nova diária';
  static const save = 'Salvar';
  static const cancel = 'Cancelar';
  static const delete = 'Excluir';
  static const edit = 'Editar';
  static const markPaid = 'Marcar como pago';
  static const markUnpaid = 'Marcar como pendente';
  static const paid = 'Pago';
  static const pending = 'Pendente';
  static const toReceive = 'A receber';
  static const received = 'Já recebido';
  static const showInBrl = 'Ver em Real (BRL)';
  static const exportPdf = 'Exportar PDF';
  static const exportXls = 'Exportar planilha';
  static const share = 'Compartilhar';

  // Bitcoin
  static const btcDisclaimer =
      'Comparação ilustrativa baseada em dados passados. Não é recomendação de investimento.';
  static const startSaving = 'Comece a poupar em Bitcoin';
}
