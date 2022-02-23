import 'package:just_audio/just_audio.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/logic/music_player.dart';
import 'package:water_breath/gen/assets.gen.dart';

class JustAudioPlayer implements MusicPlayer {
  final _player = AudioPlayer();

  final String assetConcentration;
  final String assetBreak;

  JustAudioPlayer(this.assetConcentration, this.assetBreak) {
    _player.setLoopMode(LoopMode.one);
  }

  @override
  void changeVolume(double value) {
    // TODO: implement changeVolume
  }

  @override
  void pause() {
    // TODO: implement pause
  }

  @override
  void play() async {
    _player.play();
  }

  @override
  void onModeChanged(PomodoroMode mode) {
    _player.stop();
    _player
        .setAsset(mode == PomodoroMode.concentration
            ? assetConcentration
            : assetBreak)
        .then((value) => play());
  }
}
