import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobInfo {
  String appId();

  static Completer<AdmobInfo> _completer = Completer();
  static bool _isInitialized = false;

  String appOpenAdId();

  String bannerAdId();

  AdmobInfo._();

  static void initialize(TargetPlatform platform, bool isRelease) {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    AdmobInfo info = _AdmobInfoNoPlatform();
    if (platform == TargetPlatform.android) {
      info = isRelease ? _AdmobInfoAndroid._() : _AdmobInfoAndroidDemo._();
    } else if (platform == TargetPlatform.iOS) {
      info = isRelease ? _AdmobInfoIOS._() : _AdmobInfoIOSDemo._();
    }

    _completer.complete(info);
  }

  static Future<AdmobInfo> getInstance() async {
    return _completer.future;
  }

  BannerAd getBanner() {
    print('getBanner');

    return BannerAd(
      adUnitId: bannerAdId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('ad loaded'),
      ),
    )..load();
  }
}

class _AdmobInfoNoPlatform extends AdmobInfo {
  _AdmobInfoNoPlatform() : super._();
  @override
  String appId() => '';

  @override
  String bannerAdId() => '';

  @override
  String appOpenAdId() => '';
}

class _AdmobInfoAndroidDemo extends AdmobInfo {
  _AdmobInfoAndroidDemo._() : super._();

  @override
  String appId() => 'ca-app-pub-2831580726446381~8524127749';

  @override
  String bannerAdId() => 'ca-app-pub-3940256099942544/6300978111';

  @override
  String appOpenAdId() => 'ca-app-pub-3940256099942544/3419835294';
}

class _AdmobInfoIOSDemo extends AdmobInfo {
  _AdmobInfoIOSDemo._() : super._();

  @override
  String appId() => 'ca-app-pub-2831580726446381~4377871316';

  @override
  String appOpenAdId() => 'ca-app-pub-3940256099942544/5662855259';

  @override
  String bannerAdId() => 'ca-app-pub-3940256099942544/2934735716';
}

class _AdmobInfoAndroid extends _AdmobInfoAndroidDemo {
  _AdmobInfoAndroid._() : super._();

  @override
  String appOpenAdId() => 'ca-app-pub-2831580726446381/7718350525';

  @override
  String bannerAdId() => 'ca-app-pub-2831580726446381/4517434129';
}

class _AdmobInfoIOS extends _AdmobInfoIOSDemo {
  _AdmobInfoIOS._() : super._();
  @override
  String appOpenAdId() => 'ca-app-pub-2831580726446381/9241285375';

  @override
  String bannerAdId() => 'ca-app-pub-2831580726446381/8748979712';
}
