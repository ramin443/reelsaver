import 'package:flutter/material.dart';
import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
class DownloadInstructionOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
    //      horizontal: 22
      horizontal: screenwidth*0.0535
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
        //        bottom: 10
          bottom: screenwidth*0.02433
            ),
            child: Text("See how to download",style: TextStyle(
              fontFamily: proximanovabold,
              color: blackthemedcolor,
         //     fontSize: 17.5
           fontSize: screenwidth*0.04257
            ),),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getastep(context,1,"Copy Link from a Instagram reels video","Tap on the share button and then "
                "press the copy link button."),
                getastep(context,2,"Paste Link",""),
                getastep(context,3,"Press the download button after the post is loaded","Tap the play button to view the full video from the downloads"
                  "tab or the home screen."),
         ],
            ),
          ),


        ],
      ),
    );
  }
  Widget getastep(BuildContext context, int stepnumber, String steppoint,String subpoint){
    double screenwidth=MediaQuery.of(context).size.width;
    return   Container(
      child:
      Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
                margin: EdgeInsets.only(
//                    top:subpoint==""?8:0,bottom: subpoint==""? 8:0
                    top:subpoint==""?screenwidth*0.0194:0,bottom: subpoint==""? screenwidth*0.0194:0
                ),
                child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        stepcountcontainer(context,stepnumber),
Expanded(
  child:
     Text( steppoint,
            style: TextStyle(
                fontFamily: proximanovaregular,
                color: Colors.black87,
                //      fontSize: 14
                fontSize: screenwidth*0.04027
            )
        ))])),
      subpoint!=""?
      Container(
        margin: EdgeInsets.only(
//            left: 6,top: 4.5,bottom: 4.5
            left: screenwidth*0.01459,top:screenwidth*0.01094,bottom: screenwidth*0.01094

        ),
        child: Text(subpoint,style: TextStyle(
color: Colors.black.withOpacity(0.49),
          fontFamily: proximanovaregular,
  //        fontSize: 13.5
    fontSize: screenwidth*0.03684
        ),),
      ):SizedBox(height: 0,)
      ]),
    );
  }
  Widget stepcountcontainer(BuildContext context,int stepnumber){
   double screenwidth=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
    //      right: 12
          right: screenwidth*0.0291
      ),
      padding: EdgeInsets.all(
  //       7.5
   screenwidth*0.0182   ),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle
      ),
      child: Center(
        child: Text("$stepnumber",style: TextStyle(
          fontFamily: proximanovaregular,
          color: Colors.white,
    //    fontSize: 14.5
      fontSize: screenwidth*0.03527),),
      ),

    );
  }
}
