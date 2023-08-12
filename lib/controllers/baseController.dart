import 'package:get/get.dart';

class BaseController extends GetxController{
  int currentindex = 0;

  setindex(int index) {
    currentindex = index;
    update();
  }
}