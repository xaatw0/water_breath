import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:water_breath/app/pages/go_router_observer.dart';
import 'package:water_breath/app/pages/main_page.dart';
import 'package:water_breath/app/pages/setting_page.dart';

final navigator = NavigatorObserver();
final router = GoRouter(
  initialLocation: MainPage.id,
  routes: [
    GoRoute(
      path: MainPage.id,
      pageBuilder: (BuildContext context, GoRouterState? state) => MaterialPage(
        key: state?.pageKey,
        child: MainPage(
          title: '',
        ),
      ),
    ),
    GoRoute(
      path: SettingPage.id,
      pageBuilder: (BuildContext context, GoRouterState? state) => MaterialPage(
        key: state?.pageKey,
        child: SettingPage(),
      ),
    ),
  ],
  observers: [
    GoRouterObserver(),
    navigator,
  ],
);
