import 'dart:math';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// Descubre las canciones (mp3) empaquetadas en assets/audio/ y elige una
/// al azar, sin necesidad de hardcodear nombres de archivo.
class SongAssetRepository {
  SongAssetRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const String _assetsFolder = 'assets/audio/';

  Future<List<String>> listSongAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest
        .listAssets()
        .where((path) => path.startsWith(_assetsFolder))
        .toList();
  }

  /// Devuelve el path de una canción random (relativo a `assets/`, listo
  /// para pasarle a AudioPlayer.play(AssetSource(...))), o null si no hay
  /// canciones cargadas todavía.
  Future<String?> pickRandom() async {
    final assets = await listSongAssets();
    if (assets.isEmpty) return null;

    final fullPath = assets[_random.nextInt(assets.length)];
    // AudioPlayer's AssetSource espera el path relativo a "assets/", no al
    // root del proyecto.
    return fullPath.substring('assets/'.length);
  }
}
