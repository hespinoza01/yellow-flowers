import 'package:audioplayers/audioplayers.dart';

import 'song_asset_repository.dart';

/// Reproduce canciones random de assets/audio/, en loop mientras la app
/// esté abierta. Todo local, sin red ni servicios externos.
class MusicPlayerService {
  MusicPlayerService({SongAssetRepository? repository})
      : _repository = repository ?? SongAssetRepository();

  final SongAssetRepository _repository;
  final AudioPlayer _player = AudioPlayer();

  /// true si había canciones cargadas para reproducir.
  Future<bool> playRandom() async {
    final assetPath = await _repository.pickRandom();
    if (assetPath == null) return false;

    await _player.stop();
    await _player.play(AssetSource(assetPath));
    return true;
  }

  Future<void> dispose() => _player.dispose();
}
