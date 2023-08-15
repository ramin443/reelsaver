import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reelsviddownloader/constants/adconstants.dart';

class AdController extends GetxController{
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  int rewardedScore=0;
  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad){
      print("Ad Loaded");
    },
    onAdFailedToLoad: (ad,error){
      print("Failed to load because $error");
    },
    onAdOpened: (ad){
      print("Ad opened");
    },
    onAdClosed: (ad){
      print("Ad opened");
    }
  );

  void initializebannerAd()async{
    bannerAd=BannerAd(size: AdSize.fullBanner, adUnitId: banneradunitid,
        listener: bannerAdListener, request: const AdRequest())..load();
  }

  void initializeInterstitialAd()async{
   InterstitialAd.load(adUnitId: interstitialadunitid,
       request: const AdRequest(), adLoadCallback: InterstitialAdLoadCallback(
           onAdLoaded: (ad){
             interstitialAd=ad;
             update();
           }, onAdFailedToLoad: (LoadAdError error){
             interstitialAd=null;
       }));
  }
  void initializeRewardedAd()async{
    RewardedAd.load(
        adUnitId: rewardadunitid,
        request: const AdRequest(),
        rewardedAdLoadCallback:  RewardedAdLoadCallback(
            onAdLoaded: (ad){
              rewardedAd=ad;
              update();
            },
            onAdFailedToLoad: (error){
              rewardedAd=null;
              update();
            }));
  }
  void showInterstitialAd(){
    if(interstitialAd !=null){
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          initializeInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad,error){
          ad.dispose();
          initializeInterstitialAd();
        }
      );
      interstitialAd!.show();
      interstitialAd=null;
      update();
    }else{
      print("Is not initialized");
    }
  }
  void showRewardedAd(){
    if(rewardedAd!=null){
      rewardedAd!.fullScreenContentCallback=FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          initializeRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad,error){
          ad.dispose();
          initializeRewardedAd();
        }
      );
      rewardedAd!.show(onUserEarnedReward: (ad, reward){
        rewardedScore=rewardedScore+int.parse(reward.toString());
        print("New rewarded score is $rewardedScore after adding $reward");
        update();
      });
      rewardedAd=null;
    }
  }
  Widget displayBannerWidget(BuildContext context){
    double screenwidth=MediaQuery.sizeOf(context).width;
    return bannerAd==null?

    SizedBox(
      height: 0,
    ):
    FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.transparent,
      onPressed: (){},
      label: Container(
        height: screenwidth*0.148,
        width: screenwidth,
        margin: EdgeInsets.all(0), // No margin
        child: AdWidget(
          ad: bannerAd!,
        ),
      ),
    );
  }

}