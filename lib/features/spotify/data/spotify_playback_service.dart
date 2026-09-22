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
      );

      await SpotifySdk.play(
        spotifyUri: 'spotify:playlist:${AppConfig.spotifyPlaylistId}',
      );
      await SpotifySdk.setShuffle(shuffle: true);
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
    }
  }
}
