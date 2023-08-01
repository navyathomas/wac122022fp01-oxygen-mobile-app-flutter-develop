import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class DeleteAccountConfirmationProvider extends ChangeNotifier
    with ProviderHelperClass {
  String? selectedReasonForAccountDeletion;
  String? additionalCoomentForAccountDeletion;
  List<String>? reasonsForDeletion;

  /// Load deletion reasons
  Future<void> getReasonsForDeletion() async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getReasonsForAccountDeletion();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['reasonsForCustomerDeletion'] != null) {
          reasonsForDeletion = [];
          var list = resp['reasonsForCustomerDeletion'] as List<dynamic>;
          for (int i = 0; i < list.length; i++) {
            reasonsForDeletion?.add(list[i].toString());
          }
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      log(e.toString());
      updateLoadState(LoaderState.error);
    }
  }

  /// Send delete account OTP
  Future<bool?> sendDeleteAccountOtp(
      {required String email, bool resend = false}) async {
    updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.sendDeleteAccountOtp(
          email: email, isResend: resend);
      if (resp != null && resp is ApiExceptions) {
        updateBtnLoaderState(false);
      } else {
        if (resp['sendDeleteCustomerOtp'] != null &&
            resp['sendDeleteCustomerOtp'] == true) {
          updateBtnLoaderState(false);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          CommonFunctions.afterInit(() {
            Helpers.successToast(errorModel.message!);
            updateBtnLoaderState(false);
          });
        }
      }
    } catch (e) {
      log(e.toString());
      updateBtnLoaderState(false);
    }

    return null;
  }

  void selectReasonForDeletion(String value) {
    selectedReasonForAccountDeletion = value;
    log(value);
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }
}
