import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifeCycle extends WidgetsBindingObserver {
  Function? funcOnResume;

  LifeCycle();

  void setOnResume(Function function) => funcOnResume = function;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        print('---------------detached');
        break;
      case AppLifecycleState.inactive:
        print('---------------inactive');
        break;
      case AppLifecycleState.resumed:
        if (funcOnResume != null) {
          funcOnResume!();
        }
        break;
      case AppLifecycleState.paused:
        print('---------------pause');
        break;
      default:
        print('---------------no state');
    }
  }
}
