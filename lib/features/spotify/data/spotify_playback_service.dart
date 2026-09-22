import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../domain/spotify_exceptions.dart';

/// Abre la playlist configurada directamente en la app de Spotify vía deep
/// link (URI `spotify:playlist:...`). No usa el App Remote SDK: evita por
/// completo la configuración de Client ID/SHA1/autorización en el
/// Dashboard, a costa de que Spotify se abre como app aparte (no queda
/// sonando "por debajo" mientras se ve la foto/mensaje en esta app).
class SpotifyPlaybackService {
  SpotifyPlaybackService._();

  static Future<void> playRandomFromPlaylist() async {
    if (!AppConfig.isPlaylistConfigured) {
      throw const SpotifyNotConfiguredException();
    }

    final playlistUri = Uri.parse(
      'spotify:playlist:${AppConfig.spotifyPlaylistId}',
    );
    final webFallback = Uri.parse(
      'https://open.spotify.com/playlist/${AppConfig.spotifyPlaylistId}',
    );

    final openedApp = await _tryLaunch(playlistUri);
    if (openedApp) return;

    final openedWeb = await _tryLaunch(webFallback);
    if (openedWeb) return;

    throw const SpotifyLaunchFailedException();
  }

  static Future<bool> _tryLaunch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
