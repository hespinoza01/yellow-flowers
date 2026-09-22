import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:yellow_flowers/core/utils/date_utils.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  tz.Location utc() => tz.getLocation('UTC');

  test('antes del 21 de marzo del año actual -> usa ese mismo año', () {
    final now = tz.TZDateTime(utc(), 2026, 1, 10, 8, 0);
    final result = nextAnnualOccurrence(now, month: 3, day: 21, hour: 9, minute: 0);
    expect(result.year, 2026);
    expect(result.month, 3);
    expect(result.day, 21);
  });

  test('exacto 21 de marzo antes de la hora -> mismo día', () {
    final now = tz.TZDateTime(utc(), 2026, 3, 21, 8, 0);
    final result = nextAnnualOccurrence(now, month: 3, day: 21, hour: 9, minute: 0);
    expect(result.year, 2026);
    expect(result.month, 3);
    expect(result.day, 21);
    expect(result.hour, 9);
  });

  test('exacto 21 de marzo después de la hora -> salta al año siguiente', () {
    final now = tz.TZDateTime(utc(), 2026, 3, 21, 10, 0);
    final result = nextAnnualOccurrence(now, month: 3, day: 21, hour: 9, minute: 0);
    expect(result.year, 2027);
    expect(result.month, 3);
    expect(result.day, 21);
  });

  test('después del 21 de septiembre -> salta al año siguiente', () {
    final now = tz.TZDateTime(utc(), 2026, 10, 1, 8, 0);
    final result = nextAnnualOccurrence(now, month: 9, day: 21, hour: 9, minute: 0);
    expect(result.year, 2027);
    expect(result.month, 9);
    expect(result.day, 21);
  });
}
