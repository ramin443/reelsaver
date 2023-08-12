import 'package:flutter/material.dart';

import '../../sharablewidgets/downloadinstruction2.dart';
import '../../sharablewidgets/rateus.dart';
class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[  RateUs(),]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[  DownloadInstructionTwo(),]),

            ],
          ),
        ));
  }
}
