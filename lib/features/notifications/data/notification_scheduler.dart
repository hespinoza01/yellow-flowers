import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/config/app_config.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;
import '../notification_service.dart';

/// Programa (y reprograma en cada arranque, de forma idempotente) los
/// recordatorios anuales del día de las flores amarillas: 21 de marzo
/// (hemisferio norte) y 21 de septiembre (hemisferio sur).
class NotificationScheduler {
  NotificationScheduler._();

  static const int _marchNotificationId = 101;
  static const int _septemberNotificationId = 102;

  static Future<void> scheduleOrRescheduleYearlyReminders() async {
    final now = tz.TZDateTime.now(tz.local);

    await _scheduleOne(
      id: _marchNotificationId,
      now: now,
      month: 3,
      day: 21,
    );

    if (AppConfig.scheduleBothHemisphereDates) {
      await _scheduleOne(
        id: _septemberNotificationId,
        now: now,
        month: 9,
        day: 21,
      );
    }
  }

  static Future<void> _scheduleOne({
    required int id,
    required tz.TZDateTime now,
    required int month,
    required int day,
  }) async {
    final nextOccurrence = app_date_utils.nextAnnualOccurrence(
      now,
      month: month,
      day: day,
      hour: AppConfig.reminderHour,
      minute: AppConfig.reminderMinute,
    );

    final pending = await NotificationService.plugin.pendingNotificationRequests();
    final alreadyScheduled = pending.any((p) => p.id == id);

    if (alreadyScheduled) {
      // Idempotente: si ya hay una notificación programada con este id,
      // asumimos que sigue apuntando a la próxima ocurrencia correcta
      // (se reprograma solo cuando dispara y la app se vuelve a abrir,
      // momento en el que pendingNotificationRequests ya no la incluye).
      return;
    }

    await NotificationService.plugin.zonedSchedule(
      id: id,
      title: '¡Feliz día de las flores amarillas! 🌼',
      body: 'Abre la app para recibir tus flores amarillas de hoy',
      scheduledDate: nextOccurrence,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationService.reminderChannelId,
          NotificationService.reminderChannelName,
          channelDescription: NotificationService.reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
