import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;
import 'package:intl/intl.dart';
import 'package:reelsviddownloader/controllers/homeController.dart';

import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';

class CurrentDownloadInfo extends StatelessWidget {
  final String? thumbnailimagelink;
  final String? videotitle;
  final String? channelimage;
  final String? channeltitle;
  final String? channeldescription;
  final String? extracteddownloadlink;
  final HomeController homeController =
  GetX.Get.put(HomeController());
  CurrentDownloadInfo({@required this.thumbnailimagelink,@required this.videotitle
    ,@required this.channelimage,@required this.channeltitle,@required this.channeldescription,
  @required this.extracteddownloadlink});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          top: screenWidth * 0.05720, bottom: screenWidth * 0.0709),
      padding: EdgeInsets.all(
//    15
          screenWidth * 0.03649),
      width: screenWidth * 0.915,
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(11)),
          border:
              Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  child: Container(
                    //    height: 67,width: 67,
                    height: screenWidth * 0.1630, width: screenWidth * 0.1630,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        color: royalbluethemedcolor),
                    child: CachedNetworkImage(
                      imageUrl: thumbnailimagelink!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                      //          left: 14
                      left: screenWidth * 0.034063),
                  //   height: 67,
                  height: screenWidth * 0.1630,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          videotitle!,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: proximanovaregular,
                              color: blackthemedcolor,
                              //    fontSize: 14.5
                              fontSize: screenWidth * 0.03527),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "5.2M views.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: proximanovaregular,
                                  color: greythemedcolor,
                                  //    fontSize: 12.5
                                  fontSize: screenWidth * 0.03041),
                            ),
                          ),
                          Container(
                            child: Text(
                              "01:45",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: proximanovaregular,
                                  color: greythemedcolor,
                                  //    fontSize: 12.5
                                  fontSize: screenWidth * 0.03041),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),

          //channelinfo
          Container(
            margin: EdgeInsets.only(
//     top:12
                top: screenWidth * 0.0391),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    //    height: 45,width: 45,
                    height: screenWidth * 0.1094, width: screenWidth * 0.1094,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greythemedcolor,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: channelimage!,
                    fit: BoxFit.cover,),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        //       left: 12
                        left: screenWidth * 0.0291),
                    //    height: 45,
                    height: screenWidth * 0.1094,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                           channeltitle!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: proximanovabold,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenWidth * 0.0352),
                          ),
                        ),
                        Container(
                          child: Text(
                            channeldescription!,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: proximanovaregular,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenWidth * 0.0352),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          //quality options
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  downloadbutton(context,

                      extracteddownloadlink!,videotitle!)
         //         qualitybox(context, '360p'),
           //       qualitybox(context, '720p')
                ],
              ))
        ],
      ),
    );
  }
  reflectdownloads() async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('Downloads');
    var doc = await collectionRef.doc(DateFormat.yMMMMd('en_US').format(DateTime.now())).get();
    if(doc.exists){
      await FirebaseFirestore.instance.collection("Downloads").doc(
          DateFormat.yMMMMd('en_US').format(DateTime.now())
      ).update({"numberofdownloads":FieldValue.increment(1)});
    }else{
      await FirebaseFirestore.instance.collection("Downloads").doc(
          DateFormat.yMMMMd('en_US').format(DateTime.now())
      ).set({"numberofdownloads":1});
    }
  }
  Widget downloadbutton(BuildContext context,
      String downloadlink, String title){
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ()async{
    //    homeController.prepare(downloadlink, title);
        reflectdownloads();
      },
      child: Container(
        //      height: 30,
  //    height: screenWidth * 0.0729,
      //  width: screenWidth * 0.3849,
        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 13.5),
        decoration: BoxDecoration(
            color: royalbluethemedcolor,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xff0062FF).withOpacity(0.28),
                  blurRadius: 10,
                  offset: Offset(0, 3)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.download,
              //      size: 20,
              size: screenWidth * 0.0466,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                "Download",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: Colors.white,
                    //    fontSize: 14.5
                    fontSize: screenWidth * 0.0352),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget qualitybox(BuildContext context, String quality) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //      height: 30,
      height: screenWidth * 0.0729,
      width: screenWidth * 0.3849,
      decoration: BoxDecoration(
          color: royalbluethemedcolor,
          borderRadius: BorderRadius.all(Radius.circular(7)),
          boxShadow: [
            BoxShadow(
                color: Color(0xff0062FF).withOpacity(0.28),
                blurRadius: 10,
                offset: Offset(0, 3)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            FeatherIcons.download,
            //      size: 20,
            size: screenWidth * 0.0466,
            color: Colors.white,
          ),
          Container(
            child: Text(
              quality,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: Colors.white,
                  //    fontSize: 14.5
                  fontSize: screenWidth * 0.0352),
            ),
          ),
          Container(
            child: Text(
              "Download",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: Colors.white,
                  //    fontSize: 14.5
                  fontSize: screenWidth * 0.0352),
            ),
          ),
        ],
      ),
    );
  }
}
