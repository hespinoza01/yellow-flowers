import 'dart:math';

import 'package:flutter/material.dart';

import '../flowers/data/flower_asset_repository.dart';
import '../flowers/presentation/flower_fullscreen_view.dart';
import '../messages/data/romantic_messages.dart';
import '../music/data/music_player_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _flowerRepository = FlowerAssetRepository();
  final _random = Random();
  final _musicPlayer = MusicPlayerService();

  String? _assetPath;
  late String _message = _pickRandomMessage();
  String? _musicErrorMessage;
  bool _loading = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _loadFlower();
    _playRandomSong();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  String _pickRandomMessage() =>
      RomanticMessages.all[_random.nextInt(RomanticMessages.all.length)];

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
      final played = await _musicPlayer.playRandom();
      if (!played) {
        errorMessage = 'Agrega canciones en assets/audio/';
      }
    } catch (_) {
      errorMessage = 'No se pudo reproducir la música';
    }

    if (!mounted) return;
    setState(() => _musicErrorMessage = errorMessage);
  }

  Future<void> _refreshAll() async {
    setState(() {
      _refreshing = true;
      _message = _pickRandomMessage();
    });

    await Future.wait([_loadFlower(), _playRandomSong()]);

    if (!mounted) return;
    setState(() => _refreshing = false);
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
      message: _message,
      refreshing: _refreshing,
      onRefreshAll: _refreshAll,
      banner: _musicErrorMessage != null
          ? _MusicStatusBanner(message: _musicErrorMessage!)
          : null,
    );
  }
}

class _MusicStatusBanner extends StatelessWidget {
  const _MusicStatusBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.music_off, color: Colors.white70, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
