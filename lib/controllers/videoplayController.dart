import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/constants/colorconstants.dart';
import 'package:reelsviddownloader/constants/fontconstants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayController extends GetxController{
  late VideoPlayerController vidcontroller;
  late double videoProgress = 0.0;
  double sliderValue = 0.0;
  double position=0;
  bool reachedEnd=false;
  bool hideControls=false;
  late VideoPlayerController offlinevidcontroller;

  void sethideoption(){
    hideControls=!hideControls;
    update();
  }
  void initvidplaycontroller(String url){
    vidcontroller= VideoPlayerController.network(url)
      ..initialize().then((value) {
        update();
    });
    vidcontroller.addListener(() {
      if (vidcontroller.value.isPlaying) {
          videoProgress = vidcontroller.value.position.inMilliseconds.toDouble() /
              vidcontroller.value.duration.inMilliseconds.toDouble();
          update();
        }
      if(vidcontroller.value.position == vidcontroller.value.duration){
        reachedEnd=true;
      }else{
        reachedEnd=false;
      }
      update();
    });
  }
  void initofflinevidplaycontroller(String url){
    offlinevidcontroller= VideoPlayerController.file(File(url))
      ..initialize().then((value) {
        update();
      });
    offlinevidcontroller.addListener(() {
      if (offlinevidcontroller.value.isPlaying) {
        videoProgress = offlinevidcontroller.value.position.inMilliseconds.toDouble() /
            offlinevidcontroller.value.duration.inMilliseconds.toDouble();
        update();
      }
      if(offlinevidcontroller.value.position == offlinevidcontroller.value.duration){
        reachedEnd=true;
      }else{
        reachedEnd=false;
      }
      update();
    });
  }
  void pausefunction(){
    if (vidcontroller.value.isPlaying) {
      vidcontroller.pause();
      update();
    }
  }
  void disposeController() {
    if (vidcontroller.value.isPlaying) {
      vidcontroller.pause();
    }
    update();
  }
  Future<bool> onBackPressed() async {
    // Execute your custom function here
    if (vidcontroller.value.isPlaying) {
      vidcontroller.pause();
      update();
    }    // Return true to allow back navigation
    return true;
  }

  Future<bool> onOfflineBackPressed() async {
    // Execute your custom function here
    if (offlinevidcontroller.value.isPlaying) {
      offlinevidcontroller.dispose();
     // offlinevidcontroller.pause();
      update();
    }    // Return true to allow back navigation
    return true;
  }
  @override
  void onClose() {
    disposeController(); // Dispose the controller when the controller is closed
    super.onClose();
  }
  Widget videocontrolaction(BuildContext context){
    double screenwidth=MediaQuery.sizeOf(context).width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust blur intensity
        child: Container(
          width: screenwidth,
          height: screenwidth*0.255,
          decoration: BoxDecoration(
            color: Colors.black12
          ),child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: LinearProgressIndicator(
                  value: videoProgress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Slider(
                value: sliderValue,
                onChanged: (newValue) {
                    sliderValue = newValue;
                    final newTime = vidcontroller.value.duration * newValue;
                    vidcontroller.seekTo(newTime);
                    update();
                    },
              ),*/
             Container(
               width: screenwidth,
               padding: EdgeInsets.only(left: 12,
               right: 12,top: 16
               ),
               child: ProgressBar(
                 timeLabelTextStyle: TextStyle(
                   fontFamily: proximanovaregular,
                   color: Colors.white,
                   fontSize: 14
                 ),
                      progress: vidcontroller.value.position,
                      total: vidcontroller.value.duration,
                    thumbColor: royalbluethemedcolor,
                    barHeight: 6.0,
                    thumbRadius: 6.0,
                    progressBarColor: royalbluethemedcolor,
                    baseBarColor: Colors.white.withOpacity(0.24),
                    onSeek: (duration) {
                    //  sliderValue = duration.inMilliseconds.toDouble();
                     // final newTime = vidcontroller.value.duration * duration.inMilliseconds.toDouble();
                      vidcontroller.seekTo(duration);
                      update();
                    },
                  ),
             ),

              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){

                  if (vidcontroller.value.isPlaying) {
                    vidcontroller.pause();
                    update();
                  } else {
                    // need a slider

                    vidcontroller.play();
                    update();
                  }
                }, icon: Icon(
                  reachedEnd?
                  CupertinoIcons.gobackward :
                  vidcontroller.value.isPlaying ?
                  CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                  size: screenwidth*0.08,
                  color: Colors.white,
                )),
               /* GestureDetector(
                  onTap: (){
                    if (vidcontroller.value.isPlaying) {
                      vidcontroller.pause();
                      update();
                    } else {
                      // need a slider

                      vidcontroller.play();
                      update();
                    }
                  },
                  child: Container(
                    child: Icon(
                      reachedEnd?
                      CupertinoIcons.gobackward :
                      vidcontroller.value.isPlaying ?
                    CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                    size: screenwidth*0.08,
                      color: Colors.white,
                    ),
                  ),
                )
                */
              ],
        ),
            ],
          ),
        ),
      ),
    );
  }
  Widget offlinevideocontrolaction(BuildContext context){
    double screenwidth=MediaQuery.sizeOf(context).width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust blur intensity
        child: Container(
          width: screenwidth,
          height: screenwidth*0.255,
          decoration: BoxDecoration(
              color: Colors.black12
          ),child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: LinearProgressIndicator(
                  value: videoProgress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Slider(
                value: sliderValue,
                onChanged: (newValue) {
                    sliderValue = newValue;
                    final newTime = vidcontroller.value.duration * newValue;
                    vidcontroller.seekTo(newTime);
                    update();
                    },
              ),*/
            Container(
              width: screenwidth,
              padding: EdgeInsets.only(left: 12,
                  right: 12,top: 16
              ),
              child: ProgressBar(
                timeLabelTextStyle: TextStyle(
                    fontFamily: proximanovaregular,
                    color: Colors.white,
                    fontSize: 14
                ),
                progress: offlinevidcontroller.value.position,
                total: offlinevidcontroller.value.duration,
                thumbColor: royalbluethemedcolor,
                barHeight: 6.0,
                thumbRadius: 6.0,
                progressBarColor: royalbluethemedcolor,
                baseBarColor: Colors.white.withOpacity(0.24),
                onSeek: (duration) {
                  //  sliderValue = duration.inMilliseconds.toDouble();
                  // final newTime = vidcontroller.value.duration * duration.inMilliseconds.toDouble();
                  offlinevidcontroller.seekTo(duration);
                  update();
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){
                  if (offlinevidcontroller.value.isPlaying) {
                    offlinevidcontroller.pause();
                    update();
                  } else {
                    // need a slider

                    offlinevidcontroller.play();
                    update();
                  }
                }, icon: Icon(
                  reachedEnd?
                  CupertinoIcons.gobackward :
                  offlinevidcontroller.value.isPlaying ?
                  CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                  size: screenwidth*0.08,
                  color: Colors.white,
                )),
                /* GestureDetector(
                  onTap: (){
                    if (vidcontroller.value.isPlaying) {
                      vidcontroller.pause();
                      update();
                    } else {
                      // need a slider

                      vidcontroller.play();
                      update();
                    }
                  },
                  child: Container(
                    child: Icon(
                      reachedEnd?
                      CupertinoIcons.gobackward :
                      vidcontroller.value.isPlaying ?
                    CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                    size: screenwidth*0.08,
                      color: Colors.white,
                    ),
                  ),
                )
                */
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
  Widget hideControlsButton(BuildContext context){
    double screenwidth=MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: (){
            sethideoption();
          },
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12,sigmaY: 12),
              child: Container(

                height: screenwidth*0.16,
                width: screenwidth*0.16,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Icon(
                    hideControls?
                    FeatherIcons.eye:FeatherIcons.eyeOff,
                  color: Colors.white,
                  size: screenwidth*0.064,),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}