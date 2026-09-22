import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:spotify_sdk/spotify_sdk.dart'
    hide SpotifyNotInstalledException;
import 'package:spotify_sdk/spotify_sdk.dart' as sdk
    show SpotifyNotInstalledException;

import '../../../core/config/app_config.dart';
import '../domain/spotify_exceptions.dart';

/// Conecta con Spotify App Remote y reproduce una canción al azar de la
/// playlist configurada.
///
/// Notas de implementación (Android, spotify_sdk 4.x):
/// - `connectToSpotifyRemote`'s `accessToken` param se ignora completamente
///   en Android (ver AuthHandler.kt — ConnectionParams.Builder nunca lo
///   usa), así que no tiene sentido pasarlo.
/// - Aun así, la PRIMERA vez que este Client ID conecta con una cuenta,
///   `connectToSpotifyRemote` solo falla con `UserNotAuthorizedException`
///   sin mostrar ninguna pantalla de consentimiento. Hace falta completar
///   una vez el flujo OAuth explícito (`getAccessToken`, que sí abre la
///   pantalla de login/consentimiento de Spotify) para que quede
///   registrada la autorización; el token en sí se descarta. Después de
///   eso, `connectToSpotifyRemote` funciona solo.
/// - "Users and Access" del Dashboard NO aplica acá (el propio Dashboard
///   dice que es solo para Web API/Web Playback SDK) — la autorización de
///   App Remote es por cuenta + consentimiento explícito, no por esa lista.
class SpotifyPlaybackService {
  SpotifyPlaybackService._();

  static Future<void> playRandomFromPlaylist() async {
    if (!AppConfig.isSpotifyConfigured) {
      throw const SpotifyNotConfiguredException();
    }
    if (!AppConfig.isPlaylistConfigured) {
      throw const SpotifyNotConfiguredException();
    }

    final installed = await SpotifySdk.isSpotifyInstalled();
    if (!installed) {
      throw const SpotifyNotInstalledException();
    }

    try {
      await _connect();

      await SpotifySdk.play(
        spotifyUri: 'spotify:playlist:${AppConfig.spotifyPlaylistId}',
      ).timeout(_commandTimeout);
      await SpotifySdk.setShuffle(shuffle: true).timeout(_commandTimeout);
    } on sdk.SpotifyNotInstalledException {
      throw const SpotifyNotInstalledException();
    } on SpotifyAuthenticationException catch (_) {
      throw const SpotifyNotAuthorizedException();
    } on SpotifyConnectionException catch (e) {
      throw SpotifyPlaybackFailedException(e.message);
    } on SpotifyPlaybackException catch (e) {
      throw SpotifyPlaybackFailedException(e.message);
    } on SpotifyException catch (e) {
      throw SpotifyPlaybackFailedException(e.message);
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    } on TimeoutException {
      throw const SpotifyPlaybackFailedException('Tiempo de espera agotado');
    }
  }

  static Future<void> _connect() async {
    try {
      await SpotifySdk.connectToSpotifyRemote(
        clientId: AppConfig.spotifyClientId,
        redirectUrl: AppConfig.spotifyRedirectUri,
      ).timeout(_connectTimeout);
      return;
    } on PlatformException catch (e) {
      if (!_isNotAuthorized(e)) rethrow;
    }

    // No autorizado todavía: completar el flujo OAuth explícito una vez
    // para registrar el consentimiento (el token en sí no se usa).
    await SpotifySdk.getAccessToken(
      clientId: AppConfig.spotifyClientId,
      redirectUrl: AppConfig.spotifyRedirectUri,
    ).timeout(_connectTimeout);

    // Pequeño margen: conectar inmediatamente después de cerrar la
    // pantalla de login puede pegarle a un servicio de auth interno de
    // Spotify que todavía no terminó de asentar la nueva autorización.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    await SpotifySdk.connectToSpotifyRemote(
      clientId: AppConfig.spotifyClientId,
      redirectUrl: AppConfig.spotifyRedirectUri,
    ).timeout(_connectTimeout);
  }

  static bool _isNotAuthorized(PlatformException e) =>
      e.code.toLowerCase().contains('notauthorized') ||
      e.code.toLowerCase().contains('authenticationerror');

  static SpotifyIntegrationException _mapPlatformException(
    PlatformException e,
  ) {
    final code = e.code.toLowerCase();
    if (code.contains('notinstalled')) {
      return const SpotifyNotInstalledException();
    }
    if (code.contains('notauthorized') || code.contains('authenticationerror')) {
      return const SpotifyNotAuthorizedException();
    }
    return SpotifyPlaybackFailedException(e.message ?? e.code);
  }

  // La primera conexión puede requerir pantalla de login/consentimiento,
  // por eso el timeout de connect es más largo que el de reproducción.
  static const _connectTimeout = Duration(seconds: 20);
  static const _commandTimeout = Duration(seconds: 8);
}
