import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reelsviddownloader/controllers/baseController.dart';

import '../constants/colorconstants.dart';
import '../constants/fontconstants.dart';
import '../dbhelpers/SavedVideosDBHelper.dart';
import '../models/SavedVideos.dart';
import '../screens/base/secondary/offlinePlayPage.dart';
import '../screens/base/secondary/videoPlayPage.dart';
import '../screens/sharablewidgets/deletevideo.dart';
import 'adController.dart';
final BaseController baseController =
Get.put(BaseController());
final AdController adController =
Get.put(AdController());
class SavedVideosController extends GetxController {
  final dbHelper = SavedVideosDatabaseHelper();
  int downloadslength=0;
  int openVideotaps=0;

  SavedVideos savedvideoModel = SavedVideos(
     // id: 1,
      caption: "Wir sind hier \n WIr haben biuer dabei",
      postType: "Video",
      height: 1920,
      width: 1080,
      mediaType: "Video",
      thumbnail:
          "https://instagram.fuln1-2.fna.fbcdn.net/v/t51.2885-15/362994873_624131689822280_8215974899179446900_n.jpg?stp=dst-jpg_e15&_nc_ht=instagram.fuln1-2.fna.fbcdn.net&_nc_cat=108&_nc_ohc=O3vzyePplhAAX8_DJ6R&edm=APfKNqwBAAAA&ccb=7-5&oh=00_AfBITJo-grKa3G7hEo6Te1uh4LNUnTe1Ad0YZdccOFH5Gg&oe=64DC3169&_nc_sid=721f0c",
      url:
          "https://instagram.fstx1-1.fna.fbcdn.net/v/t66.30100-16/10000000_963912298198741_5067272402829562511_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjEwODAuY2xpcHMuYmFzZWxpbmUiLCJxZV9ncm91cHMiOiJbXCJpZ193ZWJfZGVsaXZlcnlfdnRzX290ZlwiXSJ9&_nc_ht=instagram.fstx1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=IYcWoqiUOXMAX8EqR7H&edm=APfKNqwBAAAA&vs=245445934991324_3902522883&_nc_vs=HBksFQAYJEdJQ1dtQURWOWlCU3JHd0RBSS1TeXg1bmtWSkdicFIxQUFBRhUAAsgBABUAGCRHSGtBc1FMZ2FPSW44TUVEQUhoWkZxTVZTWlFoYnBSMUFBQUYVAgLIAQAoABgAGwAVAAAmjP2c%2B5rP3z8VAigCQzMsF0A6qn752yLRGBZkYXNoX2Jhc2VsaW5lXzEwODBwX3YxEQB1%2FgcA&_nc_rid=64540c153d&ccb=7-5&oh=00_AfDZD47C1MuR1WNPHXWKn1IJXpr7oz-jyrxVrgVpKkmTAQ&oe=64DA55E6&_nc_sid=721f0c",
      fileLocationPath: "fileLocationPath");

  void setdownloadslength(int count){
    downloadslength=count;
    update();
  }
  void incrementopenVideotaps(){
    openVideotaps++;
    int downtaplimit=adController.downtapfrequency;
    if(openVideotaps % downtaplimit == 0){
      adController.showInterstitialAd();
    }update();
  }
  Widget savedvideoslist(BuildContext context) {
    return FutureBuilder<List<SavedVideos>>(
      future: dbHelper.getAllVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final videos = snapshot.data!;
          setdownloadslength(videos.length);
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video.caption!),
                subtitle: Text(video.url!),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      royalbluethemedcolor),
                  backgroundColor: Colors.black12,

              ),
            ],
          );
        }
      },
    );
  }
  void incrementdownloadsfortoday() async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('NeuDownloads');
   /* var doc = await collectionRef
        .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
        .get();
    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection("Downloads")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .update({"numberofdownloads": FieldValue.increment(1)});
    } else {
      await FirebaseFirestore.instance
          .collection("Downloads")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .set({"numberofdownloads": 1});
    }*/
    await collectionRef.doc(DateFormat.yMMMMd('en_US').format(DateTime.now())).
    set({
      "numberofdownloads": FieldValue.increment(1)
    },SetOptions(merge: true));
  }
  void setreceivedlength()async{
    int recordCount = await dbHelper.getRecordCount();
    downloadslength=recordCount;
    update();
  }
  Widget databasesavedVidGrid(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return FutureBuilder<List<SavedVideos>>(
      future: dbHelper.getAllVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final videos = snapshot.data!;
          return videos.isEmpty?
              emptydownloads(context):
          Container(
              width: screenwidth,
//              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
//      horizontal: 21
                  horizontal: screenwidth * 0.04109),  child:  GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  mainAxisSpacing: screenwidth * 0.028, // Spacing between rows
                  mainAxisExtent: screenwidth * 0.619, // Spacing between columns
                ),
                itemCount: videos.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return indivSavedVideo(context, video);
                }));
           /* ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video.caption!),
                subtitle: Text(video.url!),
              );
            },
          );*/
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      royalbluethemedcolor),
                  backgroundColor: Colors.black12,


              ),
            ],
          );
        }
      },
    );
  }

  Widget gridViewSavedVideos(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
        width: screenwidth,
      padding: EdgeInsets.symmetric(
//      horizontal: 21
          horizontal: screenwidth * 0.04109),
     //   alignment: Alignment.center,
        child: GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              mainAxisSpacing: screenwidth * 0.028, // Spacing between rows
              mainAxisExtent: screenwidth * 0.619, // Spacing between columns
            ),
            itemCount: 4,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
//              return individualSavedVideo(context, savedvideoModel, index);
              return indivSavedVideo(context, savedvideoModel);
            }),
      );
  }
  Widget indivSavedVideo(BuildContext context, SavedVideos savedVideo){
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenwidth * 0.441,
      height: screenwidth * 0.639,
      decoration: BoxDecoration(
        //  color: Color(0xffFAFAFA).withOpacity(0.52),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        //  border: Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
      ),
      child: Stack(
        children: [
          Container(
            width: screenwidth * 0.441,
            height: screenwidth * 0.639,
            decoration: BoxDecoration(
              //  color: Color(0xffFAFAFA).withOpacity(0.52),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              //  border: Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child:  CachedNetworkImage(
                imageUrl: savedVideo.thumbnail!,
                fit: BoxFit.cover,
                width: screenwidth * 0.441,
                //    height: screenwidth * 0.639,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    Container(
                      width: screenwidth * 0.441,
                      height: screenwidth * 0.639,
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  royalbluethemedcolor),
                              backgroundColor: Colors.black12,
                              value: downloadProgress.progress),
                        ],
                      ),
                    ),

                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Container(
            width: screenwidth * 0.441,
            height: screenwidth * 0.639,
        //    padding: EdgeInsets.only(top: 6,bottom: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [Colors.black12, Colors.black],
                  stops: [0.1, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      showDialog(
                          context: context,
                          builder: (_) => SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(16)),
                              ),
                              children: [
                                DeleteVideo(
                                    newUrl: savedVideo.url
                                ),
                              ]));
                    }, icon: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: lightredthemedColor,
                      size: screenwidth*0.048,
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          incrementopenVideotaps();
                          incrementplaysfortoday();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OfflinePlayPage(filepath: savedVideo.fileLocationPath)));
                        },
                        icon: Icon(
                          CupertinoIcons.play_fill,
                          color: Colors.white,
                          size: screenwidth * 0.0769,
                        ),
                      ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        //        left: 12
                        left: screenwidth * 0.0251,
                        right: screenwidth * 0.0251,
                      ),
                      margin: EdgeInsets.only(
                        //        left: 12
                          bottom: screenwidth * 0.0291),
                      child: Text(
                        savedVideo.caption!,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: proximanovaregular,
                            color: Colors.white,
                            //    fontSize: 14.5
                            fontSize: screenwidth * 0.032),
                      ),
                    ),
                    openVideoButton(context, savedVideo.fileLocationPath!)
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
  Widget individualSavedVideo(
      BuildContext context, SavedVideos savedVideo, int index) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    double screenheight = MediaQuery.sizeOf(context).height;
    return Container(
        margin: EdgeInsets.only(left: index.isEven ? screenwidth * 0.03720 : 0.028),
        width: screenwidth * 0.441,
        height: screenwidth * 0.639,
        decoration: BoxDecoration(
          //  color: Color(0xffFAFAFA).withOpacity(0.52),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          //  border: Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                    imageUrl: savedVideo.thumbnail!,
                    fit: BoxFit.cover,
                    width: screenwidth * 0.441,
                //    height: screenwidth * 0.639,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        Container(
                          width: screenwidth * 0.441,
                          height: screenwidth * 0.639,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          royalbluethemedcolor),
                                        backgroundColor: Colors.black12,
                                        value: downloadProgress.progress),
                                  ],
                                ),
                              ),

                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                  /*Image.network(
                  savedVideo.thumbnail,
                  fit: BoxFit.cover,
                  width: screenwidth * 0.441,
                  height: screenwidth * 0.639,
                ),*/
                  ),
            ),
            Container(
              width: screenwidth * 0.441,
              height: screenwidth * 0.639,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.black],
                    stops: [0.1, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
            Container(
              width: screenwidth * 0.441,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        incrementplaysfortoday();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayPage(url: savedVideo.url)));
                      },
                      icon: Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: screenwidth * 0.0769,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            //        left: 12
                            left: screenwidth * 0.0251,
                            right: screenwidth * 0.0251,
                          ),
                          margin: EdgeInsets.only(
                              //        left: 12
                              bottom: screenwidth * 0.0291),
                          child: Text(
                            savedVideo.caption!,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: proximanovaregular,
                                color: Colors.white,
                                //    fontSize: 14.5
                                fontSize: screenwidth * 0.032),
                          ),
                        ),
                      ),
                    ],
                  ),
                  openVideoButton(context, savedVideo.url!),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(16)),
                            ),
                            children: [
                              DeleteVideo(
                                  newUrl: savedVideo.url
                                ),
                            ]));
                  }, icon: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: redthemedcolor,
                    size: screenwidth*0.048,
                  ))
                ],
              ),
            )
          ],
        ));
  }
  void incrementplaysfortoday() async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('Plays');
    /*var doc = await collectionRef
        .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
        .get();
    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection("Plays")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .update({"numberofplays": FieldValue.increment(1)});
    } else {
      await FirebaseFirestore.instance
          .collection("Plays")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .set({"numberofplays": 1});
    }*/
    await collectionRef.doc(DateFormat.yMMMMd('en_US').format(DateTime.now())).
    set({
      "numberofplays": FieldValue.increment(1)
    },SetOptions(merge: true));
  }
  void deleteVideo(String url )async{
    await dbHelper.deleteVideo(url);
    update();
  }

  Widget openVideoButton(BuildContext context, String filepath) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        incrementopenVideotaps();
        incrementplaysfortoday();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  OfflinePlayPage(filepath: filepath)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenwidth * 0.0334),
        width: screenwidth * 0.407,
        height: screenwidth * 0.0895,
        decoration: BoxDecoration(
          color: royalbluethemedcolor,
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.download,
              //      size: 20,
              size: screenwidth * 0.0326,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(
                  //        left: 12
                  left: screenwidth * 0.0291),
              child: Text(
                "Open Video",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: Colors.white,
                    //    fontSize: 14.5
                    fontSize: screenwidth * 0.035),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget emptydownloads(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenheight*0.7,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/nodownloads.svg",
              width: screenwidth * 0.669,
            ),
            Container(
              child: Text(
                "No downloads yet",
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: blackthemedcolor,
                    fontSize: screenwidth * 0.05109),
              ),
            ),
            Container(
              child: Text(
                "Copy and paste link to see download options",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: greythemedcolor,
                    //      fontSize: 12.5
                    fontSize: screenwidth * 0.03041),
              ),
            ),
            GestureDetector(
                onTap: () {
                  baseController.setindex(0);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    //          top: 21
                      top: screenwidth * 0.05109),
                  padding: EdgeInsets.symmetric(
//           vertical: 6,horizontal: 14
                      vertical: screenwidth * 0.0145,
                      horizontal: screenwidth * 0.03406),
                  decoration: BoxDecoration(
                    color: royalbluethemedcolor,
                    borderRadius: BorderRadius.all(Radius.circular(31)),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        fontFamily: proximanovaregular,
                        color: Colors.white,
                        //        fontSize: 15.5
                        fontSize: screenwidth * 0.0377),
                  ),
                ))
          ]),
    );
  }
  Widget topdownloadrow(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
//      top: 22
          bottom: screenwidth * 0.0462),
      padding: EdgeInsets.symmetric(
//      horizontal: 21
          horizontal: screenwidth * 0.05109),
      width: screenwidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              "All Downloads",
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: blackthemedcolor,
                  //   fontSize: 19
                  fontSize: screenwidth * 0.0462),
            ),
          ),
          Container(
            child: Text(
             "$downloadslength files" ,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: blackthemedcolor,
                  //   fontSize: 14
                  fontSize: screenwidth * 0.0340),
            ),
          ),
        ],
      ),
    );
  }
}
