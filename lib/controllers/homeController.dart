import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:background_downloader/background_downloader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reelsviddownloader/controllers/adController.dart';
import 'package:reelsviddownloader/models/SavedVideos.dart';
import 'package:reelsviddownloader/screens/base/secondary/videoPlayPage.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/colorconstants.dart';
import '../constants/fontconstants.dart';
import '../constants/teststrings.dart';
import '../dbhelpers/DownloadedVidDBHelper.dart';
import '../dbhelpers/SavedVideosDBHelper.dart';
import '../models/Downloaded_Video_Model.dart';
import '../models/parseModels.dart';
import '../screens/downloadwidgets/error_box.dart';
import '../screens/downloadwidgets/fetchingdownloadinfo.dart';
import '../screens/sharablewidgets/downloadinstruction1.dart';
import '../screens/sharablewidgets/rateus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
final AdController adController =
Get.put(AdController());
class HomeController extends GetxController {
  final dbHelper = SavedVideosDatabaseHelper();
  TextEditingController linkfieldcontroller = TextEditingController();
  int showdownload = 0;
  List<DownloadedVideo> tasklist = [];
  int count = 0;
  String clipboarddata = '';
  String? extractedlink = '';
  DownloadedVidDatabaseHelper downloadedVidDatabaseHelper =
      DownloadedVidDatabaseHelper();
  ApiResponse? receivedResponse;
  Media? receivedMedia;
  bool isLoading = false;
  String lastdownloadedurl = "";
  int downloadtaps=0;
  int openVideotaps=0;
  //the following are parsing controls
  bool isLinkValid = false;
  bool errorThrown = false;
  int downloadProgress = 0;
  late TargetPlatform? platform;
  String? localPath = '';

  void incrementDownloadtaps(){
    downloadtaps++;
    int downtaplimit=adController.downtapfrequency;
    if(downloadtaps % downtaplimit == 0){
      adController.showInterstitialAd();
    }
    update();

  }
  void incrementopenVideotaps(){
    openVideotaps++;
    int playtaplimit=adController.playtapfrequency;

    if(openVideotaps % playtaplimit == 0){
      adController.showInterstitialAd();
    }update();
  }
  void saveVideo(SavedVideos savedVideo)async{
    await dbHelper.insertVideo(savedVideo);
    update();
  }
  void deleteVideo(String url)async{
    await dbHelper.deleteVideo(url);
    update();
  }
  
  void setlastdownload(String url) {
    lastdownloadedurl = url;
    update();
  }

  //the following includes the functional code for parsing control
  void setdownloadProgress(int progress) {
    print("Setting progress $progress");
    downloadProgress = progress;
    update();
  }

  void resetDownloadingProgress() {
    downloadProgress = 0;
    update();
  }

  void setlinkvalidastrue() {
    isLinkValid = true;
    update();
  }

  void setloadingtrue() {
    isLoading = true;
    update();
  }

  void setloadingfalse() {
    isLoading = false;
    update();
  }

  void seterrorthrowntrue() {
    errorThrown = true;
    update();
  }

  void seterrorthrownfalse() {
    errorThrown = false;
    update();
  }

  void setlinkvalidasfalse() {
    isLinkValid = false;
    update();
  }

  void parseResponsetoOutput(String responsebody) {
    // String finalpurestring = sampleResponsefromreels.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    String finalpurestring =
        responsebody.replaceAll(RegExp(r'[\x00-\x1F]'), '');
    Map<String, dynamic> parsedJson = json.decode(finalpurestring);
    ApiResponse response = ApiResponse.fromJson(parsedJson);
    print("Post Type: ${response.postType}");
    receivedResponse = response;
    for (var media in response.media) {
      receivedMedia = media;
      setloadingfalse();
      print("Media Type: ${media.mediaType}");
      print("Thumbnail: ${media.thumbnail}");
      print("URL: ${media.url}");
      print(
          "Dimension - Height: ${media.dimension.height}, Width: ${media.dimension.width}");
    }
    update();
  }

  //download functions
  void testdownload(String downloadurl) async {
    String forcedurl =
        "https://instagram.fppg1-1.fna.fbcdn.net/v/t66.30100-16/53905490_847286777011273_1522532917070693776_n.mp4?_nc_ht=instagram.fppg1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=baAHlPPFljkAX8dpuz_&edm=APfKNqwBAAAA&ccb=7-5&oh=00_AfBBlvtum7R88yAwNvCC-qjocoa-0x0jRoBO4QCRDOlrHg&oe=64D38788&_nc_sid=721f0c";
    bool permissionReady = await _checkPermission();
    if (permissionReady) {
      await _prepareSaveDir();
      //  await _prepareSaveDir();
      print("Downloading");

      try {
        /*FileDownloader.downloadFile(
            //url: receivedMedia!.url.trim(),
            url: forcedurl,
            name: "Neu file test",
            onProgress: ( fileName, progress) {
              print('FILE $fileName HAS PROGRESS $progress');
            },
            onDownloadCompleted: (String path) {
              print('FILE DOWNLOADED TO PATH: $path');
            },
            onDownloadError: (String error) {
              print('DOWNLOAD ERROR: $error');
            });
        FileDownloader.setLogEnabled(true);*/
        downloadtestvideo(downloadurl);

        //     print("Download Completed.");
      } catch (e) {
        print("Download Failed.\n\n" + e.toString());
      }
    }
  }

  Future<void> downloadVideo(String videoUrl) async {
    Dio dio = Dio();

    try {
      // Define the download path
      String savePath = (await getExternalStorageDirectory())!.path;
      String videoName = videoUrl.split('/').last;
      String filePath = '$savePath/$videoName';

      // Download the video
      await dio.download(videoUrl, filePath);
      print('Video downloaded to: $filePath');
    } catch (error) {
      print('Error downloading video: $error');
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Widget videopage(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
        margin: EdgeInsets.only(
            top: screenwidth * 0.05720, bottom: screenwidth * 0.0709),
        width: screenwidth * 0.837,
        height: screenwidth * 0.841,
        decoration: BoxDecoration(
          //  color: Color(0xffFAFAFA).withOpacity(0.52),
          borderRadius: BorderRadius.all(Radius.circular(11)),
          //  border: Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(11)),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  child: CachedNetworkImage(
                    imageUrl: receivedMedia!.thumbnail,
                    fit: BoxFit.cover,
                    width: screenwidth * 0.837,
                    height: screenwidth * 0.841,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      width: screenwidth * 0.441,
                      height: screenwidth * 0.639,
                      decoration: BoxDecoration(color: Colors.white),
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
                  receivedMedia!.thumbnail,
                  fit: BoxFit.cover,
                  width: screenwidth * 0.837,
                  height: screenwidth * 0.841,
                ),*/
                  ),
            ),
            Container(
              width: screenwidth * 0.837,
              height: screenwidth * 0.841,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.black],
                    stops: [0.1, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
            Container(
              width: screenwidth * 0.837,
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
                                    VideoPlayPage(url: receivedMedia!.url)));
                      },
                      icon: Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      //        left: 12
                      left: screenwidth * 0.0351,
                      right: screenwidth * 0.0351,
                    ),
                    margin: EdgeInsets.only(
                        //        left: 12
                        bottom: screenwidth * 0.0291),
                    child: Text(
                      receivedResponse!.caption!,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: proximanovaregular,
                          color: Colors.white,
                          //    fontSize: 14.5
                          fontSize: screenwidth * 0.03),
                    ),
                  ),
                //  receivedMedia!.url != lastdownloadedurl ? downloadbutton(context) :
                  downloadProgress > 0 && downloadProgress < 100
                          ? downloadProgressBar(context)
                          : downloadProgress == 0
                              ? downloadbutton(context)
                              : downloadProgress == 100
                                  ? openVideoButton(context)
                                  : downloadbutton(context),
                ],
              ),
            ),
          ],
        ));
  }

  Widget downloadProgressBar(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Container(
     // height: 6,
      width: screenwidth * 0.715,
      margin: EdgeInsets.only(bottom: screenwidth * 0.0634),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                    //        left: 12
                    left: screenwidth * 0.0291),
                child: Text(
                  "Downloading....",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: proximanovaregular,
                      color: Colors.white,
                      //    fontSize: 14.5
                      fontSize: screenwidth * 0.034),
                ),
              ),
              Container(
                child: Text(
                  "$downloadProgress%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: proximanovaregular,
                      color: Colors.white,
                      //    fontSize: 14.5
                      fontSize: screenwidth * 0.034),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: LinearProgressIndicator(
              semanticsLabel: downloadProgress.toString(),
              value: downloadProgress / 100,
              // Convert the progress to a value between 0 and 1
              backgroundColor: Colors.white54,
              valueColor: AlwaysStoppedAnimation<Color>(
                  royalbluethemedcolor), // Change this color as needed
            ),
          )
        ],
      ),
    );
  }

  Widget openVideoButton(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        incrementopenVideotaps();
        incrementplaysfortoday();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoPlayPage(url: receivedMedia!.url)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenwidth * 0.0634),
        width: screenwidth * 0.715,
        height: screenwidth * 0.107,
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
              size: screenwidth * 0.0426,
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
                    fontSize: screenwidth * 0.041),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget downloadbutton(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        incrementDownloadtaps();
        testdownload(receivedMedia!.url);
        setdownloadProgress(1);
        incrementdownloadsfortoday();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenwidth * 0.0634),
        width: screenwidth * 0.715,
        height: screenwidth * 0.107,
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
              size: screenwidth * 0.0426,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(
                  //        left: 12
                  left: screenwidth * 0.0291),
              child: Text(
                "Download",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: Colors.white,
                    //    fontSize: 14.5
                    fontSize: screenwidth * 0.041),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void parsePastedLink({String? urli}) async {
    setdownloadProgress(0);
    final url =
        'https://instagram-saver-download-anything-on-instagram.p.rapidapi.com/igsanitized';
    final headers = {
      'content-type': 'application/x-www-form-urlencoded',
      'X-RapidAPI-Key': '1b6b87d966msh79911a19efb2892p1e4e0fjsn0e980c80dc71',
      'X-RapidAPI-Host':
          'instagram-saver-download-anything-on-instagram.p.rapidapi.com',
    };
    final encodedParams = {'url': urli};
    try {
      print("IN Here");
      final response = await http.post(Uri.parse(url),
          headers: headers, body: encodedParams);
      print(response.body);
      parseResponsetoOutput(response.body);
    } catch (error) {
      seterrorthrowntrue();
      print('Error occurred: $error');
    }
  }

  //the following is the rest of the functional code for parsing control

  emptytextfield(BuildContext context) {
    linkfieldcontroller.clear();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    showdownload = 0;
    update();
  }

  void confirmLinkValidation() {
    if (linkfieldcontroller.text.contains("instagram")) {
      setlinkvalidastrue();
      showdownload = 2;
    } else {
      seterrorthrownfalse();
      setlinkvalidasfalse();
      showdownload = 0;
    }
    update();
  }

  void deletefromdb(int id) async {
    int result = await downloadedVidDatabaseHelper.deleteDownload(id);
    if (result != 0) {
      print("Deleted succesfully");
    } else {
      print("Delete unsuccesful");
    }
  }

  emptyeverything(BuildContext context) {
    extractedlink = "";
    showdownload = 0;
    clipboarddata = '';
    linkfieldcontroller.clear();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    update();
  }

  pastetoclipboard() {
    FlutterClipboard.paste().then((value) {
      // Do what ever you want with the value.
      seterrorthrownfalse();
      linkfieldcontroller.text = value;
      clipboarddata = value;
      String url = value;
      parsePastedLink(urli: url);
      setloadingtrue();
      confirmLinkValidation();
      update();
    });
    //  testigpostdetails();
  }

  Widget homeMainColumn(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        currentActiveSection(context),
        DownloadInstructionOne(),
        RateUs()
      ],
    );
  }

  Widget currentActiveSection(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      /* showdownload == 3?
              ErrorBox():
              showdownload == 1
                  ? FetchingDownloadsInfo()
                  : showdownload ==
                  2
                  ? homepagedownloadvideo(context)

                  :
              */
      /*  receivedMedia != null
          ? videopage(context)
          : SizedBox(
              height: 0,
            ),*/
      errorThrown
          ? ErrorBox()
          : isLinkValid
              ? receivedMedia != null && isLoading == false
                  ? videopage(context)
                  : FetchingDownloadsInfo()
              : nolinkpasted(context),
    ]);
  }

  Widget linkpasterow(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              emptyeverything(context);
              FlutterClipboard.paste().then((value) {
                pastetoclipboard();
              });
            },
            child: Container(
                //  width: 119,
                width: screenwidth * 0.2895,
                padding: EdgeInsets.symmetric(
                    //           vertical: 9),
                    vertical: screenwidth * 0.0218),
                decoration: BoxDecoration(
                    color: royalbluethemedcolor,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ]),
                child: Center(
                  child: Text("Paste Link",
                      style: TextStyle(
                          //        fontSize: 16,
                          fontSize: screenwidth * 0.0389,
                          color: Colors.white,
                          fontFamily: proximanovaregular)),
                ))),
        GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                //      width: 111,
                width: screenwidth * 0.2700,
                margin: EdgeInsets.only(
                    //        left: 60
                    left: screenwidth * 0.1459),
                padding: EdgeInsets.symmetric(
                    //      vertical: 9
                    vertical: screenwidth * 0.0218),
                decoration: BoxDecoration(
                    color:
                        /*  clipboardcontroller.taskss.length==0?
                    royalbluethemedcolor
                        .withOpacity(0.41):
                    clipboardcontroller.taskss[clipboardcontroller.taskss.length-1].name
                        ==clipboardcontroller.currentvideotitle &&
                        clipboardcontroller.taskss[clipboardcontroller.taskss.length-1].status==
                            DownloadTaskStatus.complete?
                    royalbluethemedcolor
                        .withOpacity(0.41):
                    clipboardcontroller.taskss[clipboardcontroller.taskss.length-1].name
                        ==clipboardcontroller.currentvideotitle &&
                        clipboardcontroller.taskss[clipboardcontroller.taskss.length-1].status==
                            DownloadTaskStatus.running?
                    royalbluethemedcolor
                        .withOpacity(0.41):
                        showdownload ==
                        2
                        ? royalbluethemedcolor
                        : */
                        royalbluethemedcolor.withOpacity(0.41),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ]),
                child: Center(
                    child: Text(
                  "Download",
                  style: TextStyle(
                      //      fontSize: 16,
                      fontSize: screenwidth * 0.0389,
                      color: Colors.white,
                      fontFamily: proximanovaregular),
                )))),
      ],
    );
  }

  Widget linktextfield(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          //          top: 29,bottom: 18
          top: screenwidth * 0.07055,
          bottom: screenwidth * 0.0437),
      padding: EdgeInsets.only(
          //        left: 15
          left: screenwidth * 0.0364963),
      //    height: 41,
      height: screenwidth * 0.09975,
      width: screenwidth * 0.906,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(11)),
          border:
              Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 10,
                offset: Offset(0, 3))
          ]),
      child: TextFormField(
        onChanged: (v) {
          confirmLinkValidation();
        },
        controller: linkfieldcontroller,
        cursorColor: Colors.black.withOpacity(0.7),
        style: TextStyle(
            color: Colors.black,
            //      fontSize: 15,
            fontSize: screenwidth * 0.0364963,
            fontFamily: proximanovaregular),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                emptytextfield(context);
                setlinkvalidasfalse();
              },
              child: Icon(
                CupertinoIcons.xmark,
                color: Colors.black87,
                //      size: 17,
                size: screenwidth * 0.04136,
              ),
            ),
            border: InputBorder.none,
            hintText: "Paste Instagram Reels video link here",
            hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.43),
                //   fontSize: 15,
                fontSize: screenwidth * 0.0364963,
                fontFamily: proximanovaregular)),
      ),
    );
  }

  Widget nolinkpasted(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      //    margin: EdgeInsets.only(top: 25,bottom: 31),
      margin: EdgeInsets.only(
          top: screenwidth * 0.05720, bottom: screenwidth * 0.0709),
      width: screenwidth * 0.837,
      decoration: BoxDecoration(
        color: Color(0xffFAFAFA).withOpacity(0.52),
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff707070).withOpacity(0.2), width: 1),
      ),
      padding: EdgeInsets.all(
//          14
          screenwidth * 0.0340),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Copy link from a Instagram Reels Video\n& start downloading",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: blackthemedcolor,
                  //    fontSize: 16
                  fontSize: screenwidth * 0.0366),
            ),
          ),
          Container(
            child: Image.asset(
              "assets/images/Saly-1@3x.png",
              width: screenwidth * 0.49427,
            ),
          ),
        ],
      ),
    );
  }

  void checkPermissionandDownload() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      print("Permissionn is denied");
    } else {
      await Permission.storage.request();
    }
  }

  Future<void> _prepareSaveDir() async {
    localPath = (await _findLocalPath());

    final savedDir = Directory(localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void downloadtestvideo(String url) async {
    String videoUrl = url;
    String forcedurl =
        "https://z-p4-instagram.fsgn5-12.fna.fbcdn.net/v/t66.30100-16/318229749_938006627283968_4480891006851727740_n.mp4?_nc_ht=z-p4-instagram.fsgn5-12.fna.fbcdn.net&_nc_cat=108&_nc_ohc=MngP_LvlbmwAX85qlPG&edm=APfKNqwBAAAA&ccb=7-5&oh=00_AfDuGAHuKPPribFmiOU-tyjutyHtOsZ1XDA-Aip3Vk7lNQ&oe=64D8FEDE&_nc_sid=721f0c";
    String caption =
        "Save THIS\u2705\ud83d\udccc\n\nThese are my all time favorite cookies. \n\nNot only do they taste amazing, one cookie packs a punch filling you up nicely.\n\nI must warn you it tastes bland first time around given that there\u2019s no sugar added (except honey). \n\nYou\u2019re more than welcome to play with honey serving, as well as other natural sweeteners like Stevia. \n\nFull instructions & recipe below:\n\n-You will need: \n\n8 eggs\n1 cup of oats\n7 heaping tablespoons of peanut butter\nTeaspoon of honey\nTeaspoon of vanilla extract\n5 scoops of protein of your choice (I use Isopure vanilla flavored)\n1 banana\n2 scoops of Casein Protein of your choice (I use Optimum Nutrition)\n\n-Preheat oven to 425 degrees Fahrenheit. \n\nWhen placing cookies on baking tray:\nOne tablespoon = 1 cookie.\n\nPlace cookies into the baking tray. Make sure to spray the baking sheet with non-stick cooking oil spray!\n\nSet timer for 9 minutes. \n\nAnd voila! \n\nTotal cookies: 22\n\nOverall Macros:\nFat: 159g\nCarbs: 98g\nProtein: 257g\n\nMacros per cookie: \nProtein: 12g\nFat: 7g\nCarbs: 4g\n\n*I recommend storing them in a fridge.\n\nFollow @rishandfit for more fitness content\ud83e\uddbe\n\n\u2022\n\u2022\n\u2022\n\n#fyp #fyp\u30b7 #foru #explore #fitness #gym #gymaddict #healthylifestyle #proteinrecipes #healthyliving #bodypositivity #fit #fitfam #fitnessaddict #fitnessjourney #fitnessmotivation #reels #explorepage";
    String finalpurestring = caption.replaceAll(RegExp(r'[\x00-\x1F]'), '');

    if (finalpurestring.length > 14) {
      finalpurestring = finalpurestring.substring(0, 14);
    } else {
      finalpurestring = finalpurestring;
    }
    update();

    final Directory? externalDir = await getExternalStorageDirectory();
    String externalStoragePath = externalDir!.path + '/' + finalpurestring;
    String randomUniqueString = generateRandomString(4);
    String filename = randomUniqueString;
    String reccaption = receivedResponse!.caption;
    if (reccaption.length > 25) {
      filename = "${reccaption.substring(0, 24)}$randomUniqueString.mp4";
    } else {
      filename = "$reccaption$randomUniqueString.mp4";
    }

    final task = DownloadTask(
        url: videoUrl,
        // urlQueryParameters: {'q': 'pizza'},
//        filename: "finalpurestring.mp4",
        filename: filename,
        headers: {"auth": "test_for_sql_encoding"},
        directory: "DownloadedVideos",
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        // request status and progress updates
        requiresWiFi: true,
        retries: 5,
        allowPause: true,
        metaData: 'data for me');

// Start download, and wait for result. Show progress and status changes
// while downloading
    final result = await FileDownloader().download(task,
        onProgress: (progress) {
          /* print("COnverted int progress is $intprogress");
          print('Progress: ${progress * 100}%');*/
          int intprogress = (progress * 100).toInt();
          if(intprogress>0){
            setdownloadProgress(intprogress);
          }
        },
        onStatus: (status) => print('Status: $status'));
// Act on the result
    switch (result) {
      case TaskStatus.complete:
        print('Success!');

      case TaskStatus.canceled:
        print('Download was canceled');

      case TaskStatus.paused:
        print('Download was paused');

      default:
        print("URL received here is: $videoUrl");
        print("URL set on top is: ${receivedMedia!.url}");
        setlastdownload(videoUrl);
        final newFilepath = await FileDownloader()
            .moveToSharedStorage(task, SharedStorage.files);
        // await FileDownloader().moveToSharedStorage(task, SharedStorage.video);
        final externalFilePath = await FileDownloader()
            .moveToSharedStorage(task, SharedStorage.external);
        final videoFilePath = await FileDownloader()
            .moveToSharedStorage(task, SharedStorage.external);
        if (newFilepath == null) {
          // handle error
          print("Error with new file path");
        } else {
          SavedVideos savedVidmodel= SavedVideos(caption: receivedResponse!.caption,
              postType: receivedResponse!.postType, height: receivedMedia!.dimension.height,
              width: receivedMedia!.dimension.width, mediaType: receivedMedia!.mediaType,
              thumbnail: receivedMedia!.thumbnail, url: url, fileLocationPath: newFilepath);
          saveVideo(savedVidmodel);
          moveFileToGallery(newFilepath);
          print("Files file path found and it is $newFilepath");
          print("External file path found and it is $externalFilePath");
          print("Video file path found and it is $videoFilePath");

          // do something with the newFilePath
        }
        // final downloadedTasks= await FileDownloader().openFile(task: task);
        print('Download not successful');
    }
  }
  void incrementdownloadsfortoday() async {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection('NeuDownloads');
    /*var doc = await collectionRef
        .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
        .get();

    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection("NeuDownloads")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .update({"numberofdownloads": FieldValue.increment(1)});
    } else {
      await FirebaseFirestore.instance
          .collection("NeuDownloads")
          .doc(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .set({"numberofdownloads": 1});
    }*/
    await collectionRef.doc(DateFormat.yMMMMd('en_US').format(DateTime.now())).
    set({
      "numberofdownloads": FieldValue.increment(1)
    },SetOptions(merge: true));
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
  String generateRandomString(int length) {
    final random = Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String result = '';

    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    return result;
  }
  Future<void> moveFileToGallery(String filepath) async {
    final file = File(filepath); // Replace with your file path
    final galleryDirectory = await getExternalStorageDirectory();
    final newFilePath = '${galleryDirectory!.path}/DCIM/${file.path.split('/').last}';

    await file.copy(newFilePath);
  }
  void printalltasks() async {}
}
