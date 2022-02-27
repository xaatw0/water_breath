import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/value_objects/start_time.dart';

import '../value_objects/time.dart';

abstract class MusicPlayer {
  void onModeChanged(PomodoroMode mode);
  void play();
  void pause();
  void changeVolume(double value);
  void setTime(Time timeConcentration, Time timeBreak);
  StartTime get startedTime;
  PomodoroMode get pomodoMode;
}
