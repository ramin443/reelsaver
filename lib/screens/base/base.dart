import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reelsviddownloader/controllers/adController.dart';
import 'package:reelsviddownloader/controllers/baseController.dart';
import 'package:reelsviddownloader/controllers/homeController.dart';
import 'package:reelsviddownloader/screens/base/pages/downloads.dart';
import 'package:reelsviddownloader/screens/base/pages/home.dart';
import 'package:reelsviddownloader/screens/base/pages/settings.dart';

import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
import '../../constants/teststrings.dart';
import '../../models/parseModels.dart';

class Base extends StatelessWidget {
  Base({Key? key}) : super(key: key);
  List pages = [Home(), Downloads(), Settings()];
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<AdController>(
        initState: (v) {},
        init: AdController(),
        builder: (adcontroller) {
          return GetBuilder<BaseController>(
              initState: (v) {
                adcontroller.initializestreams();
                adcontroller.initializebannerAd();
                adcontroller.initializeInterstitialAd();
                adcontroller.initializeRewardedAd();
              },
              init: BaseController(),
              builder: (basecontroller) {
                return Scaffold(

                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: adcontroller.displayBannerWidget(context),
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    centerTitle: false,
                    actions: [
                   /*    IconButton(onPressed: (){
                        homeController.extractShortcode("https://www.instagram.com/p/CvgakunSxqd/?igshid=MzRlODBiNWFlZA==");
                      },
                          icon: Icon(FeatherIcons.cloud,
                            color: Colors.black,
                            size: 20,)),*/
                      /*  IconButton(onPressed: (){
                  homeController.printalltasks();
                },
                    icon: Icon(FeatherIcons.cloud,
                color: Colors.black,
                size: 20,)),
                IconButton(
                    onPressed: () {
//                      homeController.testdownload();



                      //     homeController.parseResponsetoOutput(sampleResponsefromreels);
                     /* Map<String, dynamic> parsedJson = json.decode(sampleResponsefromreels);
                      ApiResponse response = ApiResponse.fromJson(parsedJson);
                      print("Post Type: ${response.postType}");
                      for (var media in response.media) {
                        print("Media Type: ${media.mediaType}");
                        print("Thumbnail: ${media.thumbnail}");
                        print("URL: ${media.url}");
                        print("Dimension - Height: ${media.dimension.height}, Width: ${media.dimension.width}");
                      }*/
                    },
                    icon: Icon(
                      CupertinoIcons.plus_circle_fill,
                      color: Colors.black,
                      size: 24,
                    ))
              */
                    ],
                    leading: Container(
                        margin: EdgeInsets.only(
//                left: 8,top: 8
                          left: screenWidth * 0.01946,
                          top: screenWidth * 0.01946,
                        ),
                        child: SvgPicture.asset(
                          "assets/images/Reels logo SVG.svg",
                          //   height: 42,width: 42,
                          height: screenWidth * 0.1221,
                          width: screenWidth * 0.1221,
                        )),
                    title: Container(
                      margin: EdgeInsets.only(
//                left: 8,top: 8
                        top: screenWidth * 0.01946,
                      ),
                      child: Text(
                        "Reels Video\nDownloader",
                        style: TextStyle(
                            fontFamily: proximanovaregular,
                            color: blackthemedcolor,
                            //        fontSize: 18
                            fontSize: screenWidth * 0.04479),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: basecontroller.currentindex,
                    selectedItemColor: royalbluethemedcolor,
                    unselectedItemColor: greythemedcolor,
                    backgroundColor: Color(0xfff5f5f5),
                    onTap: (index) {
                      basecontroller.setindex(index);
                    },
                    selectedLabelStyle: TextStyle(
                        fontFamily: proximanovaregular,
                        fontSize: screenWidth * 0.03441
                        //    fontSize: 12.5
                        ),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: proximanovaregular,
                        fontSize: screenWidth * 0.03441
                        //    fontSize: 12.5
                        ),
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(
                            FeatherIcons.home,
                            //   size: 24,
                            size: screenWidth * 0.0603,
                          ),
                          label: "Home"),
                      BottomNavigationBarItem(
                        icon: Icon(
                          FeatherIcons.download,
                          //    size: 24,
                          size: screenWidth * 0.0603,
                        ),
                        label: "Downloads",
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(
                            FeatherIcons.settings,
                            //   size: 24,
                            size: screenWidth * 0.0603,
                          ),
                          label: "Settings"),
                    ],
                  ),
                  body: pages[basecontroller.currentindex],
                );
              });
        });
  }
}
