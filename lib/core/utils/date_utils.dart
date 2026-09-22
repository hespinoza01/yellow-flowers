import 'package:timezone/timezone.dart' as tz;

/// Calcula la próxima ocurrencia futura de una fecha anual fija
/// (mes/día, hora local), a partir de [now]. Si hoy ya es esa fecha pero la
/// hora ya pasó, devuelve la del año siguiente.
tz.TZDateTime nextAnnualOccurrence(
  tz.TZDateTime now, {
  required int month,
  required int day,
  required int hour,
  required int minute,
}) {
  var candidate = tz.TZDateTime(
    now.location,
    now.year,
    month,
    day,
    hour,
    minute,
  );

  if (!candidate.isAfter(now)) {
    candidate = tz.TZDateTime(
      now.location,
      now.year + 1,
      month,
      day,
      hour,
      minute,
    );
  }

  return candidate;
}
