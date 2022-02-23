import 'package:flutter_test/flutter_test.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';
import 'package:water_breath/domain/value_objects/start_time.dart';
import 'package:water_breath/domain/value_objects/time.dart';

void main() {
  test('基本', () async {
    var pomodoStatus = PomodoroStatus(
      concentrationTime: Time.minutes(25),
      restTime: Time.minutes(5),
    );

    // 初期状態
    PomodoroWatch target = PomodoroWatch(pomodoStatus);
    expect(target.isPlaying, false);
    expect(target.startTime, null);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0);
    expect(target.timerEntity.restTime, Time(25 * 60 * 100));
    expect(target.timerEntity.past, Time(0 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0));

    // 開始(集中)
    DateTime dtStart = DateTime(2022, 1, 1, 0, 0, 0);
    target.play(StartTime(dtStart));
    expect(target.isPlaying, true);
    expect(target.startTime!(), dtStart);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0);
    expect(target.timerEntity.restTime, Time(25 * 60 * 100));
    expect(target.timerEntity.past, Time(0 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0));

    // 途中(集中,10分経過)
    DateTime dateTime1 = DateTime(2022, 1, 1, 0, 10, 0);
    target.onTimer(dateTime1);
    expect(target.isPlaying, true);
    expect(target.startTime!(), dtStart);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 10.0 / 25.0);
    expect(target.timerEntity.restTime, Time(15 * 60 * 100));
    expect(target.timerEntity.past, Time(10 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0));

    // 途中(集中,12分経過),一時停止
    DateTime dateTime2 = DateTime(2022, 1, 1, 0, 12, 0);
    target.pause(dateTime2);
    expect(target.isPlaying, false);
    expect(target.startTime, isNull);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restTime, Time(13 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 12.0 / 25.0);
    expect(target.timerEntity.past, Time(12 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0));

    // 途中(集中,12分経過,1分休憩),1分後、再開
    DateTime dateTime3 = DateTime(2022, 1, 1, 0, 13, 0);
    target.play(StartTime(dateTime3));
    expect(target.isPlaying, true);
    expect(target.startTime!.startTime, dateTime3);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restTime, Time(13 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 12.0 / 25.0);
    expect(target.timerEntity.past, Time(12 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(12 * 60 * 100));

    // 途中(集中,12分経過,1分休憩),1分後、再開12分後
    DateTime dateTime4 = DateTime(2022, 1, 1, 0, 25, 0);
    target.onTimer(dateTime4);
    expect(target.isPlaying, true);
    expect(target.startTime!.startTime, dateTime3);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restTime, Time(1 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 24.0 / 25.0);
    expect(target.timerEntity.past, Time(24 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(12 * 60 * 100));

    // 途中(集中,12分経過,1分休憩),1分後、再開13分後　→休憩に切換
    DateTime dateTime5 = DateTime(2022, 1, 1, 0, 26, 0);
    target.onTimer(dateTime5);
    expect(target.isPlaying, true);
    expect(target.mode, PomodoroMode.breakTime);
    expect(target.startTime!.startTime, dateTime5);
    expect(target.timerEntity.total, Time(5 * 60 * 100));
    expect(target.timerEntity.restTime, Time(5 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 0.0 / 25.0);
    expect(target.timerEntity.past, Time(0 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0 * 60 * 100));

    // 休憩で4分経過
    DateTime dateTime6 = DateTime(2022, 1, 1, 0, 30, 0);
    target.onTimer(dateTime6);
    expect(target.isPlaying, true);
    expect(target.mode, PomodoroMode.breakTime);
    expect(target.startTime!.startTime, dateTime5);
    expect(target.timerEntity.total, Time(5 * 60 * 100));
    expect(target.timerEntity.restTime, Time(1 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 4.0 / 5.0);
    expect(target.timerEntity.past, Time(4 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0 * 60 * 100));

    // 休憩で5分経過→集中へ
    DateTime dateTime7 = DateTime(2022, 1, 1, 0, 31, 0);
    target.onTimer(dateTime7);
    expect(target.isPlaying, true);
    expect(target.mode, PomodoroMode.concentration);
    expect(target.startTime!.startTime, dateTime7);
    expect(target.timerEntity.total, Time(25 * 60 * 100));
    expect(target.timerEntity.restTime, Time(25 * 60 * 100));
    expect(target.timerEntity.restRate, 1.0 - 0.0 / 5.0);
    expect(target.timerEntity.past, Time(0 * 60 * 100));
    expect(target.pastTimeOnPlay, Time(0 * 60 * 100));

    target.stop();
  });
}
