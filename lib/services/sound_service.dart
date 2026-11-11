import 'package:audioplayers/audioplayers.dart';
import '../controllers/settings_controller.dart';

/// Short sound effects. Follows the Sound switch in settings.
class SoundService {
  SoundService(this._settings);

  final SettingsController _settings;
  final _players = <String, AudioPlayer>{};

  void tap() => _play('tap');
  void warn() => _play('warn');
  void flag() => _play('flag');

  void _play(String name) {
    if (!_settings.sound) return;
    final player = _players.putIfAbsent(name, AudioPlayer.new);
    player
        .stop()
        .then((_) => player.play(AssetSource('sounds/$name.wav')))
        .catchError((_) {});
  }
}
