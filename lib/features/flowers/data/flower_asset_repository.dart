import 'dart:math';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// Descubre las fotos de flores amarillas empaquetadas en
/// assets/images/flowers/ y elige una al azar, sin necesidad de
/// hardcodear nombres de archivo.
class FlowerAssetRepository {
  FlowerAssetRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const String _assetsFolder = 'assets/images/flowers/';

  Future<List<String>> listFlowerAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest.listAssets().where(
          (path) => path.startsWith(_assetsFolder) && !path.endsWith('.gitkeep'),
        ).toList();
  }

  /// Devuelve el path de un asset random, o null si no hay fotos cargadas
  /// todavía.
  Future<String?> pickRandom() async {
    final assets = await listFlowerAssets();
    if (assets.isEmpty) return null;
    return assets[_random.nextInt(assets.length)];
  }
}
