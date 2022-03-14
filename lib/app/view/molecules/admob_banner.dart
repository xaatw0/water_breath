import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBanner extends StatelessWidget {
  AdmobBanner(this.bannerAd, {Key? key}) : super(key: key);
  final BannerAd bannerAd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: AdSize.banner.height.toDouble(),
      width: AdSize.banner.width.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }
}
