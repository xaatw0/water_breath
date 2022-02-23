import 'package:flutter_test/flutter_test.dart';
import 'package:water_breath/domain/value_objects/start_time.dart';
import 'package:water_breath/domain/value_objects/time.dart';

void main() {
  test('getPastTime', () async {
    var startTime = StartTime(DateTime(1, 2, 3, 0, 0, 0));
    var currentTime = DateTime(1, 2, 3, 0, 2, 30);
    expect(startTime.getPastTime(currentTime), Time(150 * 100));
  });

  test('json', () async {
    var now = DateTime.now();
    var startTime = StartTime(now);
    var json = StartTimeConverter().toJson(startTime);
    var result = StartTimeConverter().fromJson(json);
    expect(now, result());
  });
}
