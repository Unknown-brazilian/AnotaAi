import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enums.dart';
import '../../data/database/database.dart';
import '../../domain/period.dart';
import '../../domain/services/attachment_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/backup_service.dart';
import '../../domain/services/binance_service.dart';
import '../../domain/services/bitcoin_compare_service.dart';
import '../../domain/services/fx_service.dart';
import '../../domain/services/location_service.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/pdf_export_service.dart';
import '../../domain/services/settings_service.dart';
import '../../domain/services/xls_export_service.dart';
import '../../domain/summary.dart';

// ---- Infra ----

/// Sobrescrito em main() após carregar o SharedPreferences.
final sharedPreferencesProvider = Provider<SharedPreferences>(
    (ref) => throw UnimplementedError('Defina em main()'));

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ---- Serviços ----

final settingsServiceProvider = Provider<SettingsService>(
    (ref) => SettingsService(ref.watch(sharedPreferencesProvider)));

final binanceServiceProvider = Provider<BinanceService>((ref) {
  final s = BinanceService(ref.watch(databaseProvider));
  ref.onDispose(s.dispose);
  return s;
});

final fxServiceProvider = Provider<FxService>((ref) {
  final s = FxService(ref.watch(binanceServiceProvider));
  ref.onDispose(s.dispose);
  return s;
});

final bitcoinCompareServiceProvider = Provider<BitcoinCompareService>(
    (ref) => BitcoinCompareService(ref.watch(binanceServiceProvider)));

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());
final attachmentServiceProvider = Provider<AttachmentService>((ref) => AttachmentService());
final pdfExportServiceProvider = Provider<PdfExportService>((ref) => PdfExportService());
final xlsExportServiceProvider = Provider<XlsExportService>((ref) => XlsExportService());
final backupServiceProvider = Provider<BackupService>((ref) => BackupService());

// ---- Configurações ----

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsService _service;
  SettingsNotifier(this._service) : super(_service.load());

  Future<void> update(AppSettings next) async {
    state = next;
    await _service.save(next);
  }

  SettingsService get service => _service;
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsServiceProvider));
});

// ---- Diárias ----

final allEntriesProvider = StreamProvider<List<WorkEntry>>(
    (ref) => ref.watch(databaseProvider).watchAllEntries());

/// Tipo de período selecionado no Extrato (mês por padrão).
final periodTypeProvider = StateProvider<PeriodType>((ref) => PeriodType.month);

/// Data âncora do período (hoje por padrão).
final periodAnchorProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// Intervalo derivado do tipo + âncora atuais.
final periodRangeProvider = Provider<DateRange>((ref) {
  final type = ref.watch(periodTypeProvider);
  final anchor = ref.watch(periodAnchorProvider);
  return PeriodCalculator.rangeFor(type, anchor);
});

/// Diárias do período selecionado.
final entriesInPeriodProvider = StreamProvider<List<WorkEntry>>((ref) {
  final range = ref.watch(periodRangeProvider);
  return ref.watch(databaseProvider).watchEntriesBetween(range.start, range.end);
});

/// Resumo agregado do período selecionado.
final periodSummaryProvider = Provider<WorkSummary>((ref) {
  final entries = ref.watch(entriesInPeriodProvider).value ?? const [];
  return WorkSummary.fromEntries(entries);
});

/// Resumo do mês corrente para a Home (independente do período do Extrato).
final currentMonthEntriesProvider = StreamProvider<List<WorkEntry>>((ref) {
  final range = PeriodCalculator.rangeFor(PeriodType.month, DateTime.now());
  return ref.watch(databaseProvider).watchEntriesBetween(range.start, range.end);
});

/// Saldos por patrão (tela "Quem me deve") a partir de todas as diárias.
final employerBalancesProvider = Provider<List<EmployerBalance>>((ref) {
  final entries = ref.watch(allEntriesProvider).value ?? const [];
  return EmployerBalance.groupByEmployer(entries);
});

/// Meta de poupança atual.
final savingsGoalProvider = StreamProvider<SavingsGoal?>(
    (ref) => ref.watch(databaseProvider).watchCurrentGoal());

// ---- Autocomplete (histórico) ----

final employerSuggestionsProvider = FutureProvider<List<String>>(
    (ref) => ref.watch(databaseProvider).distinctEmployers());
final placeSuggestionsProvider = FutureProvider<List<String>>(
    (ref) => ref.watch(databaseProvider).distinctPlaces());
final serviceSuggestionsProvider = FutureProvider<List<String>>(
    (ref) => ref.watch(databaseProvider).distinctServiceTypes());

// ---- Comparativo Bitcoin ----

/// Comparativo de poupança em Bitcoin para o período selecionado (faz chamadas
/// de rede para cotações, com cache). autoDispose para refazer quando o período
/// ou o percentual mudam.
final bitcoinComparisonProvider =
    FutureProvider.autoDispose<BitcoinComparisonResult>((ref) async {
  final entries = ref.watch(entriesInPeriodProvider).value ?? const [];
  final pct = ref.watch(settingsProvider).bitcoinSavingsPct;
  return ref.watch(bitcoinCompareServiceProvider).compute(entries, pct);
});

// ---- Câmbio BRL (atual) ----

/// Taxa atual para BRL da moeda padrão (para o toggle "ver em Real").
final brlRateProvider = FutureProvider.family<double?, Currency>((ref, currency) {
  return ref.watch(fxServiceProvider).toBrlRate(currency);
});
