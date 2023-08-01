import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/services/provider_helper_class.dart';

class FeedbackProvider extends ChangeNotifier with ProviderHelperClass {
  int ratingValue = 1;

  void setRatingCount(int index) {
    if (ratingValue == 1 && index == 0) {
      ratingValue = 0;
    } else {
      ratingValue = index + 1;
    }

    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  @override
  void updateLoadState(LoaderState state) {
    // TODO: implement updateLoadState
  }
}
