import '../value_objects/start_time.dart';
import '../value_objects/time.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'pomodoro_status.freezed.dart';
part 'pomodoro_status.g.dart';

/**
 * 集中時間と休憩時間の設定を持つ
 */
@freezed
class PomodoroStatus with _$PomodoroStatus {
  const PomodoroStatus._(); //メソッド不要の場合、削除
  const factory PomodoroStatus({
    @TimeConverter() required Time concentrationTime,
    @TimeConverter() required Time restTime,
  }) = _PomodoroStatus;

  factory PomodoroStatus.fromJson(Map<String, dynamic> json) =>
      _$PomodoroStatusFromJson(json);
}
