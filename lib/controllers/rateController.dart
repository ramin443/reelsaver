import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

class RatingController extends GetxController{
  final InAppReview inAppReview = InAppReview.instance;

  void requestReview()async{
    if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
    }
    update();
  }
  void openStoreListingReview()async{
      inAppReview.openStoreListing();

    update();
  }
}