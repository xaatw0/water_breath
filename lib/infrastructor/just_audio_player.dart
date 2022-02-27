import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/logic/music_player.dart';
import 'package:water_breath/domain/value_objects/start_time.dart';
import 'package:water_breath/gen/assets.gen.dart';

import '../domain/value_objects/time.dart';

class JustAudioPlayer implements MusicPlayer {
  final _player = AudioPlayer();

  final String assetConcentration;
  final String assetBreak;

  Time timeConcentration = Time.minutes(25);
  Time timeBreak = Time.minutes(5);

  StartTime _startdTime = StartTime(DateTime.now());
  @override
  StartTime get startedTime => _startdTime;

  PomodoroMode _pomodoroMode = PomodoroMode.concentration;
  @override
  PomodoroMode get pomodoMode => _pomodoroMode;

  JustAudioPlayer(
    this.assetConcentration,
    this.assetBreak,
  ) {
    _player.playbackEventStream.listen((event) {
      print('--player--- $event');
      if (event.processingState == ProcessingState.completed) {
        print('---------complated');
        if (_pomodoroMode == PomodoroMode.concentration) {
          Future.delayed(Duration(milliseconds: 500), () {
            onModeChanged(PomodoroMode.restTime);
          });
        } else if (_pomodoroMode == PomodoroMode.restTime) {
          Future.delayed(Duration(milliseconds: 500), () {
            onModeChanged(PomodoroMode.concentration);
          });
        }
      }
    });
  }

  @override
  void setTime(Time timeConcentration, Time timeBreak) {
    this.timeConcentration = timeConcentration;
    this.timeBreak = timeBreak;
  }

  @override
  void changeVolume(double value) {
    // TODO: implement changeVolume
  }

  @override
  void pause() {
    _player.pause();
  }

  @override
  void play() async {
    _player.play();
    _startdTime = StartTime(DateTime.now());
  }

  @override
  void onModeChanged(PomodoroMode mode) {
    _pomodoroMode = mode;
    _player.stop();
    _player
        .setAsset(mode == PomodoroMode.concentration
            ? assetConcentration
            : assetBreak)
        .then((duration) {
      int lengthSound = duration!.inSeconds;
      int lengthMode = mode == PomodoroMode.concentration
          ? timeConcentration.inSecond
          : timeBreak.inSecond;
      print('lengthMode $lengthMode');
      //_player.seek(Duration(seconds: lengthSound - lengthMode));
      _player.setClip(
          start: Duration(seconds: 0), end: Duration(seconds: lengthMode));

      play();
    });
  }
}
