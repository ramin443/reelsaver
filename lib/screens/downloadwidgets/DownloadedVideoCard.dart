import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
import '../../models/Downloaded_Video_Model.dart';
import '../sharablewidgets/deletevideo.dart';

class DownloadedVideoCard extends StatelessWidget {
  final DownloadedVideo? downloadedvideo;
  final int? index;
  DownloadedVideoCard({@required this.downloadedvideo,@required this.index});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          top: screenWidth * 0.05720, ),
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(11)),
          border:
              Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1)),
      width: screenWidth * 0.915,
      padding: EdgeInsets.all(
          //      16
          screenWidth * 0.0389),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Container(
                  //       height: 67, width: 67,
                  height: screenWidth * 0.1630, width: screenWidth * 0.1630,
                  decoration: BoxDecoration(
                    color: royalbluethemedcolor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: downloadedvideo!.videothumbnailurl.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: screenWidth * 0.1630,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: screenWidth * 0.63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  //          right: 5
                                  right: screenWidth * 0.01216),
                              width: screenWidth * 0.46,
                              child: Text(
                                downloadedvideo!.videotitle.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: blackthemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                          children: [DeleteVideo(
                                            index: index,
                                            taskid: downloadedvideo!.taskid.toString(),

                                          )]));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
//                              vertical: 5,horizontal: 12
                                      vertical: screenWidth * 0.01216,
                                      horizontal: screenWidth * 0.02919),
                                  decoration: BoxDecoration(
                                      color: redthemedcolor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xffFF0000)
                                                .withOpacity(0.48),
                                            blurRadius: 10,
                                            offset: Offset(0, 3))
                                      ]),
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          fontFamily: proximanovaregular,
                                          color: Colors.white,
                                          //           fontSize: 12.5
                                          fontSize: screenWidth * 0.0304),
                                    ),
                                  ),
                                ))
                          ],
                        )),
                    Container(
                        width: screenWidth * 0.63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                "5.2M views",
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: greythemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                            Container(
                              child: Text(
                                "01:45",
                                style: TextStyle(
                                    fontFamily: proximanovaregular,
                                    color: greythemedcolor,
                                    //    fontSize: 14.5
                                    fontSize: screenWidth * 0.03527),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
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
                      imageUrl: downloadedvideo!.channelthumbnailurl.toString(),
                      fit: BoxFit.cover,
                    ),
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
                            downloadedvideo!.channeltitle.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: proximanovabold,
                                color: blackthemedcolor,
                                //    fontSize: 14.5
                                fontSize: screenWidth * 0.0352),
                          ),
                        ),
                        Container(
                          child: Text(
                            downloadedvideo!.channeldescription.toString(),
                            textAlign: TextAlign.center,
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
          Container(
            margin: EdgeInsets.only(
//      top: 16
                top: screenWidth * 0.0389),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                 //   await FlutterDownloader.open(
                   //     taskId: downloadedvideo!.taskid.toString());
                  },
                  child: Container(
//width:108,height:27,
                    width: screenWidth * 0.262, height: screenWidth * 0.0656,
                    decoration: BoxDecoration(
                        color: royalbluethemedcolor,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff0062FF).withOpacity(0.28),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ]),
                    child: Center(
                      child: Text(
                        "Open Video",
                        style: TextStyle(
                            fontFamily: proximanovaregular,
                            color: Colors.white,
                            //      fontSize: 13
                            fontSize: screenWidth * 0.03163),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
