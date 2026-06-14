import 'package:flutter/widgets.dart';

import '../domain/period.dart';

/// Localização do app (pt-BR principal, + Inglês e Espanhol).
///
/// Uso: `final t = AppLocalizations.of(context);` e então `t.navHome`.
/// O idioma vem de `MaterialApp.locale` (definido pela configuração do usuário).
/// Para adicionar uma string, crie um getter usando `_t(pt, en, es)`.
class AppLocalizations {
  final String code; // 'pt' | 'en' | 'es'
  const AppLocalizations(this.code);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      const AppLocalizations('pt');

  static const LocalizationsDelegate<AppLocalizations> delegate = _Delegate();

  static const supportedCodes = ['pt', 'en', 'es'];

  String _t(String pt, String en, String es) => switch (code) {
        'en' => en,
        'es' => es,
        _ => pt,
      };

  // ---- Idiomas (nomes nativos) ----
  String get languageName => _t('Português', 'English', 'Español');
  static String nameOf(String code) => switch (code) {
        'en' => 'English',
        'es' => 'Español',
        _ => 'Português (Brasil)',
      };

  // ---- Comuns ----
  String get appTagline => _t('Controle de diárias', 'Daily-pay tracker', 'Control de jornales');
  String get save => _t('Salvar', 'Save', 'Guardar');
  String get cancel => _t('Cancelar', 'Cancel', 'Cancelar');
  String get delete => _t('Excluir', 'Delete', 'Eliminar');
  String get edit => _t('Editar', 'Edit', 'Editar');
  String get remove => _t('Remover', 'Remove', 'Quitar');
  String get change => _t('Alterar', 'Change', 'Cambiar');
  String get close => _t('Fechar', 'Close', 'Cerrar');
  String error(Object e) => _t('Erro: $e', 'Error: $e', 'Error: $e');
  String get start => _t('Entrar', 'Enter', 'Entrar');
  String get define => _t('Definir', 'Set', 'Definir');
  String get notSet => _t('Não definido', 'Not set', 'No definido');
  String get noName => _t('Sem nome', 'No name', 'Sin nombre');
  String get optional => _t('opcional', 'optional', 'opcional');

  // ---- Navegação ----
  String get navHome => _t('Início', 'Home', 'Inicio');
  String get navReport => _t('Extrato', 'Report', 'Extracto');
  String get navWhoOwes => _t('Quem deve', 'Who owes', 'Quién debe');
  String get navCalendar => _t('Calendário', 'Calendar', 'Calendario');
  String get navBitcoin => _t('Bitcoin', 'Bitcoin', 'Bitcoin');

  // ---- Diária / valores ----
  String get newEntry => _t('Nova diária', 'New entry', 'Nuevo jornal');
  String get entry => _t('Diária', 'Entry', 'Jornal');
  String get entries => _t('Diárias', 'Entries', 'Jornales');
  String get paid => _t('Pago', 'Paid', 'Pagado');
  String get pending => _t('Pendente', 'Pending', 'Pendiente');
  String get toReceive => _t('A receber', 'To receive', 'Por cobrar');
  String get received => _t('Já recebido', 'Received', 'Cobrado');
  String get totalValue => _t('Valor total', 'Total value', 'Valor total');
  String get value => _t('Valor', 'Value', 'Valor');
  String get markPaid => _t('Marcar como pago', 'Mark as paid', 'Marcar como pagado');
  String get markPending => _t('Marcar como pendente', 'Mark as pending', 'Marcar como pendiente');
  String get markPaidShort => _t('Marcar pago', 'Mark paid', 'Marcar pagado');
  String get showInBrl => _t('Ver em Real (R\$)', 'Show in Real (R\$)', 'Ver en Real (R\$)');
  String get brlUnavailable => _t(
      'Câmbio do Real indisponível agora (sem internet).',
      'Real exchange rate unavailable now (offline).',
      'Tipo de cambio del Real no disponible ahora (sin internet).');
  String daysCount(int n) => _t('$n diária(s)', '$n entry(ies)', '$n jornal(es)');
  String dayCount(int n) => _t('$n dia(s)', '$n day(s)', '$n día(s)');
  String inCurrency(String code) => _t('Em $code', 'In $code', 'En $code');
  String get employerCompany => _t('Patrão / empresa', 'Employer / company', 'Patrón / empresa');
  String get workedDays => _t('Dias trabalhados', 'Days worked', 'Días trabajados');
  String get totalHours => _t('Total de horas', 'Total hours', 'Total de horas');
  String get hoursWorked => _t('Horas trabalhadas', 'Hours worked', 'Horas trabajadas');

  // ---- Home ----
  String get monthSummary => _t('Resumo do mês', 'This month', 'Resumen del mes');
  String get noEntriesMonth => _t(
      'Nenhuma diária neste mês ainda.\nToque em "Nova diária" para começar.',
      'No entries this month yet.\nTap "New entry" to start.',
      'Aún no hay jornales este mes.\nToca "Nuevo jornal" para empezar.');
  String get recentEntries => _t('Diárias recentes', 'Recent entries', 'Jornales recientes');

  // ---- Onboarding ----
  String get welcome => _t('Bem-vindo!', 'Welcome!', '¡Bienvenido!');
  String get onboardingIntro => _t(
      'Vamos configurar o app em 10 segundos. Esses dados ficam só no seu aparelho.',
      "Let's set up the app in 10 seconds. This data stays only on your device.",
      'Configuremos la app en 10 segundos. Estos datos quedan solo en tu dispositivo.');
  String get whatsYourName => _t('Como você se chama?', "What's your name?", '¿Cómo te llamas?');
  String get yourName => _t('Seu nome', 'Your name', 'Tu nombre');
  String get nameRequired => _t(
      'Informe seu nome para continuar', 'Enter your name to continue', 'Ingresa tu nombre para continuar');
  String get protectApp => _t('Proteger o app (opcional)', 'Protect the app (optional)', 'Proteger la app (opcional)');
  String get protectAppHint => _t(
      'É um app financeiro — você pode bloquear a abertura com biometria e/ou PIN.',
      "It's a financial app — you can lock it with biometrics and/or a PIN.",
      'Es una app financiera — puedes bloquearla con biometría y/o PIN.');
  String get startUsing => _t('Começar a usar', 'Start using', 'Empezar a usar');

  // ---- Segurança / lock ----
  String get biometrics => _t('Biometria', 'Biometrics', 'Biometría');
  String get biometricsSub => _t(
      'Digital ou rosto do aparelho', "Device fingerprint or face", 'Huella o rostro del dispositivo');
  String get useBiometrics => _t('Usar biometria', 'Use biometrics', 'Usar biometría');
  String get definePin => _t('Definir PIN', 'Set PIN', 'Definir PIN');
  String get changePin => _t('Alterar PIN', 'Change PIN', 'Cambiar PIN');
  String get pinDefined => _t('PIN definido ✓', 'PIN set ✓', 'PIN definido ✓');
  String get tapToCreatePin => _t('Toque para criar um PIN', 'Tap to create a PIN', 'Toca para crear un PIN');
  String get tapToChange => _t('Toque para alterar', 'Tap to change', 'Toca para cambiar');
  String get pinHint => _t('PIN (mín. 4 dígitos)', 'PIN (min. 4 digits)', 'PIN (mín. 4 dígitos)');
  String get confirmPin => _t('Confirme o PIN', 'Confirm PIN', 'Confirma el PIN');
  String get pinTooShort => _t(
      'O PIN precisa ter ao menos 4 dígitos.', 'PIN must be at least 4 digits.', 'El PIN debe tener al menos 4 dígitos.');
  String get pinMismatch => _t('Os PINs não conferem.', "PINs don't match.", 'Los PIN no coinciden.');
  String get pinWrong => _t('PIN incorreto', 'Wrong PIN', 'PIN incorrecto');
  String get appLocked => _t('App bloqueado', 'App locked', 'App bloqueada');
  String get unlockReason => _t('Desbloqueie o AnotAí', 'Unlock AnotAí', 'Desbloquea AnotAí');
  String get noBiometricsConfigured => _t(
      'Este aparelho não tem biometria configurada.',
      'This device has no biometrics set up.',
      'Este dispositivo no tiene biometría configurada.');

  // ---- Perfil ----
  String get profile => _t('Perfil do usuário', 'User profile', 'Perfil del usuario');
  String get identity => _t('Identidade', 'Identity', 'Identidad');
  String get security => _t('Segurança', 'Security', 'Seguridad');
  String get name => _t('Nome', 'Name', 'Nombre');
  String get pinLock => _t('Bloqueio por PIN', 'PIN lock', 'Bloqueo por PIN');
  String get biometricLock => _t('Bloqueio por biometria', 'Biometric lock', 'Bloqueo por biometría');
  String get enabled => _t('Ativado', 'Enabled', 'Activado');
  String get disabled => _t('Desativado', 'Disabled', 'Desactivado');

  // ---- Configurações ----
  String get settings => _t('Configurações', 'Settings', 'Configuración');
  String get account => _t('Conta', 'Account', 'Cuenta');
  String get profileNameSecurity => _t(
      'Nome e segurança (PIN/biometria)', 'Name and security (PIN/biometrics)', 'Nombre y seguridad (PIN/biometría)');
  String get appearance => _t('Aparência', 'Appearance', 'Apariencia');
  String get theme => _t('Tema', 'Theme', 'Tema');
  String get themeSystem => _t('Seguir o sistema', 'Follow system', 'Seguir el sistema');
  String get themeLight => _t('Claro', 'Light', 'Claro');
  String get themeDark => _t('Escuro', 'Dark', 'Oscuro');
  String get system => _t('Sistema', 'System', 'Sistema');
  String get values => _t('Valores', 'Amounts', 'Valores');
  String get defaultCurrency => _t('Moeda padrão', 'Default currency', 'Moneda predeterminada');
  String get showBrlTitle => _t('Mostrar valores em Real (BRL)', 'Show amounts in Real (BRL)', 'Mostrar valores en Real (BRL)');
  String get showBrlSub => _t(
      'Exibe a conversão ao lado de euro/libra', 'Shows conversion next to euro/pound', 'Muestra la conversión junto a euro/libra');
  String get language => _t('Idioma', 'Language', 'Idioma');
  String get bitcoinSavingsPct => _t(
      'Percentual de poupança em Bitcoin', 'Bitcoin savings percentage', 'Porcentaje de ahorro en Bitcoin');
  String pctOfEarnings(int p) => _t('$p% dos ganhos', '$p% of earnings', '$p% de las ganancias');
  String get reminders => _t('Lembretes', 'Reminders', 'Recordatorios');
  String get dailyReminder => _t('Lembrete diário', 'Daily reminder', 'Recordatorio diario');
  String dailyAt(String hm) => _t('Todo dia às $hm', 'Every day at $hm', 'Todos los días a las $hm');
  String get off => _t('Desligado', 'Off', 'Apagado');
  String get reminderTime => _t('Horário do lembrete', 'Reminder time', 'Hora del recordatorio');
  String get notifPermissionDenied => _t(
      'Permissão de notificações negada.', 'Notification permission denied.', 'Permiso de notificaciones denegado.');
  String get backupRestore => _t('Backup e restauração', 'Backup and restore', 'Copia y restauración');
  String get doBackup => _t('Fazer backup', 'Back up', 'Hacer copia');
  String get doBackupSub => _t(
      'Salva banco + fotos em um arquivo ZIP', 'Saves database + photos to a ZIP file', 'Guarda base + fotos en un ZIP');
  String get restoreBackup => _t('Restaurar backup', 'Restore backup', 'Restaurar copia');
  String get restoreBackupSub => _t(
      'Importa um arquivo ZIP do AnotAí', 'Imports an AnotAí ZIP file', 'Importa un archivo ZIP de AnotAí');
  String get restoreConfirm => _t(
      'Isto substitui TODOS os dados atuais pelos do arquivo. O app será fechado ao final — reabra para concluir. Continuar?',
      'This replaces ALL current data with the file\'s. The app will close at the end — reopen to finish. Continue?',
      'Esto reemplaza TODOS los datos actuales por los del archivo. La app se cerrará al final — reábrela para terminar. ¿Continuar?');
  String get restoreDone => _t('Backup restaurado', 'Backup restored', 'Copia restaurada');
  String get restoreReopen => _t(
      'Reabra o AnotAí para ver seus dados restaurados.',
      'Reopen AnotAí to see your restored data.',
      'Reabre AnotAí para ver tus datos restaurados.');
  String get closeApp => _t('Fechar app', 'Close app', 'Cerrar app');
  String backupFail(Object e) => _t('Falha no backup: $e', 'Backup failed: $e', 'Error en la copia: $e');
  String restoreFail(Object e) => _t('Falha ao restaurar: $e', 'Restore failed: $e', 'Error al restaurar: $e');
  String get about => _t('Sobre', 'About', 'Acerca de');
  String get startSavingBitcoin => _t('Comece a poupar em Bitcoin', 'Start saving in Bitcoin', 'Empieza a ahorrar en Bitcoin');
  String get openBinanceSignup => _t('Abrir cadastro na Binance', 'Open Binance sign-up', 'Abrir registro en Binance');

  // ---- Gerenciar empregadores ----
  String get manageEmployers => _t('Gerenciar empregadores', 'Manage employers', 'Gestionar patrones');
  String get manageEmployersSub => _t(
      'Renomear ou mesclar nomes de patrões',
      'Rename or merge employer names',
      'Renombrar o combinar nombres de patrones');
  String get employersEmpty => _t(
      'Registre diárias para ver e organizar os patrões aqui.',
      'Add entries to see and organize employers here.',
      'Registra jornales para ver y organizar los patrones aquí.');
  String renameEmployerTitle(String name) =>
      _t('Renomear "$name"', 'Rename "$name"', 'Renombrar "$name"');
  String get rename => _t('Renomear', 'Rename', 'Renombrar');
  String get merge => _t('Mesclar', 'Merge', 'Combinar');
  String get newEmployerName => _t('Novo nome', 'New name', 'Nuevo nombre');
  String get nameEmptyError => _t('Informe um nome.', 'Enter a name.', 'Ingresa un nombre.');
  String employerRenamed(int n) => _t(
      '$n diária(s) atualizada(s)', '$n entry(ies) updated', '$n jornal(es) actualizado(s)');
  String get selectToMerge => _t(
      'Selecione 2 ou mais para mesclar', 'Select 2 or more to merge', 'Selecciona 2 o más para combinar');
  String get mergeInto => _t('Mesclar em…', 'Merge into…', 'Combinar en…');
  String mergeIntoTitle(int n) => _t(
      'Mesclar $n nomes em um só', 'Merge $n names into one', 'Combinar $n nombres en uno');
  String get mergeIntoHint => _t(
      'Escolha o nome final (ou digite um novo):',
      'Choose the final name (or type a new one):',
      'Elige el nombre final (o escribe uno nuevo):');
  String get assignName => _t('Atribuir nome', 'Assign name', 'Asignar nombre');

  // ---- Sobre o app ----
  String get aboutApp => _t('Sobre o app', 'About the app', 'Acerca de la app');
  String get madeBy => _t('Feito por unknown_BTC_usr e Claude',
      'Made by unknown_BTC_usr and Claude', 'Hecho por unknown_BTC_usr y Claude');
  String versionLabel(String v) => _t('Versão $v', 'Version $v', 'Versión $v');
  String get supportProject => _t('Apoie o projeto', 'Support the project', 'Apoya el proyecto');
  String get supportProjectSub => _t(
      'Doação em Bitcoin pela rede Lightning',
      'Bitcoin donation over the Lightning network',
      'Donación en Bitcoin por la red Lightning');
  String get donateLightning => _t(
      'Doar com Bitcoin (Lightning)', 'Donate with Bitcoin (Lightning)', 'Donar con Bitcoin (Lightning)');
  String get copy => _t('Copiar', 'Copy', 'Copiar');
  String get addressCopied => _t('Endereço copiado', 'Address copied', 'Dirección copiada');
  String get addressCopiedPaste => _t(
      'Endereço copiado — cole na sua carteira',
      'Address copied — paste it into your wallet',
      'Dirección copiada — pégala en tu billetera');

  // ---- Formulário de diária ----
  String get editEntry => _t('Editar diária', 'Edit entry', 'Editar jornal');
  String get workDate => _t('Data do trabalho', 'Work date', 'Fecha del trabajo');
  String get employer => _t('Nome do patrão / empresa', 'Employer / company', 'Patrón / empresa');
  String get place => _t('Lugar / obra', 'Place / site', 'Lugar / obra');
  String get serviceType => _t('Tipo de serviço', 'Service type', 'Tipo de servicio');
  String get paymentMode => _t('Forma de pagamento', 'Payment mode', 'Forma de pago');
  String get byDay => _t('Por diária', 'Per day', 'Por jornal');
  String get byHour => _t('Por hora', 'Per hour', 'Por hora');
  String get dailyRate => _t('Valor da diária', 'Daily rate', 'Valor del jornal');
  String get hourlyRate => _t('Valor por hora', 'Hourly rate', 'Valor por hora');
  String get invalidValue => _t('Informe um valor válido', 'Enter a valid amount', 'Ingresa un valor válido');
  String get clockIn => _t('Entrada', 'Clock in', 'Entrada');
  String get clockOut => _t('Saída', 'Clock out', 'Salida');
  String get iReceivedThis => _t('Já recebi este valor', 'I received this amount', 'Ya cobré este valor');
  String get amountReceivedFull => _t(
      'Valor recebido (deixe vazio = valor cheio)',
      'Amount received (leave empty = full)',
      'Valor cobrado (vacío = total)');
  String get siteLocation => _t('Localização da obra', 'Site location', 'Ubicación de la obra');
  String get useMyLocation => _t('Usar minha localização atual', 'Use my current location', 'Usar mi ubicación actual');
  String get updateLocation => _t('Atualizar localização', 'Update location', 'Actualizar ubicación');
  String get photosReceipts => _t('Fotos / comprovantes', 'Photos / receipts', 'Fotos / comprobantes');
  String get camera => _t('Câmera', 'Camera', 'Cámara');
  String get gallery => _t('Galeria', 'Gallery', 'Galería');
  String get notes => _t('Observações', 'Notes', 'Notas');
  String get saveEntry => _t('Salvar diária', 'Save entry', 'Guardar jornal');
  String get futureDateBlocked => _t(
      'Não é possível registrar diária em data futura.',
      "Can't record an entry on a future date.",
      'No se puede registrar un jornal en fecha futura.');
  String get photoFail => _t('Não foi possível anexar a foto.', "Couldn't attach the photo.", 'No se pudo adjuntar la foto.');
  String get locationFail => _t(
      'Não foi possível obter a localização.', "Couldn't get the location.", 'No se pudo obtener la ubicación.');

  // ---- Detalhe ----
  String get worker => _t('Trabalhador', 'Worker', 'Trabajador');
  String get form => _t('Forma', 'Mode', 'Forma');
  String get schedule => _t('Horário', 'Schedule', 'Horario');
  String get location => _t('Localização', 'Location', 'Ubicación');
  String get openInMaps => _t('Abrir no Maps', 'Open in Maps', 'Abrir en Maps');
  String get share => _t('Compartilhar', 'Share', 'Compartir');
  String get deleteEntryQ => _t('Excluir diária?', 'Delete entry?', '¿Eliminar jornal?');
  String get cannotUndo => _t('Esta ação não pode ser desfeita.', "This can't be undone.", 'Esta acción no se puede deshacer.');
  String get entryNotFound => _t('Diária não encontrada.', 'Entry not found.', 'Jornal no encontrado.');
  String locationShare(String place, String url) => _t(
      'Local de $place:\n$url', 'Location of $place:\n$url', 'Ubicación de $place:\n$url');
  String get theSite => _t('a obra', 'the site', 'la obra');
  String get locationLabel => _t('Localização da obra', 'Site location', 'Ubicación de la obra');

  // ---- Extrato ----
  String get pWeek => _t('Semana', 'Week', 'Semana');
  String get pMonth => _t('Mês', 'Month', 'Mes');
  String get pQuarter => _t('Trimestre', 'Quarter', 'Trimestre');
  String get pSemester => _t('Semestre', 'Half-year', 'Semestre');
  String get pYear => _t('Ano', 'Year', 'Año');
  String get export => _t('Exportar', 'Export', 'Exportar');
  String get profileShort => _t('Perfil', 'Profile', 'Perfil');
  String get restore => _t('Restaurar', 'Restore', 'Restaurar');
  String get backupShareText => _t('Backup do AnotAí', 'AnotAí backup', 'Copia de AnotAí');
  String get statementTitle => _t('Extrato de diárias', 'Work statement', 'Extracto de jornales');
  String employerStatementTitle(String name) =>
      _t('Extrato — $name', 'Statement — $name', 'Extracto — $name');
  String employerLabel(String name) =>
      _t('Patrão: $name', 'Employer: $name', 'Patrón: $name');
  String periodLabelFull(PeriodType type, String range) => '${periodName(type)} · $range';

  /// Nome localizado do tipo de período (para os chips).
  String periodName(PeriodType type) => switch (type) {
        PeriodType.week => pWeek,
        PeriodType.month => pMonth,
        PeriodType.quarter => pQuarter,
        PeriodType.semester => pSemester,
        PeriodType.year => pYear,
      };
  String get noEntriesPeriod => _t('Nenhuma diária neste período.', 'No entries in this period.', 'No hay jornales en este período.');
  String get multiCurrencyNote => _t(
      'Há registros em moedas diferentes — os totais aparecem separados.',
      'There are records in different currencies — totals are shown separately.',
      'Hay registros en monedas diferentes — los totales aparecen separados.');
  String selectedCount(int n) => _t('$n selecionada(s)', '$n selected', '$n seleccionado(s)');

  // ---- Quem me deve ----
  String get whoOwesMe => _t('Quem me deve', 'Who owes me', 'Quién me debe');
  String get withOpenBalance => _t('Com saldo em aberto', 'With open balance', 'Con saldo pendiente');
  String get allSettled => _t('Tudo quitado', 'All settled', 'Todo saldado');
  String openCount(int n) => _t('$n em aberto', '$n open', '$n pendiente(s)');
  String worked(String v) => _t('Trabalhado $v', 'Worked $v', 'Trabajado $v');
  String receivedAmount(String v) => _t('Recebido $v', 'Received $v', 'Cobrado $v');
  String get statementToCharge => _t('Extrato p/ cobrar', 'Statement to charge', 'Extracto para cobrar');
  String get whoOwesEmpty => _t(
      'Cadastre diárias para ver quanto cada patrão te deve.',
      'Add entries to see how much each employer owes you.',
      'Registra jornales para ver cuánto te debe cada patrón.');
  String get noEmployer => _t('Sem nome', 'No name', 'Sin nombre');

  // ---- Calendário ----
  String get calendar => _t('Calendário', 'Calendar', 'Calendario');
  String get fmtMonth => _t('Mês', 'Month', 'Mes');
  String get fmtTwoWeeks => _t('2 semanas', '2 weeks', '2 semanas');
  String get fmtWeek => _t('Semana', 'Week', 'Semana');
  String get tapADay => _t('Toque em um dia para ver as diárias.', 'Tap a day to see entries.', 'Toca un día para ver los jornales.');
  String get noEntriesDay => _t('Nenhuma diária neste dia.', 'No entries this day.', 'No hay jornales este día.');

  // ---- Bitcoin ----
  String bitcoinQuestion(int p) => _t(
      'E se você tivesse poupado $p% dos seus ganhos em Bitcoin?',
      'What if you had saved $p% of your earnings in Bitcoin?',
      '¿Y si hubieras ahorrado $p% de tus ganancias en Bitcoin?');
  String get btcCalcFail => _t('Não foi possível calcular agora', "Couldn't calculate right now", 'No se pudo calcular ahora');
  String get btcDisclaimer => _t(
      'Comparação ilustrativa baseada em dados passados. Não é recomendação de investimento.',
      'Illustrative comparison based on past data. Not investment advice.',
      'Comparación ilustrativa basada en datos pasados. No es recomendación de inversión.');
  String get btcIncomplete => _t(
      'Resultado parcial: faltam cotações de alguns dias (sem internet).',
      'Partial result: some daily prices are missing (offline).',
      'Resultado parcial: faltan cotizaciones de algunos días (sin internet).');
  String get btcNoEntries => _t('Sem diárias no período para simular.', 'No entries in the period to simulate.', 'Sin jornales en el período para simular.');
  String get youWouldHaveSaved => _t('Você teria poupado', 'You would have saved', 'Habrías ahorrado');
  String get valueTodayBtc => _t('Valor hoje em Bitcoin', 'Value today in Bitcoin', 'Valor hoy en Bitcoin');
  String btcAccumulated(String v) => _t('Bitcoin acumulado: $v', 'Bitcoin accumulated: $v', 'Bitcoin acumulado: $v');
  String get appreciation => _t('Valorização', 'Appreciation', 'Valorización');
  String get depreciation => _t('Desvalorização', 'Depreciation', 'Desvalorización');
  String get savingsGoal => _t('Meta de poupança', 'Savings goal', 'Meta de ahorro');
  String get savingsGoalHint => _t(
      'Defina quanto quer guardar por período e acompanhe o avanço.',
      'Set how much to save per period and track your progress.',
      'Define cuánto ahorrar por período y sigue tu avance.');
  String goalLine(String amount, String period) => _t(
      'Meta: $amount por $period', 'Goal: $amount per $period', 'Meta: $amount por $period');
  String selectPeriodForGoal(String period) => _t(
      'Selecione o período "$period" acima para acompanhar a meta.',
      'Select the "$period" period above to track the goal.',
      'Selecciona el período "$period" arriba para seguir la meta.');
  String savedOf(String saved, String target) => _t(
      'Poupado: $saved de $target', 'Saved: $saved of $target', 'Ahorrado: $saved de $target');
  String btcEquivalent(String v) => _t(
      'Equivalente hoje em Bitcoin: $v', 'Equivalent today in Bitcoin: $v', 'Equivalente hoy en Bitcoin: $v');
  String get howMuchToSave => _t('Quanto guardar', 'How much to save', 'Cuánto ahorrar');
  String get currency => _t('Moeda', 'Currency', 'Moneda');

  // ---- Exportação ----
  String get exportTitle => _t('Exportar', 'Export', 'Exportar');
  String get pdfRecommended => _t(
      'PDF (recomendado para enviar ou guardar)',
      'PDF (recommended to send or keep)',
      'PDF (recomendado para enviar o guardar)');
  String get pdfGenerateShare => _t('Gerar PDF e compartilhar', 'Generate PDF and share', 'Generar PDF y compartir');
  String get pdfPreview => _t('Visualizar / imprimir PDF', 'Preview / print PDF', 'Ver / imprimir PDF');
  String get spreadsheet => _t('Planilha', 'Spreadsheet', 'Planilla');
  String get xlsGenerateShare => _t('Gerar planilha (XLS) e compartilhar', 'Generate spreadsheet (XLS) and share', 'Generar planilla (XLS) y compartir');
  String get generatingFile => _t('Gerando arquivo...', 'Generating file...', 'Generando archivo...');
  String exportFail(Object e) => _t('Falha ao exportar: $e', 'Export failed: $e', 'Error al exportar: $e');

  // ---- Splash ----
  String get tapToSkip => _t('Toque para pular', 'Tap to skip', 'Toca para saltar');

  // ---- Splash tips ----
  List<String> get splashTips => switch (code) {
        'en' => _tipsEn,
        'es' => _tipsEs,
        _ => _tipsPt,
      };
}

const _tipsPt = [
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

const _tipsEn = [
  'Log your day right after finishing work — it takes 10 seconds.',
  "Mark which days the boss already paid and instantly see what's still owed.",
  'Check the "Who owes me" screen to see how much each boss still owes you.',
  'Save the job-site location and send a Google Maps link to a workmate.',
  'Generate a PDF statement and share it on WhatsApp in one tap.',
  'See your earnings converted to reais, plus euro and pound.',
  'Attach a photo of the receipt as proof of what you received.',
  'Back up your data so you lose nothing if you change phones.',
  'See how much you would have saving 20% of your earnings in Bitcoin.',
  'Paid by the hour? The app computes the amount from clock-in and clock-out.',
];

const _tipsEs = [
  'Registra tu jornal apenas terminas el trabajo — toma 10 segundos.',
  'Marca qué días el patrón ya pagó y mira al instante lo que falta cobrar.',
  'Mira en "Quién me debe" cuánto te debe todavía cada patrón.',
  'Guarda la ubicación de la obra y envía el enlace de Google Maps a un colega.',
  'Genera un extracto en PDF y compártelo en WhatsApp con un toque.',
  'Mira tus ganancias convertidas a reales, además de euro y libra.',
  'Adjunta la foto del comprobante como prueba de lo que cobraste.',
  'Haz copia de tus datos para no perder nada si cambias de teléfono.',
  'Descubre cuánto tendrías ahorrando 20% de tus ganancias en Bitcoin.',
  '¿Trabajas por hora? La app calcula el valor con la entrada y la salida.',
];

class _Delegate extends LocalizationsDelegate<AppLocalizations> {
  const _Delegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale.languageCode);

  @override
  bool shouldReload(_Delegate old) => false;
}
