/// Configuración de la app. Completar los TODO antes de usar en producción.
class AppConfig {
  AppConfig._();

  /// Client ID de la app creada en developer.spotify.com/dashboard.
  static const String spotifyClientId = 'd08067995189494f86228a32af0bfcab';

  /// Debe coincidir exacto con el Redirect URI configurado en el Dashboard
  /// y con el intent-filter en AndroidManifest.xml.
  static const String spotifyRedirectUri = 'yellowflowers://callback';

  /// ID de la playlist (el código después de `spotify:playlist:` en la URI,
  /// o el segmento final de la URL de compartir de la playlist).
  static const String spotifyPlaylistId = '1rZ6nT6hQiLCMUgYVD3HEx';

  /// Hora del día (24h, hora local) a la que dispara el recordatorio anual.
  static const int reminderHour = 9;
  static const int reminderMinute = 0;

  /// Si false, solo se programa el 21 de septiembre (hemisferio sur).
  /// Si false y se quiere solo hemisferio norte, invertir la lógica en
  /// NotificationScheduler.
  static const bool scheduleBothHemisphereDates = true;

  static bool get isSpotifyConfigured =>
      spotifyClientId != 'TODO_SPOTIFY_CLIENT_ID' && spotifyClientId.isNotEmpty;

  static bool get isPlaylistConfigured =>
      spotifyPlaylistId != 'TODO_PLAYLIST_ID' && spotifyPlaylistId.isNotEmpty;
}
