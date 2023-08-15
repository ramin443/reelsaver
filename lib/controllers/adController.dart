import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController{
  BannerAd? bannerAd;
  Widget displayBannerWidget(BuildContext context){
    return bannerAd==null?Container():
    Container(
      height: 52,
    );
  }

}