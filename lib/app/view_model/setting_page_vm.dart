import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:water_breath/app/helpers/pomodoro_status_storage.dart';
import 'package:water_breath/app/providers.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';

import '../../domain/entities/pomodoro_status.dart';
import '../../domain/value_objects/time.dart';
import '../providers.dart';

class SettingPageVM {
  StateProvider<PomodoroStatus> _provider = StateProvider(
    (ref) => PomodoroStatus(
      concentrationTime: Time.minutes(25),
      restTime: Time.minutes(5),
    ),
  );

  late WidgetRef _ref;

  String get strConcentrationTime => _ref.watch(_provider.select((value) =>
      '${value.concentrationTime.minutePart}:${value.concentrationTime.secondPartStr}'));
  String get strRestTime => _ref.watch(_provider.select((value) =>
      '${value.restTime.minutePart}:${value.restTime.secondPartStr}'));

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  int initialIndex(PomodoroMode mode) {
    PomodoroStatus status = _ref.read(_provider);
    return (mode == PomodoroMode.concentration
            ? status.concentrationTime.minutePart
            : status.restTime.minutePart) -
        1;
  }

  void onChangeTime(PomodoroMode mode, int minutes) {
    if (mode == PomodoroMode.concentration) {
      _onChangeConcentrationTime(minutes);
    } else {
      _onChangeRestTime(minutes);
    }
  }

  void _onChangeConcentrationTime(int minutes) {
    _ref.read(_provider.notifier).update(
        (state) => state.copyWith(concentrationTime: Time.minutes(minutes)));
  }

  void _onChangeRestTime(int minutes) {
    _ref
        .read(_provider.notifier)
        .update((state) => state.copyWith(restTime: Time.minutes(minutes)));
  }

  void onUpdate(BuildContext context) {
    _ref.read(pomodoroUpdatedProvider.notifier).update((state) => true);
    PomodoroStatusStorage()
        .save(_ref.read(_provider))
        .then((value) => GoRouter.of(context).pop());
  }
}
