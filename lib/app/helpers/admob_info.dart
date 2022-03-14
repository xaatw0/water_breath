import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdmobInfo {
  String appId();

  String startAdId();

  String bannerAdId();

  BannerAd getBanner() {
    print('getBanner');
    return BannerAd(
      adUnitId: bannerAdId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('ad loaded'),
      ),
    );
  }
}

class AdmobInfoAndroidDemo extends AdmobInfo {
  @override
  String appId() => 'ca-app-pub-2831580726446381~8524127749';

  @override
  String bannerAdId() => 'ca-app-pub-3940256099942544/6300978111';

  @override
  String startAdId() => 'ca-app-pub-3940256099942544/3419835294';
}

class AdmobInfoIOSDemo extends AdmobInfo {
  @override
  String appId() => 'ca-app-pub-2831580726446381~4377871316';

  @override
  String startAdId() => 'ca-app-pub-3940256099942544/5662855259';

  @override
  String bannerAdId() => 'ca-app-pub-3940256099942544/2934735716';
}

class AdmobInfoAndroid extends AdmobInfoAndroidDemo {
  @override
  String startAdId() => 'ca-app-pub-2831580726446381/7718350525';

  @override
  String bannerAdId() => 'ca-app-pub-2831580726446381/4517434129';
}

class AdmobInfoIOS extends AdmobInfoIOSDemo {
  @override
  String startAdId() => 'ca-app-pub-2831580726446381/9241285375';

  @override
  String bannerAdId() => 'ca-app-pub-2831580726446381/8748979712';
}
