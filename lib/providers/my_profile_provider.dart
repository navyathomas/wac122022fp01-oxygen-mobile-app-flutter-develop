import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/models/customer_profile_model.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/models/validation_data_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class MyProfileProvider extends ChangeNotifier with ProviderHelperClass {
  bool invalidCurrentPassword = false;
  String invalidCurrentPasswordMsg = '';
  bool isEdit = false;
  bool verifyEmail = false;
  bool verifyMobile = false;
  bool emailVerified = false;
  bool mobileVerified = false;
  bool updating = false;
  bool dataIsChanged = true;
  String emailInput = '';
  String? selectedDob;
  int? selectedGender;
  final genderList = <String>[Constants.male, Constants.female];
  CustomerProfileModel? profileModel;
  bool dobHasError = false;

  // enable edit
  void enableFeilds() {
    if (!isEdit) {
      isEdit = true;
      dataIsChanged = false;
    }
    notifyListeners();
  }

  // check if email text is changed
  void checkEmailIsChanged(String? email) {
    if (profileModel != null && email != null) {
      if (profileModel!.email == email) {
        verifyEmail = false;
      } else {
        verifyEmail = true;
        emailInput = email;
      }
    }
    notifyListeners();
  }

  // check if mobile text is changed
  void checkMobileIsChanged(String? mobile) {
    if (profileModel != null && mobile != null) {
      if (profileModel!.mobileNumber == mobile) {
        verifyMobile = false;
      } else {
        verifyMobile = true;
      }
    }
    notifyListeners();
  }

  // select dob and update selected dob
  void selectDateOfBirth(BuildContext context,
      {required String firstName, required String lastName}) {
    DateTime initialDate = DateTime.now();
    if (selectedDob != null) {
      var split = selectedDob?.split('-');
      var dd = split?[0];
      var mm = split?[1];
      var yyyy = split?[2];
      initialDate = DateTime.parse('$yyyy-$mm-$dd 00:00:00');
    } else if (profileModel?.dateOfBirth != null) {
      var split = profileModel?.dateOfBirth?.split('-');
      var dd = split?[0];
      var mm = split?[1];
      var yyyy = split?[2];
      initialDate = DateTime.parse('$yyyy-$mm-$dd 00:00:00');
    }
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 20075)),
      lastDate: DateTime.now(),
    ).then((dateTime) {
      if (dateTime != null) {
        var dd = dateTime.day < 9 ? '0${dateTime.day}' : dateTime.day;
        var mm = dateTime.month < 9 ? '0${dateTime.month}' : dateTime.month;
        var yyyy = dateTime.year;
        var dob = '$dd-$mm-$yyyy';
        selectedDob = dob;
        checkDataChange(firstName: firstName, lastName: lastName);
        dobHasError = false;
        notifyListeners();
      }
    });
  }

  // update selected dob
  void selectGender(String value) {
    switch (value) {
      case 'Male':
        selectedGender = 1;
        break;
      case 'Female':
        selectedGender = 2;
    }
  }

  String getGender(int? value) {
    switch (value) {
      case 1:
        return Constants.male;
      case 2:
        return Constants.female;
      default:
        return '';
    }
  }

  // get customer info
  Future<void> getPersonalInfoData(
      {bool loadState = true, bool reload = false}) async {
    if (loadState) updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getCustomerProfileData();
      if (resp != null && resp is ApiExceptions) {
        if (loadState) updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['customer'] != null) {
          profileModel = CustomerProfileModel.fromJson(resp['customer']);
          if (loadState) updateLoadState(LoaderState.loaded);
        } else {
          if (loadState) updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      if (loadState) updateLoadState(LoaderState.error);
    }
  }

// change password screen
  Future<bool?> changePassword(
      BuildContext context, String currentPassword, String newPassword) async {
    invalidCurrentPassword = false;
    final network = await Helpers.isInternetAvailable();
    updateBtnLoaderState(true);
    if (network) {
      try {
        var resp = await serviceConfig.changeCustomerPassword(
            currentPassword, newPassword);
        if (resp?['changeCustomerPassword'] != null) {
          CommonFunctions.afterInit(
            () => Helpers.flushToast(context, msg: Constants.passWordChanged),
          );
          updateBtnLoaderState(false);
          return true;
        } else {
          invalidCurrentPassword = true;
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          invalidCurrentPasswordMsg = errorModel.message ?? '';
          updateBtnLoaderState(false);
        }
      } catch (e) {
        updateBtnLoaderState(false);
      }
    } else {
      updateBtnLoaderState(false);
    }
    return null;
  }

  /// Update my profile
  Future<void> updateCustomerProfile(
    BuildContext context, {
    required String firstName,
    required String lastName,
  }) async {
    if (profileModel?.dateOfBirth == null && selectedDob == null) {
      dobHasError = true;
      notifyListeners();
      return;
    } else {
      if (dataIsChanged) {
        updateInScreenLoadingState(true);
        try {
          var resp = await serviceConfig.updateCustomerGeneralInformations(
            firstName: firstName,
            lastName: lastName,
            // gender: selectedGender ?? profileModel!.gender!,
            dateOfBirth: selectedDob ?? profileModel!.dateOfBirth!,
          );
          log(resp.toString());
          if (resp != null && resp is ApiExceptions) {
            updateInScreenLoadingState(false);
            Helpers.successToast(Constants.noInternet);
          } else {
            if (resp['updateCustomer'] != null &&
                resp['updateCustomer']['customer'] != null) {
              getPersonalInfoData(loadState: false).then((_) async {
                var authCustomer = await HiveServices.instance.getUserData();
                await HiveServices.instance.saveUserData(
                  AuthCustomer()
                    ..firstname = profileModel?.firstname
                    ..lastname = profileModel?.lastname
                    ..email = authCustomer?.email
                    ..mobileNumber = authCustomer?.mobileNumber,
                );
                isEdit = false;
                dataIsChanged = true;
                updateInScreenLoadingState(false);
              });
              CommonFunctions.afterInit(
                () => Helpers.flushToast(context,
                    msg: Constants.profileUpdatedMsg),
              );
            } else {
              ErrorModel errorModel = ErrorModel.fromJson(resp);
              if (errorModel.message != null) {
                CommonFunctions.afterInit(
                  () => Helpers.flushToast(context, msg: errorModel.message!),
                );
              }
              updateInScreenLoadingState(false);
            }
          }
        } catch (e) {
          updateInScreenLoadingState(false);
          log(e.toString());
        }
      }
    }
  }

  String? validateTwoEquelPassword(String? value, String? value2) {
    if ((value ?? '').isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value!.length < 8) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return Constants.passwordValidationMsg;
    } else if (value != value2) {
      return Constants.passwordNotEquel;
    }
    return null;
  }

  String? validateTwoDifferentPassword(String? value, String? value2) {
    if ((value2 ?? '').isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value!.length < 8) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return Constants.passwordValidationMsg;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return Constants.passwordValidationMsg;
    } else if (value == value2) {
      return Constants.passwordCannotBeSame;
    }
    return null;
  }

  void checkDataChange({required String firstName, required String lastName}) {
    dataIsChanged = true;
    notifyListeners();
  }

  void resetValues() {
    verifyEmail = false;
    verifyMobile = false;
    isEdit = false;
    selectedDob = null;
    dataIsChanged = true;
    dobHasError = false;
    invalidCurrentPassword = false;
    changePasswordData = ResetPasswordData();
    log('DATA CLEARED');
  }

  void updateInScreenLoadingState(bool value) {
    updating = value;
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
    loaderState = state;
    notifyListeners();
  }

  ResetPasswordData changePasswordData = ResetPasswordData();

  void updateChangePasswordData({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) {
    changePasswordData = changePasswordData.copyWith(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
    notifyListeners();
  }
}
