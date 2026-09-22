import 'package:flutter/material.dart';

import '../flowers/data/flower_asset_repository.dart';
import '../flowers/presentation/flower_fullscreen_view.dart';
import '../spotify/data/spotify_playback_service.dart';
import '../spotify/domain/spotify_exceptions.dart';
import '../spotify/presentation/spotify_status_banner.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _flowerRepository = FlowerAssetRepository();

  String? _assetPath;
  String? _spotifyErrorMessage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFlower();
    // Spotify tiene su propio timeout interno (ver SpotifyPlaybackService) y
    // no debe bloquear la foto: se dispara en paralelo, no se espera acá.
    _playRandomSong();
  }

  Future<void> _loadFlower() async {
    String? assetPath;
    try {
      assetPath = await _flowerRepository.pickRandom();
    } catch (_) {
      assetPath = null;
    }

    if (!mounted) return;
    setState(() {
      _assetPath = assetPath;
      _loading = false;
    });
  }

  Future<void> _playRandomSong() async {
    String? errorMessage;
    try {
      await SpotifyPlaybackService.playRandomFromPlaylist();
    } on SpotifyIntegrationException catch (e) {
      errorMessage = e.message;
    } catch (e, st) {
      debugPrint('[YF_DEBUG] Spotify error no tipado: $e\n$st');
      errorMessage = 'No se pudo reproducir la música';
    }

    if (!mounted || errorMessage == null) return;
    setState(() => _spotifyErrorMessage = errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    return FlowerFullscreenView(
      assetPath: _assetPath,
      banner: _spotifyErrorMessage != null
          ? SpotifyStatusBanner(message: _spotifyErrorMessage!)
          : null,
    );
  }
}
