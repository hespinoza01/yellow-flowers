import 'dart:async';

import 'package:spotify_sdk/spotify_sdk.dart'
    hide SpotifyNotInstalledException;
import 'package:spotify_sdk/spotify_sdk.dart' as sdk
    show SpotifyNotInstalledException;

import '../../../core/config/app_config.dart';
import '../domain/spotify_exceptions.dart';

/// Conecta con Spotify App Remote y reproduce una canción al azar de la
/// playlist configurada. `connectToSpotifyRemote` maneja la autorización
/// (delegada a la app oficial de Spotify) y la conexión en un solo paso;
/// no hace falta guardar tokens propios.
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
      await SpotifySdk.connectToSpotifyRemote(
        clientId: AppConfig.spotifyClientId,
        redirectUrl: AppConfig.spotifyRedirectUri,
      ).timeout(_connectTimeout);

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
    } on TimeoutException {
      throw const SpotifyPlaybackFailedException('Tiempo de espera agotado');
    }
  }

  // La primera conexión puede requerir que el usuario acepte el permiso
  // dentro de la app de Spotify, por eso el timeout de connect es más largo
  // que el de los comandos de reproducción.
  static const _connectTimeout = Duration(seconds: 20);
  static const _commandTimeout = Duration(seconds: 8);
}
