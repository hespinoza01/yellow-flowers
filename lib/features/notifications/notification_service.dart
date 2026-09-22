import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Inicializa el plugin de notificaciones locales y el manejo de timezone.
/// No lanza excepciones hacia arriba: si algo falla (permiso denegado, etc.)
/// la app sigue funcionando sin notificaciones programadas.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const String reminderChannelId = 'yearly_reminder_channel';
  static const String reminderChannelName = 'Recordatorio flores amarillas';
  static const String reminderChannelDescription =
      'Recordatorio anual para abrir la app en el día de las flores amarillas';

  static bool _initialized = false;

  static Future<bool> init() async {
    if (_initialized) return true;

    try {
      tz_data.initializeTimeZones();
      final deviceTimeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTimeZoneName));
    } catch (_) {
      // Si falla la detección de timezone del dispositivo, timezone package
      // sigue en UTC como fallback; no bloquea el resto de la app.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    try {
      await plugin.initialize(settings: initSettings);

      const androidChannel = AndroidNotificationChannel(
        reminderChannelId,
        reminderChannelName,
        description: reminderChannelDescription,
        importance: Importance.high,
      );

      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      _initialized = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Pide permiso POST_NOTIFICATIONS (Android 13+). No bloquea el flujo si
  /// se deniega.
  static Future<bool> requestPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }
}
