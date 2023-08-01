import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/models/validation_data_model.dart';
import 'package:oxygen/repositories/app_data_repo.dart';
import 'package:oxygen/repositories/authentication_repo.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/service_config.dart';

import '../common/validator.dart';
import '../models/error_model.dart';
import '../repositories/compare_repo.dart';
import '../services/provider_helper_class.dart';
import '../services/shared_preference_helper.dart';

class AuthProvider extends ChangeNotifier with ProviderHelperClass {
  String authInput = '';
  bool isNumber = false;
  String cartId = '';
  String errorMsg = '';
  String otpErrorMsg = '';
  String inputPassword = '';
  String invalidPasswordMsg = '';
  RegisterScreenData registerScreenData = RegisterScreenData();
  ChangePasswordData changePasswordData = ChangePasswordData();
  LoaderState resetPasswordLoader = LoaderState.loaded;

  String get auhInputData =>
      isNumber ? "${Constants.countryDialCode}$authInput" : authInput;
  AuthCustomer? authCustomer;

  void validateNumberInput(String val) {
    String value = val.trim();
    if (value.isEmpty) return;
    if (Validator.validateIsMobileNumber(value) && value.length > 2) {
      isNumber = true;
      authInput = value;
      notifyListeners();
    } else {
      if (Validator.validateIsEmail(val)) {
        isNumber = false;
        authInput = val.trim();
        notifyListeners();
      } else {
        isNumber = false;
        authInput = '';
        notifyListeners();
      }
    }
  }

  String? validateAuthInput(String? val) {
    return isNumber
        ? Validator.validateMobile(val, maxLength: 10)
        : Validator.validateEmail(val);
  }

  ///Check auth user exist with email or password
  Future<bool?> checkCustomerAlreadyExists() async {
    bool? isExist;
    updateBtnLoaderState(true);
    try {
      await getEmptyCart();
      var resp = await serviceConfig.checkCustomerAlreadyExists(auhInputData);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateBtnLoaderState(false);
      } else {
        if (resp?["checkCustomerAlreadyExists"] != null) {
          if (resp["checkCustomerAlreadyExists"] ?? false) {
            await serviceConfig.sendLoginOtp(auhInputData, false);
            isExist = true;
            updateBtnLoaderState(false);
          } else {
            await serviceConfig.sendRegistrationOtp(auhInputData, false);
            isExist = false;
            updateBtnLoaderState(false);
          }
        } else {
          CommonFunctions.checkException(resp);
          updateBtnLoaderState(false);
        }
      }
    } catch (onError) {
      updateBtnLoaderState(false);
      debugPrint(onError.toString());
    }
    return isExist;
  }

  ///Request login Otp
  Future<bool> requestLoginOtp(
      {bool resend = false, Function(String)? onError}) async {
    bool resFlag = false;
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.sendLoginOtp(auhInputData, resend);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp?['sendLoginOtp'] != null && resp?['sendLoginOtp']) {
          updateLoadState(LoaderState.loaded);
          resFlag = true;
          return resFlag;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.error != null) {
            updateErrorMsg(
                errorModel.message ?? Constants.oopsSomethingWentWrong);
            if (onError != null) {
              onError(errorModel.message ?? Constants.oopsSomethingWentWrong);
            }
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      'sendLoginOtp $e'.log(name: 'AuthProvider');
      updateLoadState(LoaderState.error);
    }
    return resFlag;
  }

  ///Request Forgot Password Otp
  Future<bool> requestForgotPasswordOtp({bool resend = false}) async {
    bool resFlag = false;
    updateBtnLoaderState(true);
    try {
      var resp =
          await serviceConfig.sendForgotPasswordOtp(auhInputData, resend);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateBtnLoaderState(false);
      } else {
        if (resp?['sendForgotpasswordOtp'] != null &&
            resp['sendForgotpasswordOtp']) {
          updateBtnLoaderState(false);
          resFlag = true;
          return resFlag;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.error != null) {
            updateErrorMsg(
                errorModel.message ?? Constants.oopsSomethingWentWrong);
          }
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      'sendForgotpasswordOtp $e'.log(name: 'AuthProvider');
      updateBtnLoaderState(false);
    }
    return resFlag;
  }

  ///Request registration Otp
  Future<bool> requestRegistrationOtp(BuildContext context,
      {bool resend = false}) async {
    bool resFlag = false;
    updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.sendRegistrationOtp(auhInputData, resend);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateBtnLoaderState(false);
      } else {
        if (resp?['sendRegistrationOtp'] != null &&
            resp?['sendRegistrationOtp']) {
          updateBtnLoaderState(false);
          resFlag = true;
          return resFlag;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            Future.microtask(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      'sendRegistrationOtp $e'.log(name: 'AuthProvider');
      updateLoadState(LoaderState.error);
    }
    return resFlag;
  }

  ///Verify user otp
  Future<bool?> loginUsingOtp(String otp) async {
    bool? resFlag;
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.loginUsingOtp(auhInputData, otp);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp?['loginUsingOtp'] != null) {
          AuthDataModel authDataModel =
              AuthDataModel.fromJson(resp['loginUsingOtp']);
          if (authDataModel.token != null) {
            await SharedPreferencesHelper.saveUserToken(authDataModel.token!);
            await HiveServices.instance
                .saveUserData(authDataModel.authCustomer);
            saveUserAuthData(authDataModel.authCustomer);
          }
          if (cartId.isEmpty) getEmptyCart();
          String mergeCart = await mergeCartId();
          if (mergeCart.isEmpty) {
            await SharedPreferencesHelper.removeAllTokens();
            await HiveServices.instance.clearBoxData();
            updateLoadState(LoaderState.loaded);
            return false;
          }
          await SharedPreferencesHelper.saveLoginStatus(true);
          await AppDataRepo.getAppData();
          await CompareRepo.getCompareProducts();
          FirebaseAnalyticsService.instance
              .logLoginMethod(loginMethod: 'Login using otp');
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            updateOtpErrorMsg(errorModel.message!);
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      'Create customer cart $e'.log(name: 'AuthProvider');
      updateLoadState(LoaderState.error);
    }
    return resFlag;
  }

  ///Rest User Password
  Future<bool?> changeCustomerPasswordOtp(
      BuildContext context, String otp, String password) async {
    bool? resFlag;
    updateRestPasswordLoader(LoaderState.loading);
    try {
      var resp = await serviceConfig.changeCustomerPasswordOtp(
          auhInputData, otp, password);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateRestPasswordLoader(LoaderState.error);
      } else {
        if (resp?['changeCustomerPasswordOtp'] != null &&
            resp?['changeCustomerPasswordOtp']) {
          Future.microtask(() =>
              Helpers.flushToast(context, msg: Constants.userPasswordUpdated));

          resFlag = true;
          updateRestPasswordLoader(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          updateRestPasswordLoader(LoaderState.error);
          if (errorModel.message != null) {
            updateErrorMsg(errorModel.message!);
          }
        }
      }
    } catch (e) {
      'Create customer cart $e'.log(name: 'AuthProvider');
      updateRestPasswordLoader(LoaderState.error);
    }
    return resFlag;
  }

  ///Login using password
  Future<bool?> loginUsingPassword(
      BuildContext context, String password) async {
    bool? resFlag;
    invalidPasswordMsg = '';
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.loginUsingPassword(auhInputData, password);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp?['generateCustomerToken'] != null) {
          AuthDataModel authDataModel =
              AuthDataModel.fromJson(resp['generateCustomerToken']);
          if (authDataModel.token != null) {
            await SharedPreferencesHelper.saveUserToken(authDataModel.token!);
          }
          await getAuthCustomerDetails();
          if (cartId.isEmpty) getEmptyCart();
          String mergeCart = await mergeCartId();
          if (mergeCart.isEmpty) {
            await SharedPreferencesHelper.removeAllTokens();
            await HiveServices.instance.clearBoxData();
            updateLoadState(LoaderState.loaded);
            return false;
          }
          await AppDataRepo.getAppData();
          await CompareRepo.getCompareProducts();
          FirebaseAnalyticsService.instance
              .logLoginMethod(loginMethod: 'Login using password');
          updateLoadState(LoaderState.loaded);
          resFlag = true;
          return resFlag;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            invalidPasswordMsg = errorModel.message ?? '';
            notifyListeners();
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      'Create customer cart $e'.log(name: 'AuthProvider');
      updateLoadState(LoaderState.error);
    }
    return resFlag;
  }

  ///Register user
  Future<bool?> registerUser(
      {required String firstName,
      required String lastName,
      required String mobileNumber,
      required String emailAddress,
      required String otp,
      required String password}) async {
    bool? resFlag;
    updateErrorMsg('');
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.registrationUsingOtp(
          mobileNumber: '+91$mobileNumber',
          otp: otp,
          firstName: firstName,
          lastName: lastName,
          password: password,
          email: emailAddress);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp?['registrationUsingOtp'] != null) {
          AuthDataModel authDataModel =
              AuthDataModel.fromJson(resp['registrationUsingOtp']);
          if (authDataModel.token != null) {
            await SharedPreferencesHelper.saveUserToken(authDataModel.token!);
            await HiveServices.instance
                .saveUserData(authDataModel.authCustomer);
            saveUserAuthData(authDataModel.authCustomer);
          }
          if (cartId.isEmpty) getEmptyCart();
          String mergeCart = await mergeCartId();
          if (mergeCart.isEmpty) {
            await SharedPreferencesHelper.removeAllTokens();
            await HiveServices.instance.clearBoxData();
            updateLoadState(LoaderState.loaded);
            return false;
          }
          await SharedPreferencesHelper.saveLoginStatus(true);
          await CompareRepo.getCompareProducts();
          resFlag = true;
          updateLoadState(LoaderState.loaded);
          return resFlag;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.error != null) {
            updateErrorMsg(
                errorModel.message ?? Constants.oopsSomethingWentWrong);
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (onError) {
      updateLoadState(LoaderState.loaded);
      debugPrint(onError.toString());
    }
    return resFlag;
  }

  ///Check cart Id exist else create one
  Future<String> getCartId() async {
    String userCartId = '';
    String savedId = await SharedPreferencesHelper.getCartId();
    if (savedId.isEmpty) {
      try {
        var resp = await getEmptyCart();
        if (resp.isNotEmpty) {
          userCartId = resp;
          return userCartId;
        }
      } catch (e) {
        'Create empty cart $e'.log(name: 'AuthProvider');
      }
    } else {
      await setCartId(savedId, save: false);
      return savedId;
    }

    return userCartId;
  }

  ///Create empty cart
  Future<String> getEmptyCart({bool enableToast = false}) async {
    String emptyCartId = '';
    emptyCartId =
        await AuthenticationRepo.getEmptyCart(enableToast: enableToast);
    await setCartId(emptyCartId);
    return emptyCartId;
  }

  ///Create customer cart
  Future<String> createCustomerCart({bool cacheCart = false}) async {
    String customerCartId = '';
    customerCartId =
        await AuthenticationRepo.createCustomerCart(cacheCart: cacheCart);
    await setCartId(customerCartId);
    return customerCartId;
  }

  /// merge customer cart id with empty cart id and save response id as current cart id
  Future<String> mergeCartId() async {
    String mergeCartId = '';
    mergeCartId = await AuthenticationRepo.mergeCartId(cartId);
    await setCartId(mergeCartId);
    return mergeCartId;
  }

  Future<void> getAuthCustomerDetails() async {
    try {
      var resp = await serviceConfig.getAuthCustomerData();
      if (resp["customer"] != null) {
        AuthCustomer authCustomer = AuthCustomer.fromJson(resp["customer"]);
        await HiveServices.instance.saveUserData(authCustomer);
        saveUserAuthData(authCustomer);
      }
    } catch (e) {
      debugPrint("Get auth customer error $e");
    }
  }

  ///Logout user -----------------------
  Future<void> logoutUser({required Function(bool) onResponse}) async {
    try {
      updateBtnLoaderState(true);
      bool res = await AuthenticationRepo.logoutUser();
      if (res) {
        await SharedPreferencesHelper.removeAllTokens();
        await AuthenticationRepo.getEmptyCart();
        updateBtnLoaderState(false);
        onResponse(true);
      } else {
        updateBtnLoaderState(false);
      }
    } catch (e) {
      updateBtnLoaderState(false);
      debugPrint("Get auth customer error $e");
    }
  }

  Future<void> setCartId(val, {bool save = true}) async {
    cartId = val;
    AppConfig.cartId = cartId;
    if (save) await SharedPreferencesHelper.saveCartId(cartId);
    notifyListeners();
  }

  void updateErrorMsg(String val) {
    if (val != errorMsg) {
      errorMsg = val;
      notifyListeners();
    }
  }

  void updateOtpErrorMsg(String val) {
    if (val != otpErrorMsg) {
      otpErrorMsg = val;
      notifyListeners();
    }
  }

  void updateInputPassword(String value) {
    inputPassword = value.trim();
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

  void otpInit() {
    errorMsg = '';
    otpErrorMsg = '';
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  void loginPasswordInit() {
    otpErrorMsg = '';
    invalidPasswordMsg = '';
    inputPassword = '';
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  void forgotPasswordInit() {
    errorMsg = '';
    resetPasswordLoader = LoaderState.loaded;
    loaderState = LoaderState.loaded;
    changePasswordData = ChangePasswordData();
    notifyListeners();
  }

  void updateRestPasswordLoader(LoaderState state) {
    resetPasswordLoader = state;
    notifyListeners();
  }

  void registrationInit() {
    errorMsg = '';
    registerScreenData = RegisterScreenData(
        mobileNumber: isNumber ? authInput : null,
        email: isNumber ? null : authInput);
    btnLoaderState = false;
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  @override
  void pageInit() {
    errorMsg = '';
    authInput = '';
    btnLoaderState = false;
    isNumber = false;
    loaderState = LoaderState.loaded;
    notifyListeners();
  }

  void updateRegisterScreenData(
      {String? mobileNumber,
      String? otp,
      String? firstName,
      String? lastName,
      String? email,
      String? password}) {
    registerScreenData = registerScreenData.copyWith(
        mobileNumber: mobileNumber,
        otp: otp,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password);
    notifyListeners();
  }

  void updateChangePasswordData(
      {String? otp, String? newPassword, String? confirmPassword}) {
    changePasswordData = changePasswordData.copyWith(
        otp: otp, newPassword: newPassword, confirmPassword: confirmPassword);
    notifyListeners();
  }

  void updatePasswordValidator() {
    invalidPasswordMsg = '';
    notifyListeners();
  }

  void saveUserAuthData(AuthCustomer? customer) {
    authCustomer = customer;
    FirebaseAnalyticsService.instance
        .logUserData(name: customer?.firstname ?? '', loginValue: authInput);
    notifyListeners();
  }
}
