import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/controllers/savedVideosController.dart';
import 'package:reelsviddownloader/models/SavedVideos.dart';
class Downloads extends StatelessWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    double screenheight = MediaQuery.sizeOf(context).height; return
      GetBuilder<SavedVideosController>(
        initState: (v){},
          init: SavedVideosController(),
        builder: (savedvideocontroller){
        return Container(
          width: screenwidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],
          ),
        );
      });

  }
}
