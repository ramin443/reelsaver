import 'package:flutter/material.dart';
import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
class FetchingDownloadsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    double screenWidth=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth*0.05720,bottom: screenWidth*0.0709),
    //  height: 153,
      height: screenWidth*0.3649,
      width: screenWidth*0.915,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.all(color: Color(0xff707070).withOpacity(0.2),width: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(
        //        20
          screenWidth*0.0457  ),
            margin: EdgeInsets.only(
         //       bottom: 16
           bottom: screenWidth*0.0366
            ),
            child: Text("Link Detected. Please wait",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: proximanovaregular,
                  color: blackthemedcolor,
                  //    fontSize: 16
                  fontSize: screenWidth*0.0366
              ),),
          ),
          Container(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: royalbluethemedcolor,
            ),
          )
        ],
      ),
    );
  }
}
