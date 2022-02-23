import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:water_breath/domain/value_objects/time.dart';

class StartTime {
  final DateTime startTime;
  StartTime(this.startTime);

  DateTime call() => startTime;

  StartTime.now() : this(DateTime.now());

  Time getPastTime(DateTime now) {
    var duration = now.difference(startTime);
    var value = duration.inMilliseconds / 10;
    return Time(value.ceil());
  }

  @override
  bool operator ==(Object other) {
    if (this == other) {
      return true;
    }

    if (other is StartTime) {
      var otherTime = startTime as StartTime;
      return otherTime.startTime == this.startTime;
    }

    return false;
  }

  @override
  String toString() {
    return 'StartTime($startTime)';
  }
}

class StartTimeConverter implements JsonConverter<StartTime, String> {
  const StartTimeConverter();

  @override
  StartTime fromJson(String json) {
    return StartTime(DateTime.parse(json));
  }

  @override
  String toJson(StartTime object) {
    return object().toString();
  }
}
