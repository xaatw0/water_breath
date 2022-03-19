import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_breath/app/helpers/admob_info.dart';

void main() {
  test('', () async {
    AdmobInfo.initialize(TargetPlatform.android, false);
    AdmobInfo admobInfoAndroid = await AdmobInfo.getInstance();
    expect(admobInfoAndroid.bannerAdId(),
        'ca-app-pub-3940256099942544/6300978111');
//    AdmobInfo admobInfoIOS = AdmobInfo(TargetPlatform.iOS, false);
//    expect(admobInfoIOS.bannerAdId(), 'ca-app-pub-3940256099942544/2934735716');
  });
}
