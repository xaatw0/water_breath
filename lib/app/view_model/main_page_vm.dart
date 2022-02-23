import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/entities/timer_entity.dart';
import 'package:water_breath/gen/assets.gen.dart';
import 'package:water_breath/infrastructor/just_audio_player.dart';

import '../../domain/entities/timer_entity.dart';
import '../../domain/value_objects/start_time.dart';
import '../../domain/value_objects/time.dart';

typedef OnModeChange = void Function(PomodoroMode mode);

class MainPageVM {
  var _provider = StateProvider<TimerEntity>(
    (ref) => TimerEntity(
      total: Time.minutesSeconds(5, 0),
      past: Time.minutesSeconds(0, 0),
    ),
  );

  var _logic = PomodoroWatch(
    PomodoroStatus(
      concentrationTime: Time(1000), // Time.minutes(5),
      restTime: Time(200), // Time.minutes(1),
    ),
  );

  final _player = JustAudioPlayer(Assets.sounds.water, Assets.sounds.pianoM4a);

  void onModeChanged(PomodoroMode mode) {
    _player.onModeChanged(mode);
  }

  var _isPlayingProvider = StateProvider<bool>((ref) => true);

  late WidgetRef _ref;

  TimerEntity get timer => _ref.watch(_provider);
  bool get isPlaying => _ref.watch(_isPlayingProvider);

  void setRef(WidgetRef ref) {
    _ref = ref;
    _player.onModeChanged(PomodoroMode.concentration);
    _logic.addChangeModeEvent(_player.onModeChanged);
  }

  void play(DateTime now) {
    _logic.play(StartTime(now));
    _update();
  }

  void pause(DateTime now) {
    _logic.pause(now);
    _update();
  }

  void reset(DateTime now) {}

  void onDisplayUpdated(DateTime now) {
    _logic.onTimer(now);
    _update();
  }

  void _update() {
    _ref.read(_isPlayingProvider.notifier).update((state) => _logic.isPlaying);
    _ref.read(_provider.notifier).update((state) => _logic.timerEntity);
  }
}
