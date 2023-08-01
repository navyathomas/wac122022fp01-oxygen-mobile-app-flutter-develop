import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/contact_us_data_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class ContactUsProvider extends ChangeNotifier with ProviderHelperClass {
  ContactUsDataModel? contactUsDataModel;

  Future<void> getContactUsData({bool tryAgain = false}) async {
    if (tryAgain) {
      updateBtnLoaderState(true);
    } else {
      updateLoadState(LoaderState.loading);
    }

    try {
      var resp = await serviceConfig.getContactUsData();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        updateBtnLoaderState(false);
      } else {
        if (resp['getmobilecontactus'] != null) {
          contactUsDataModel =
              ContactUsDataModel.fromJson(resp['getmobilecontactus']);

          updateLoadState(LoaderState.loaded);
          updateBtnLoaderState(false);
        } else {
          updateLoadState(LoaderState.error);
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      updateBtnLoaderState(false);
      log(e.toString());
    }
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
