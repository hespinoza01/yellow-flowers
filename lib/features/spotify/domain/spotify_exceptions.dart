/// Errores de la integración con Spotify, tipados para que la UI pueda
/// mostrar un mensaje específico sin bloquear el resto de la app.
sealed class SpotifyIntegrationException implements Exception {
  const SpotifyIntegrationException(this.message);
  final String message;
}

class SpotifyNotConfiguredException extends SpotifyIntegrationException {
  const SpotifyNotConfiguredException()
      : super('Falta configurar la playlist en app_config.dart');
}

class SpotifyLaunchFailedException extends SpotifyIntegrationException {
  const SpotifyLaunchFailedException()
      : super('No se pudo abrir Spotify. Instálalo para escuchar música.');
}
