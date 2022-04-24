import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_breath/app/view_model/setting_page_vm.dart';
import 'package:water_breath/domain/entities/pomodoro_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:water_breath/domain/entities/pomodoro_watch.dart';

import '../../domain/value_objects/time.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  static const id = '/setting_page';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  SettingPageVM _vm = SettingPageVM();

  @override
  void initState() {
    super.initState();
    _vm.setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).setting), //'設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 32),
        child: Center(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).concentrationTime, //'集中時間',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(
                onPressed: () {
                  _showPicker(PomodoroMode.concentration);
                },
                child: Text(
                  _vm.strConcentrationTime,
                ),
              ),
              Text(
                AppLocalizations.of(context).breakTime, //'休憩時間',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(
                onPressed: () {
                  _showPicker(PomodoroMode.restTime);
                },
                child: Text(_vm.strRestTime),
              ),
              OutlinedButton.icon(
                onPressed: () => _vm.onUpdate(context),
                label: Text(AppLocalizations.of(context).ok), //'反映'),
                icon: Icon(
                  Icons.check,
                  size: 48,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(PomodoroMode mode) {
    showCupertinoModalPopup<int>(
      context: context,
      builder: (context) => Container(
        height: 200,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: _vm.initialIndex(mode),
          ),
          itemExtent: 32.0,
          onSelectedItemChanged: (int index) {
            _vm.onChangeTime(mode, index + 1);
          },
          children: [
            ...List.generate(
              60,
              (index) => Text(
                (index + 1).toString(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
