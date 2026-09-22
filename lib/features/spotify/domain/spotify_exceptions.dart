/// Errores de la integración con Spotify, tipados para que la UI pueda
/// mostrar un mensaje específico sin bloquear el resto de la app.
sealed class SpotifyIntegrationException implements Exception {
  const SpotifyIntegrationException(this.message);
  final String message;
}

class SpotifyNotInstalledException extends SpotifyIntegrationException {
  const SpotifyNotInstalledException()
      : super('Instala Spotify para escuchar música');
}

class SpotifyNoConnectionException extends SpotifyIntegrationException {
  const SpotifyNoConnectionException()
      : super('Sin conexión, no se pudo reproducir música');
}

class SpotifyNotAuthorizedException extends SpotifyIntegrationException {
  const SpotifyNotAuthorizedException()
      : super('Esta cuenta no está autorizada. Contacta al administrador de la app.');
}

class SpotifyNotConfiguredException extends SpotifyIntegrationException {
  const SpotifyNotConfiguredException()
      : super('Falta configurar Spotify (Client ID / playlist) en app_config.dart');
}

class SpotifyPlaybackFailedException extends SpotifyIntegrationException {
  const SpotifyPlaybackFailedException([String? detail])
      : super('No se pudo reproducir la música${detail != null ? ': $detail' : ''}');
}
