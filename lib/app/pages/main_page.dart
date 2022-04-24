import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:water_breath/app/view/molecules/admob_banner.dart';

import '../helpers/admob_info.dart';
import '../helpers/app_open_ad_manager.dart';
import '../view/atoms/black_filter.dart';
import '../view/atoms/gap.dart';
import '../view/molecules/play_pause_button.dart';
import '../view/molecules/background_image.dart';
import '../view/molecules/menu_header.dart';
import '../view/organisms/pomodoro_timer.dart';
import '../view_model/main_page_vm.dart';

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
    _ticker = createTicker((elapsed) {
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
          const BackgroundImage(),
          BlackFilter(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                  child: MenuHeader(
                    onSetting: () => _vm.onSetting(context),
                    onBack: () => _vm.onBack(context),
                  ),
                ),
                Gap.h32,
                PomodoroTimer(
                  radius,
                  _vm.timer,
                ),
                Expanded(child: Container()),
                PlayPauseButton(
                  onPlayPauseTapped: onPlayPauseTapped,
                ),
                Expanded(child: Container()),
                _vm.admobBanner(context).when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text(error.toString()),
                      data: (AdmobBanner data) => data,
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
