import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';

import '../../domain/value_objects/time.dart';

class PomodoroStatusStorage {
  static const PREF_KEY = 'key';
  Future<bool> save(PomodoroStatus status) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString(PREF_KEY, json.encode(status.toJson()));
  }

  Future<PomodoroStatus> load() async {
    var prefs = await SharedPreferences.getInstance();
    String? jsonData = await prefs.getString(PREF_KEY);
    if (jsonData != null) {
      return PomodoroStatus.fromJson(json.decode(jsonData));
    }
    return PomodoroStatus(
      concentrationTime: Time.minutes(25),
      restTime: Time.minutes(5),
    );
  }
}
