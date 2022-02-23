import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../value_objects/start_time.dart';
import '../value_objects/time.dart';

part 'timer_entity.freezed.dart';

/**
 * タイマーの状態を表す。
 */
@freezed
class TimerEntity with _$TimerEntity {
  const TimerEntity._(); //メソッド不要の場合、削除
  const factory TimerEntity({
    /** 合計の時間 */
    @TimeConverter() required Time total,

    /** 経過した時間 */
    @TimeConverter() required Time past,
  }) = _TimerEntity;

  /** 経過した割合 */
  double get restRate => 1.0 - past().toDouble() / total().toDouble();

  /** 現在のタイマーが終了したか */
  bool get isFinished => total() <= past();

  /** 残り時間 */
  Time get restTime => Time(total.value - past.value);
}
