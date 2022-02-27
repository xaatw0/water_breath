import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:water_breath/app/pages/router.dart';
import 'package:water_breath/app/workers/life_cycle.dart';

import '../view/atoms/black_filter.dart';
import '../view/molecules/play_pause_button.dart';
import '../view/molecules/background_image.dart';
import '../view/molecules/timer_circle.dart';
import '../view/molecules/menu_header.dart';
import '../view/organisms/pomodoro_timer.dart';
import '../view_model/main_page_vm.dart';
import 'router.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  static const id = '/';

  final String title;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late final double radius;

  late final MainPageVM _vm;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _vm = MainPageVM();
    _ticker = this.createTicker((elapsed) {
      _vm.onDisplayUpdated(DateTime.now());
    });
    _ticker.start();
    WidgetsBinding.instance!.addObserver(_vm.lifeCycle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          BlackFilter(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                  child: MenuHeader(
                    onSetting: () => _vm.onSetting(context),
                    onBack: () => _vm.onBack(context),
                  ),
                ),
                SizedBox(height: 32.0),
                PomodoroTimer(
                  radius,
                  _vm.timer,
                ),
                SizedBox(height: 64),
                PlayPauseButton(
                  onPlayPauseTapped: onPlayPauseTapped,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    radius = 0.45 * (width < height ? width : height);

    _vm.setRef(ref);
    _vm.play(DateTime.now());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _vm.dispose();
    WidgetsBinding.instance!.removeObserver(_vm.lifeCycle);
    super.dispose();
  }

  void onPlayPauseTapped(bool isPlaying) {
    if (isPlaying) {
      _vm.pause(DateTime.now());
    } else {
      _vm.play(DateTime.now());
    }
  }
}
