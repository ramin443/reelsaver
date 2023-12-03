import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/controllers/adController.dart';
import 'package:reelsviddownloader/controllers/videoplayController.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/colorconstants.dart';
class OfflinePlayPage extends StatelessWidget {
   OfflinePlayPage({@required this.filepath});

   String? filepath;
   final VideoPlayController videoPlayController =
  Get.put(VideoPlayController());
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    double screenheight = MediaQuery.sizeOf(context).height;
    return
      GetBuilder<AdController>(
        initState: (v){
    },
    init: AdController(),
    builder: (adcontroller){
    return
    GetBuilder<VideoPlayController>(
      initState: (v){
        adcontroller.initializevideobannerAd();
        adcontroller.initializeInterstitialAd();
        videoPlayController.initofflinevidplaycontroller(filepath!);
      },
        init: VideoPlayController(),
        builder: (videoplaycontroller){
      return WillPopScope(
        onWillPop: videoplaycontroller.onOfflineBackPressed
        ,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: screenwidth,
                  height: screenheight,
                  child:

                  videoplaycontroller.offlinevidcontroller.value.isInitialized
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: videoplaycontroller
                            .offlinevidcontroller.value.aspectRatio,
                        child: VideoPlayer(
                            videoplaycontroller.offlinevidcontroller),
                      )
                    ],
                  )
                      : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: royalbluethemedcolor,
                      ),
                    ],
                  ),

                  // Show loading indicator
                ),
              ),

              Container(
                width: screenwidth,
                height: screenheight * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    videoplaycontroller.hideControls?
                    SizedBox(height: 0,):
                    AppBar(
                      backgroundColor: Colors.black12,
                      elevation: 0,
                      //  centerTitle: true,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: screenwidth * 0.06,
                        ),
                      ),
                      //    title: Text('Video Player'),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                width: screenwidth,
                height: screenheight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            bottom: screenwidth*0.04,right: screenwidth*0.04
                        ),
                        child: videoplaycontroller.hideControlsButton(context)),
                    videoplaycontroller.hideControls?
                    SizedBox(
                      height: screenwidth*0.255,
                    ):videoplaycontroller.offlinevideocontrolaction(context),
                    SizedBox(
                      width: screenwidth,
                      height: 0,

                    ),
                    adcontroller.displayBannerWidgetforVidPlayPage(context),

                  ],
                ),
              )
            ],
          ),
        ),
      );
    });});
  }
}
