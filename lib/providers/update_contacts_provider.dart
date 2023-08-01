import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/models/customer_profile_model.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class UpdateContactsProvider extends ChangeNotifier with ProviderHelperClass {
  String email = 'email';
  String mobile = 'mobile';

  CustomerProfileModel? initialData;
  AuthCustomer? authCustomer;

  /// Field visibility
  bool mobileOtpFieldVisibility = false;
  bool emailOtpFieldVisibility = false;

  /// Data changes
  bool mobileTextIsChanged = false;
  bool emailTextIsChanged = false;

  ///
  bool mobileFeildIsEditable = true;
  bool emailFieldIsEditable = true;

  /// Otp sent to
  String mobileOtpSendTo = '';
  String emailOtpSendTo = '';

  /// load states
  bool mobileNumberLoaderState = false;
  bool emailLoaderState = false;

  /// otp values
  String? mobileOtp;
  String? emailOtp;

  /// verified
  bool mobileNumberIsVerified = false;
  bool emailIsVerified = false;

  /// err msgs
  String? mobileOtpErrorMsg;
  String? emailOtpErrorMsg;

  String? mobileFieldErrorMsg;
  String? emailFieldErrorMsg;

  /// Otp field loader states
  bool mobileOtpFieldLoaderStete = false;
  bool emailOtpFieldLoaderState = false;

  Future<dynamic> customerUpdateSendOtp(BuildContext context,
      {required String type}) async {
    switch (type) {
      case 'mobile':
        if (mobileFeildIsEditable) {
          updateMobileNumberLoaderState(true);
        } else {
          mobileOtpFieldVisibility = false;
          mobileFeildIsEditable = true;
          notifyListeners();
          return;
        }
        try {
          var resp =
              await serviceConfig.sendCustomerUpdateOtp(value: mobileOtpSendTo);
          log(resp.toString());
          if (resp != null && resp is ApiExceptions) {
            updateMobileNumberLoaderState(false);
            CommonFunctions.checkException(resp);
          } else {
            if (resp['sendOtpUpdateCustomer'] == true) {
              mobileFeildIsEditable = false;
              mobileOtpFieldVisibility = true;
              updateMobileNumberLoaderState(false);
              return true;
            } else {
              ErrorModel errorModel = ErrorModel.fromJson(resp);
              if (errorModel.extensions?.category == 'graphql-input' ||
                  errorModel.extensions?.category == 'no-customer') {
                mobileFieldErrorMsg = errorModel.message ?? '';
              } else {
                CommonFunctions.afterInit(() {
                  Helpers.flushToast(context, msg: errorModel.message ?? '');
                });
              }
              updateMobileNumberLoaderState(false);
              return false;
            }
          }
        } catch (e) {
          log(e.toString());
        }
        break;
      case 'email':
        if (emailFieldIsEditable) {
          updateEmailLoaderState(true);
        } else {
          emailOtpFieldVisibility = false;
          emailFieldIsEditable = true;
          notifyListeners();
          return;
        }
        try {
          var resp = await serviceConfig.sendCustomerUpdateOtp(
              value: emailOtpSendTo, type: 'email');
          if (resp != null && resp is ApiExceptions) {
            updateEmailLoaderState(false);
            CommonFunctions.checkException(resp);
          } else {
            if (resp['sendOtpUpdateCustomer'] == true) {
              emailFieldIsEditable = false;
              emailOtpFieldVisibility = true;
              updateEmailLoaderState(false);
              return true;
            } else {
              ErrorModel errorModel = ErrorModel.fromJson(resp);
              if (errorModel.extensions?.category == 'graphql-input' ||
                  errorModel.extensions?.category == 'no-customer') {
                emailFieldErrorMsg = errorModel.message ?? '';
              } else {
                CommonFunctions.afterInit(() {
                  Helpers.flushToast(context, msg: errorModel.message ?? '');
                });
              }

              updateEmailLoaderState(false);
              return false;
            }
          }
        } catch (e) {
          log(e.toString());
        }
        break;
    }
  }

  Future<Map<String, dynamic>?> updateCustomerContacts(
      BuildContext context) async {
    try {
      if (mobileOtpFieldVisibility) {
        authCustomer = await HiveServices.instance.getUserData();
        updateMobileNumberLoaderState(true);
        var resp = await serviceConfig.updateCustomerEmailOrMobile(
          value: getValidMobileNumber(initialData?.mobileNumber) ?? '',
          newValue: mobileOtpSendTo,
          otp: mobileOtp ?? '',
        );
        log(resp.toString());
        if (resp != null && resp is ApiExceptions) {
          updateMobileNumberLoaderState(false);
        } else {
          if (resp['updateCustomerEmailMobile'] == true) {
            await HiveServices.instance.saveUserData(
              AuthCustomer()
                ..firstname = authCustomer?.firstname
                ..lastname = authCustomer?.lastname
                ..email = authCustomer?.email
                ..mobileNumber = mobileOtpSendTo,
            );
            mobileNumberIsVerified = true;
            mobileOtpFieldVisibility = false;
            mobileFeildIsEditable = true;
            mobileTextIsChanged = false;
            initialData?.mobileNumber = mobileOtpSendTo;
            mobileOtpSendTo = '';
            updateMobileNumberLoaderState(false);
          } else {
            ErrorModel errorModel = ErrorModel.fromJson(resp);
            if (errorModel.extensions?.category == 'graphql-input' ||
                errorModel.extensions?.category == 'invalid-otp') {
              mobileOtpErrorMsg = errorModel.message ?? '';
            } else {
              CommonFunctions.afterInit(() {
                Helpers.flushToast(context, msg: errorModel.message ?? '');
              });
            }
            updateMobileNumberLoaderState(false);
            return {'mobile': false};
          }
          log(resp.toString());
        }
      }

      /// Email
      if (emailOtpFieldVisibility) {
        authCustomer = await HiveServices.instance.getUserData();
        updateEmailLoaderState(true);
        var resp = await serviceConfig.updateCustomerEmailOrMobile(
            value: initialData?.email ?? '',
            newValue: emailOtpSendTo,
            otp: emailOtp ?? '',
            type: 'email');
        if (resp != null && resp is ApiExceptions) {
          updateEmailLoaderState(false);
        } else {
          if (resp['updateCustomerEmailMobile'] == true) {
            await HiveServices.instance.saveUserData(
              AuthCustomer()
                ..firstname = authCustomer?.firstname
                ..lastname = authCustomer?.lastname
                ..email = emailOtpSendTo
                ..mobileNumber = authCustomer?.mobileNumber,
            );
            emailIsVerified = true;
            emailOtpFieldVisibility = false;
            emailFieldIsEditable = true;
            emailTextIsChanged = false;
            initialData?.email = emailOtpSendTo;
            emailOtpSendTo = '';
            updateEmailLoaderState(false);
          } else {
            ErrorModel errorModel = ErrorModel.fromJson(resp);
            if (errorModel.extensions?.category == 'graphql-input' ||
                errorModel.extensions?.category == 'invalid-otp') {
              emailOtpErrorMsg = errorModel.message ?? '';
            } else {
              CommonFunctions.afterInit(() {
                Helpers.flushToast(context, msg: errorModel.message ?? '');
              });
            }
            updateEmailLoaderState(false);
            log(errorModel.message.toString());
            return {'email': false};
          }
          log(resp.toString());
        }
      }
    } catch (e) {
      log(e.toString());
      updateMobileNumberLoaderState(false);
      updateEmailLoaderState(false);
    }
    return null;
  }

  Future<bool?> resendOtp(BuildContext context, {String? type}) async {
    try {
      switch (type) {
        case 'mobile':
          updateMobileOtpLoaderState(true);
          var resp = await serviceConfig.sendCustomerUpdateOtp(
              value: mobileOtpSendTo, resend: true);
          if (resp != null && resp is ApiExceptions) {
            CommonFunctions.checkException(resp);
            updateMobileOtpLoaderState(false);
          } else {
            log(resp.toString());
            if (resp['sendOtpUpdateCustomer'] == true) {
              updateMobileOtpLoaderState(false);
              return true;
            } else {
              updateMobileOtpLoaderState(false);
              ErrorModel errorModel = ErrorModel.fromJson(resp);
              CommonFunctions.afterInit(() {
                Helpers.flushToast(context, msg: errorModel.message ?? '');
              });
            }
          }
          break;
        case 'email':
          updateEmailOtpFieldLoaderState(true);
          var resp = await serviceConfig.sendCustomerUpdateOtp(
              value: emailOtpSendTo, resend: true, type: 'email');
          if (resp != null && resp is ApiExceptions) {
            CommonFunctions.checkException(resp);
            updateEmailOtpFieldLoaderState(false);
          } else {
            log(resp.toString());
            if (resp['sendOtpUpdateCustomer'] == true) {
              updateEmailOtpFieldLoaderState(false);
              return true;
            } else {
              updateEmailOtpFieldLoaderState(false);
              ErrorModel errorModel = ErrorModel.fromJson(resp);
              CommonFunctions.afterInit(() {
                Helpers.flushToast(context, msg: errorModel.message ?? '');
              });
            }
          }
          break;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateMobileOtpLoaderState(bool value) {
    mobileOtpFieldLoaderStete = value;
    notifyListeners();
  }

  void updateEmailOtpFieldLoaderState(bool value) {
    emailOtpFieldLoaderState = value;
    notifyListeners();
  }

  void setInitialData(CustomerProfileModel? data) {
    initialData = data;
  }

  void updateMobileNumberLoaderState(bool value) {
    mobileNumberLoaderState = value;
    notifyListeners();
  }

  void updateEmailLoaderState(bool value) {
    emailLoaderState = value;
    notifyListeners();
  }

  void updateDataChanges(String type, {String? mobile, String? email}) {
    switch (type) {
      case 'mobile':
        mobileNumberIsVerified = false;
        if ((mobile ?? '').isEmpty) {
          mobileTextIsChanged = false;
          notifyListeners();
          return;
        }
        if (getValidMobileNumber(initialData?.mobileNumber) == mobile) {
          mobileTextIsChanged = false;
        } else {
          mobileTextIsChanged = true;
        }
        notifyListeners();
        break;
      case 'email':
        emailIsVerified = false;
        if (initialData?.email == email) {
          emailTextIsChanged = false;
        } else {
          emailTextIsChanged = true;
        }
        notifyListeners();
        break;
    }
  }

  String? getValidMobileNumber(String? value) {
    if (value != null) {
      if (value.startsWith('+91') && value.length == 13) {
        return value.substring(3);
      } else {
        return value;
      }
    }
    return null;
  }
}
