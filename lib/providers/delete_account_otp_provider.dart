import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/account_delete_success_data_model.dart';
import 'package:oxygen/models/arguments/delete_account_argument.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class DeleteAccountOtpProvider extends ChangeNotifier with ProviderHelperClass {
  bool resendIsEnabled = false;
  String otpErrorMessage = '';

  /// delete customer account
  Future<bool?> deleteCustomerAccount(BuildContext context,
      {required DeleteCustomerAccountArguments data,
      required String otp}) async {
    var netwrk = await Helpers.isInternetAvailable();
    if (netwrk) updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.deleteCustomerAccount(
          reason: data.reason,
          email: data.email,
          otp: otp,
          comment: data.additionalComments);
      if (resp != null && resp is ApiExceptions) {
        updateBtnLoaderState(false);
      } else {
        if (resp['deleteCustomerAccount'] != null) {
          AccountDeleteSuccessDataModel model =
              AccountDeleteSuccessDataModel.fromJson(
                  resp['deleteCustomerAccount']);
          if (model.status ?? false) {
            CommonFunctions.afterInit(() {
              Helpers.successToast(
                  model.message ?? Constants.accountDeleteMessage);
            });
            return true;
          }
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          otpErrorMessage = errorModel.message!;
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateBtnLoaderState(false);
      log(e.toString());
    }
    return null;
  }

  /// Send delete account OTP
  Future<bool?> reSendDeleteAccountOtp(
      {required String email, bool resend = true}) async {
    var netwrk = await Helpers.isInternetAvailable();
    if (netwrk) updateBtnLoaderState(true);
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
      updateBtnLoaderState(false);
      log(e.toString());
    }

    return null;
  }

  void updateResendVisibility(bool val) {
    resendIsEnabled = val;
    notifyListeners();
  }

  void updateDeleteAccountOtpErrorMessage(String val) {
    if (val != otpErrorMessage) {
      otpErrorMessage = val;
      notifyListeners();
    }
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
