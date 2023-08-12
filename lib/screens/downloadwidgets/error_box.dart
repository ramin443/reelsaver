import 'package:flutter/material.dart';
import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
class ErrorBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth*0.05720,bottom: screenWidth*0.05720),
      decoration: BoxDecoration(
          color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(11)),
          border: Border.all(color: Color(0xff707070).withOpacity(0.2),width: 1)
      ),
      width: screenWidth * 0.915,
      padding: EdgeInsets.all(
        //      16
          screenWidth*0.0389
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(

              //          right: 5
            ),
            child:
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    fontFamily: proximanovaregular,
                    color: blackthemedcolor,
                    //    fontSize: 14.5
                    fontSize: screenWidth*0.03527
                ),
                children: [
                  TextSpan(
                    text: "Oops! ",style: TextStyle(
                      fontFamily: proximanovabold,
                      color: blackthemedcolor,
                      //    fontSize: 14.5
                 //     fontSize: 13.5
                  fontSize: screenWidth*0.0328
                  )
                  ),
                  TextSpan(
                    text: "Looks like the link is broken or invalid.\n"
                      "Please try copying again or check your connection"
                  )
                ]
              ),
            )

          ),
          Container(
            margin: EdgeInsets.only(
          //      top: 12, bottom: 9
                top: screenWidth*0.02919, bottom: screenWidth*0.0218
            ),
            child: Image.asset("assets/images/404errorcode.png",
    //        width: 266,
      width: screenWidth*0.6472,
            ),
          )
        ],
      ),
    );
  }
}
