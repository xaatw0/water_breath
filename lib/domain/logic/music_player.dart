import 'package:water_breath/domain/entities/pomodoro_watch.dart';

abstract class MusicPlayer {
  void onModeChanged(PomodoroMode mode);
  void play();
  void pause();
  void changeVolume(double value);
}
