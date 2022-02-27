import 'package:freezed_annotation/freezed_annotation.dart';

class Time {
  final int value;

  /**
   * 100分の1秒を表す
   */
  Time(this.value);

  Time.minutesSeconds(int minutes, int seconds)
      : this(minutes * 60 * 100 + seconds * 100);

  Time.minutes(int minutes) : this(minutes * 60 * 100);

  int get minutePart {
    int second = (value / 100 % 60).ceil();
    int minutes = ((value / 100) / 60).floor();
    return minutes + (second == 60 ? 1 : 0);
  }

  int get secondPart {
    int second = (value / 100 % 60).ceil();
    return second == 60 ? 0 : second;
  }

  int get inSecond => (value / 100).floor();
  int call() => value;
  String get secondPartStr => secondPart.toString().padLeft(2, '0');

  @override
  int get hashCode => super.hashCode + value;

  @override
  bool operator ==(Object other) {
    if (super == other) {
      return true;
    }

    if (other is Time) {
      Time otherTime = other as Time;
      return this.value == otherTime.value;
    }
    return false;
  }

  @override
  String toString() {
    return "Time($value)";
  }
}

class TimeConverter implements JsonConverter<Time, String> {
  const TimeConverter();

  @override
  Time fromJson(String json) {
    return Time(int.parse(json));
  }

  @override
  String toJson(Time object) {
    return object().toString();
  }
}
