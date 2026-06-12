import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Lembretes locais: registrar a diária do dia e cobrar pagamentos atrasados.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _dailyId = 1001;
  static const _pendingId = 1002;

  static const _dailyChannel = AndroidNotificationChannel(
    'anotai_daily',
    'Lembrete diário',
    description: 'Lembra de registrar o trabalho do dia.',
    importance: Importance.high,
  );
  static const _pendingChannel = AndroidNotificationChannel(
    'anotai_pending',
    'Pagamentos pendentes',
    description: 'Avisa sobre diárias não recebidas há muito tempo.',
    importance: Importance.high,
  );

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(_dailyChannel);
    await androidImpl?.createNotificationChannel(_pendingChannel);
    _ready = true;
  }

  /// Pede a permissão de notificações (Android 13+).
  Future<bool> requestPermission() async {
    await init();
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidImpl?.requestNotificationsPermission() ?? true;
  }

  /// Agenda (ou reagenda) o lembrete diário no horário [hour]:[minute].
  Future<void> scheduleDailyReminder(int hour, int minute) async {
    await init();
    await _plugin.cancel(_dailyId);
    await _plugin.zonedSchedule(
      _dailyId,
      'Registrar diária de hoje',
      'Leva 10 segundos: toque para anotar o trabalho do dia.',
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'anotai_daily',
          'Lembrete diário',
          channelDescription: 'Lembra de registrar o trabalho do dia.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repete todo dia
    );
  }

  /// Mostra imediatamente um aviso de pagamentos pendentes há muito tempo.
  Future<void> showPendingAlert(int count, String detail) async {
    await init();
    await _plugin.show(
      _pendingId,
      'Você tem $count diária(s) pendente(s)',
      detail,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'anotai_pending',
          'Pagamentos pendentes',
          channelDescription: 'Avisa sobre diárias não recebidas.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancelDailyReminder() => _plugin.cancel(_dailyId);

  /// Próxima ocorrência de [hour]:[minute] no fuso local.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
