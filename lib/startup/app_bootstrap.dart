import '../features/notifications/data/notification_scheduler.dart';
import '../features/notifications/notification_service.dart';

/// Inicializa notificaciones y programa los recordatorios anuales antes de
/// que arranque la UI. No bloquea el arranque si algo falla.
class AppBootstrap {
  AppBootstrap._();

  static Future<void> run() async {
    try {
      final initialized = await NotificationService.init();
      if (!initialized) return;

      await NotificationService.requestPermission();
      await NotificationScheduler.scheduleOrRescheduleYearlyReminders();
    } catch (_) {
      // Nunca debe bloquear el arranque de la app: la foto y la música
      // importan más que el recordatorio anual.
    }
  }
}
