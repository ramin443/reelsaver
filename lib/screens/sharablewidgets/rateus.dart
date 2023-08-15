import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/colorconstants.dart';
import '../../constants/fontconstants.dart';
import '../../controllers/rateController.dart';
class RateUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    return
      GetBuilder<RatingController>(
          init: RatingController(),
          builder: (ratecontroller)
          {
            return
              GestureDetector(
                onTap: (){
                  ratecontroller.openStoreListingReview();
             //     ratecontroller.onreviewboxtapped();
//                  ratecontroller.requestreview();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    //       vertical: 31
                      vertical: screenwidth*0.07542 ),
                  width: screenwidth*0.8029,
                  padding: EdgeInsets.all(screenwidth*0.0364),
                  decoration: BoxDecoration(
                      color: Color(0xffFAFAFA).withOpacity(0.52),
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      border: Border.all(color: Color(0xff707070).withOpacity(0.2),width: 1)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        child: Text("Rate Us",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: proximanovabold,
                              color: blackthemedcolor,
                              //    fontSize: 18.5
                              fontSize:screenwidth*0.04501
                          ),),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          //       top: 38,bottom:25
                            top: screenwidth*0.0924,
                            bottom: screenwidth*0.0608
                        ),
                        child: Image.asset("assets/images/casual-life-3d-meditation-1@3x.png",
                          width: screenwidth*0.5255
                          ,),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            //       top: 38,bottom:25
                              bottom: screenwidth*0.0308
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                    //      horizontal:17
                                      right: screenwidth*0.0363
                                  ),
                                  child:
                                  Icon(Icons.star_border,
                                    color: Colors.grey[700],
                                    //     size: 29,
                                    size: screenwidth*0.0705,)),
                              Container(
                                  child:
                                  Icon(Icons.star_border,
                                    color: Colors.grey[700],
                                    //     size: 29,
                                    size: screenwidth*0.0705,)),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                    //      horizontal:17
                                      horizontal: screenwidth*0.0363
                                  ),
                                  child:
                                  Icon(Icons.star_border,
                                      //     size: 29,
                                      size: screenwidth*0.0705,
                                      color: Colors.grey[700])),
                              Container(child:
                              Icon(Icons.star_border,
                                  //     size: 29,
                                  size: screenwidth*0.0705,
                                  color: Colors.grey[700])),
                              Container(
                                  margin: EdgeInsets.only(
                                    //      horizontal:17
                                      left: screenwidth*0.0363
                                  ),
                                  child:
                                  Icon(Icons.star_border,
//     size: 29,
                                      size: screenwidth*0.0705,
                                      color: Colors.grey[700])),
                            ],
                          )
                      ),
                      Container(
                        child: Text("We are always trying to improve what we do\n"
                            "and we highly regard your review",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: proximanovaregular,
                              color: blackthemedcolor,
                              //    fontSize: 18.5
                              fontSize:screenwidth*0.0304
                          ),),
                      ),
                    ],
                  ),
                ),
              );});

  }
}
