import 'package:flutter_test/flutter_test.dart';
import 'package:water_breath/domain/entities/timer_entity.dart';
import 'package:water_breath/domain/value_objects/time.dart';

void main() {
  test('base', () async {
    var target_start = TimerEntity(total: Time(100), past: Time(0));
    expect(target_start.restRate, 1);
    expect(target_start.isFinished, false);

    var target = TimerEntity(total: Time(100), past: Time(60));
    expect(target.restRate, 0.4);
    expect(target.isFinished, false);

    var target_end = TimerEntity(total: Time(100), past: Time(100));
    expect(target_end.restRate, 0);
    expect(target_end.isFinished, true);
  });
}
