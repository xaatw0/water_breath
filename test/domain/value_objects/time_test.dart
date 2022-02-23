import 'package:flutter_test/flutter_test.dart';
import 'package:water_breath/domain/value_objects/time.dart';

void main() {
  test('1秒', () async {
    var target = Time(100);
    expect(target.value, 100);
    expect(target(), 100);
    expect(target.secondPart, 1);
    expect(target.minutePart, 0);
  });

  test('150秒', () async {
    var target = Time(150 * 100);
    expect(target.value, 15000);
    expect(target(), 15000);
    expect(target.secondPart, 30);
    expect(target.minutePart, 2);
  });

  test('0.5秒', () async {
    var target = Time(50);
    expect(target.value, 50);
    expect(target(), 50);
    expect(target.secondPart, 0);
    expect(target.minutePart, 0);
  });

  test('2分30秒', () async {
    var target = Time.minutesSeconds(2, 30);
    expect(target.value, 15000);
    expect(target(), 15000);
    expect(target.secondPart, 30);
    expect(target.minutePart, 2);
  });
}
