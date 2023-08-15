import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/constants/colorconstants.dart';
import 'package:reelsviddownloader/controllers/videoplayController.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/adController.dart';

class VideoPlayPage extends StatelessWidget {
  VideoPlayPage({@required this.url});

  String? url;
  final VideoPlayController videoPlayController =
      Get.put(VideoPlayController());

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    double screenheight = MediaQuery.sizeOf(context).height;
    return
      GetBuilder<AdController>(
        init: AdController(),
    initState: (v) {
    //    v.initState();
    },
    builder: (adcontroller) {
    return
    GetBuilder<VideoPlayController>(
        init: VideoPlayController(),
        initState: (v) {
          adcontroller.initializebannerAd();
          adcontroller.initializeInterstitialAd();
          videoPlayController.initvidplaycontroller(url!);
      //    v.initState();
        },
        dispose: (v) {
       //    videoPlayController.pausefunction();
      //  v.dispose();
           },
        builder: (videoplaycontroller) {
          return WillPopScope(
            onWillPop: videoplaycontroller.onBackPressed,
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

                      videoPlayController.vidcontroller.value.isInitialized
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: videoPlayController
                                      .vidcontroller.value.aspectRatio,
                                  child: VideoPlayer(
                                      videoPlayController.vidcontroller),
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
                        ):videoplaycontroller.videocontrolaction(context),
                        SizedBox(
                          width: screenwidth,
                          height: 0,

                        ),
                        adcontroller.displayBannerWidget(context),

                      ],
                    ),
                  )
                ],
              ),
         /*   floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat ,
              bottomNavigationBar: SizedBox(
                width: screenwidth,
                height: screenheight*0.18,

              ),
              floatingActionButton:
                  videoplaycontroller.videocontrolaction(context),*/
              /*FloatingActionButton(
                onPressed: () {
                  if (videoPlayController.vidcontroller.value.isPlaying) {
                    videoPlayController.vidcontroller.pause();
                  } else {
                    videoPlayController.vidcontroller.play();
                  }
                },
                child: Icon(
                  videoPlayController.vidcontroller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),*/
            ),
          );
        });});
  }
}
