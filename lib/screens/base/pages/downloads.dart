import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/constants/colorconstants.dart';
import 'package:reelsviddownloader/controllers/savedVideosController.dart';
import 'package:reelsviddownloader/controllers/videoplayController.dart';
import 'package:reelsviddownloader/models/SavedVideos.dart';

import '../../../constants/fontconstants.dart';
class Downloads extends StatelessWidget {
   Downloads({Key? key}) : super(key: key);
   final VideoPlayController videoPlayController =
   Get.put(VideoPlayController());
   final SavedVideosController savedVideosController =
   Get.put(SavedVideosController());
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    double screenheight = MediaQuery.sizeOf(context).height; return
      GetBuilder<SavedVideosController>(
        initState: (v){
          savedVideosController.setreceivedlength();
        },
          init: SavedVideosController(),
        builder: (savedvideocontroller){
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: screenwidth,
            padding: EdgeInsets.only(
                bottom: screenwidth * 0.05720
            ),
           // padding: EdgeInsets.only(left: 14,right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenwidth*0.0426,),
                savedvideocontroller.topdownloadrow(context),
               // savedvideocontroller.gridViewSavedVideos(context),
                savedvideocontroller.databasesavedVidGrid(context),
              ],
            ),
          ),
        );
      });

  }
}
