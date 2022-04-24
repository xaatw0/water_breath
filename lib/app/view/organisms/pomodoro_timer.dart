import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:water_breath/domain/entities/timer_entity.dart';

import '../molecules/timer_circle.dart';

class PomodoroTimer extends ConsumerWidget {
  PomodoroTimer(
    this.radius,
    this.timerEntity, {
    Key? key,
  }) : super(key: key);

  final double radius;

  final TimerEntity timerEntity;

  static const diffCircleSize = 0.03;
  static const storokeThin = 2.0;
  static const storokeThick = 5.0;

  int? rest_seconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var restCircle = TimerCircle(radius * (1 - diffCircleSize), storokeThick);
    restCircle.setRate(timerEntity.restRate);

    return Stack(
      children: [
        CustomPaint(
          size: Size(radius * 2, radius * 2),
          painter: TimerCircle(radius, storokeThin),
        ),
        Padding(
          padding: EdgeInsets.all(radius * diffCircleSize),
          child: CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: restCircle,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            radius * 0.1,
            radius * 0.5,
            radius * 0.1,
            radius * 0.0,
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              '${timerEntity.restTime.minutePart}:${timerEntity.restTime.secondPartStr}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 96,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
