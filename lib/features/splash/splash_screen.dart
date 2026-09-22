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
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final results = await Future.wait([
      _loadRandomFlower(),
      _playRandomSong(),
    ]);

    if (!mounted) return;
    setState(() {
      _assetPath = results[0];
      _loading = false;
    });
  }

  Future<String?> _loadRandomFlower() async {
    try {
      return await _flowerRepository.pickRandom();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _playRandomSong() async {
    try {
      await SpotifyPlaybackService.playRandomFromPlaylist();
      return null;
    } on SpotifyIntegrationException catch (e) {
      _spotifyErrorMessage = e.message;
      return null;
    } catch (_) {
      _spotifyErrorMessage = 'No se pudo reproducir la música';
      return null;
    }
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
