import 'package:water_breath/app/view_model/main_page_vm.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';
import 'package:water_breath/domain/entities/timer_entity.dart';

import '../value_objects/start_time.dart';
import '../value_objects/time.dart';

enum PomodoroMode { concentration, restTime }

class PomodoroWatch {
  TimerEntity _timerEntity;
  TimerEntity get timerEntity => _timerEntity;

  final PomodoroStatus pomodoroStatus;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  PomodoroMode mode = PomodoroMode.concentration;
  StartTime? _startTime;
  StartTime? get startTime => _startTime;

  Time? _pastTimeOnPlay;
  Time get pastTimeOnPlay => _pastTimeOnPlay ?? Time(0);

  final List<OnModeChange> onModeChange = [];

  PomodoroWatch(this.pomodoroStatus)
      : _timerEntity = TimerEntity(
          total: pomodoroStatus.concentrationTime,
          past: Time.minutes(0),
        );

  void stop() {
    _isPlaying = false;
    _startTime = null;
    reset();
  }

  void pause(DateTime now) {
    onTimer(now);

    _isPlaying = false;
    //_pastTimeOnPlay = startTime!.getPastTime(now);

    _startTime = null;
  }

  void play(StartTime now) {
    _isPlaying = true;
    _startTime = now;
    _pastTimeOnPlay = _timerEntity.past;
  }

  void reset() {
    _timerEntity = TimerEntity(
      total: pomodoroStatus.concentrationTime,
      past: Time.minutes(0),
    );
  }

  void resume(PomodoroMode modeWhenResume, StartTime startTime) {
    _startTime = startTime;

    if (mode != modeWhenResume) {
      mode = modeWhenResume;
      _timerEntity = _timerEntity.copyWith(
          total: mode == PomodoroMode.concentration
              ? pomodoroStatus.concentrationTime
              : pomodoroStatus.restTime);
    }
  }

  void addChangeModeEvent(OnModeChange event) {
    onModeChange.add(event);
  }

  void changeMode() {
    Time total = Time(0);
    if (mode == PomodoroMode.concentration) {
      mode = PomodoroMode.restTime;
      total = pomodoroStatus.restTime;
    } else if (mode == PomodoroMode.restTime) {
      mode = PomodoroMode.concentration;
      total = pomodoroStatus.concentrationTime;
    } else {
      throw UnsupportedError('Illegal mode');
    }

    _timerEntity = TimerEntity(
      total: total,
      past: Time.minutes(0),
    );

    onModeChange.forEach((element) {
      element(mode);
    });
  }

  void onTimer(DateTime now) {
    if (startTime == null || _pastTimeOnPlay == null) {
      return;
    }

    Duration duration = now.difference(startTime!());
    int pastTimeAfterPlay = (duration.inMilliseconds / 10).toInt();
    int pastTimeOnPlay = _pastTimeOnPlay!();

    _timerEntity =
        _timerEntity.copyWith(past: Time(pastTimeOnPlay + pastTimeAfterPlay));

    if (_timerEntity.isFinished) {
      onModeFinished(now);
    }
  }

  void onModeFinished(DateTime now) {
    changeMode();
    play(StartTime(now));
  }
}
