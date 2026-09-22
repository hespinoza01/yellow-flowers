/// Configuración de la app.
class AppConfig {
  AppConfig._();

  /// Hora del día (24h, hora local) a la que dispara el recordatorio anual.
  static const int reminderHour = 9;
  static const int reminderMinute = 0;

  /// Si false, solo se programa el 21 de septiembre (hemisferio sur).
  /// Si false y se quiere solo hemisferio norte, invertir la lógica en
  /// NotificationScheduler.
  static const bool scheduleBothHemisphereDates = true;
}
