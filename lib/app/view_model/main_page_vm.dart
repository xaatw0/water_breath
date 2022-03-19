import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:water_breath/app/helpers/pomodoro_status_storage.dart';
import 'package:water_breath/app/pages/setting_page.dart';
import 'package:water_breath/app/providers.dart';
import 'package:water_breath/app/workers/life_cycle.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/entities/timer_entity.dart';
import 'package:water_breath/gen/assets.gen.dart';
import 'package:water_breath/infrastructor/just_audio_player.dart';

import '../../domain/entities/timer_entity.dart';
import '../../domain/value_objects/start_time.dart';
import '../../domain/value_objects/time.dart';
import '../helpers/admob_info.dart';
import '../view/molecules/admob_banner.dart';

typedef OnModeChange = void Function(PomodoroMode mode);

class MainPageVM {
  var timerEntityProvider = StateProvider<TimerEntity>(
    (ref) => TimerEntity(
      total: Time.minutesSeconds(5, 0),
      past: Time.minutesSeconds(0, 0),
    ),
  );

  late PomodoroWatch _logic;

  final _player = JustAudioPlayer(Assets.sounds.water, Assets.sounds.piano);
  var pomodoroStatus = PomodoroStatus(
    concentrationTime: Time.minutes(1),
    restTime: Time(20 * 100), // Time.minutes(1),
  );

  final _admobProvider =
      FutureProvider.family<AdmobBanner, BuildContext>((ref, context) async {
    TargetPlatform platform = Theme.of(context).platform;
    bool isRelease = const bool.fromEnvironment('dart.vm.product');
    await AdmobInfo.initialize(platform, isRelease);

    AdmobInfo admobInfo = await AdmobInfo.getInstance();
    return AdmobBanner(admobInfo.getBanner());
  });

  AsyncValue<AdmobBanner> admobBanner(BuildContext context) =>
      _ref.watch(_admobProvider(context));

  void onModeChanged(PomodoroMode mode) {
    _player.onModeChanged(mode);
  }

  final _isPlayingProvider = StateProvider<bool>((ref) => true);

  final LifeCycle lifeCycle = LifeCycle();

  late WidgetRef _ref;

  late Timer _timer;

  TimerEntity get timer => _ref.watch(timerEntityProvider);
  bool get isPlaying => _ref.watch(_isPlayingProvider);

  void setRef(WidgetRef ref) {
    _ref = ref;
    _player.onModeChanged(PomodoroMode.concentration);
    _player.setTime(
      pomodoroStatus.concentrationTime,
      pomodoroStatus.restTime,
    );

    _logic = PomodoroWatch(pomodoroStatus);
    lifeCycle.setOnResume(_onResume);
    //_logic.addChangeModeEvent(_player.onModeChanged);

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print(_ref.read(timerEntityProvider).restTime.inSecond);
    });
  }

  void play(DateTime now) {
    _logic.play(StartTime(now));
    _player.play();
    _update();
  }

  void pause(DateTime now) {
    _logic.pause(now);
    _player.pause();
    _update();
  }

  void reset(DateTime now) {}

  void onDisplayUpdated(DateTime now) {
    if (_ref.read(pomodoroUpdatedProvider)) {
      _ref.read(pomodoroUpdatedProvider.notifier).update((state) => false);
      _onPomodoroStatusUpdated(now);
      return;
    }
    _logic.onTimer(now);
    _update();
  }

  void _update() {
    _ref.read(_isPlayingProvider.notifier).update((state) => _logic.isPlaying);
    _ref
        .read(timerEntityProvider.notifier)
        .update((state) => _logic.timerEntity);
  }

  void _onResume() {
    _logic.resume(_player.pomodoMode, _player.startedTime);
  }

  void onSetting(BuildContext context) {
    GoRouter.of(context).push(SettingPage.id);
  }

  void onBack(BuildContext context) {
    print('back');
  }

  void dispose() {
    _timer.cancel();
  }

  void _onPomodoroStatusUpdated(DateTime now) {
    PomodoroStatusStorage().load().then((value) {
      pomodoroStatus = value;
      _player.onModeChanged(PomodoroMode.concentration);
      _player.setTime(
        pomodoroStatus.concentrationTime,
        pomodoroStatus.restTime,
      );

      _logic = PomodoroWatch(pomodoroStatus);
      play(now);
    });
  }
}
