import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/bajaj_customer_search_model.dart';
import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/models/bajaj_emi_selected_scheme_model.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class BajajEmiProvider extends ChangeNotifier with ProviderHelperClass {
  bool _disposed = false;

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    otpController.dispose();
    cardNumberController.dispose();
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final PageController pageController = PageController();
  final ValueNotifier<int> currentMicroSeconds =
      ValueNotifier<int>(30 * 1000000);

  String? cardNumber;
  String? transactionRefNumber;
  String otpErrorMsg = "";
  String? selectedScheme;

  double linearProgressValue = 1 / 5;

  bool enableSchemeButton = false;
  bool accept = false;

  SelectedScheme? selectedSchemeDetails;
  CustomerBillingSearch? customerBillingSearch;
  BajajTermsAndConditions? termsAndConditions;

  void clearEmiDetails() {
    cardNumber = null;
    customerBillingSearch = null;
    selectedScheme = null;
    selectedSchemeDetails = null;
    accept = false;
    otpErrorMsg = "";
  }

  void changeLinearProgressValue(double value) {
    linearProgressValue = value / 5;
    notifyListeners();
  }

  void updateOtpErrorMsg(String val) {
    if (val != otpErrorMsg) {
      otpErrorMsg = val;
      notifyListeners();
    }
  }

  void changeSchemeButtonStatus(bool value) {
    enableSchemeButton = value;
    notifyListeners();
  }

  void updateCustomerBillingSearch(dynamic value) {
    customerBillingSearch = CustomerBillingSearch.fromJson(value);
    notifyListeners();
  }

  void changeAcceptStatus() {
    accept = !accept;
    notifyListeners();
  }

  void setSelectedScheme(String? value) {
    selectedScheme = value;
    notifyListeners();
  }

  void updateSelectedSchemeDetails(dynamic value) {
    selectedSchemeDetails = SelectedScheme.fromJson(value);
    notifyListeners();
  }

  Future<bool> checkScheme(BuildContext context, String cardNumber) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.checkScheme(cardNumber);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        return false;
      } else {
        if (resp["customerBlillingSearch"] != null) {
          updateCustomerBillingSearch(resp["customerBlillingSearch"]);
          this.cardNumber = cardNumber;
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          CommonFunctions.afterInit(() {
            Helpers.flushToast(context, msg: errorModel.message ?? "");
          });
          updateLoadState(LoaderState.loaded);
          return false;
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      return false;
    }
  }

  Future<bool> setEmiScheme(BuildContext context, String schemeId) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.setEmiScheme(schemeId: schemeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        return false;
      } else {
        if (resp != null &&
            resp["setEmiScheme"] != null &&
            resp["setEmiScheme"]["status"]) {
          return true;
        } else {
          CommonFunctions.afterInit(() {
            Helpers.flushToast(context, msg: "Please check your EMI Scheme");
          });
          updateLoadState(LoaderState.loaded);
          return false;
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      return false;
    }
  }

  Future<bool> getCurrentSchemeDetails() async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getCurrentSchemeDetails();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        return false;
      } else {
        if (resp != null &&
            resp["cart"] != null &&
            resp["cart"]["selected_scheme"] != null) {
          updateSelectedSchemeDetails(resp["cart"]["selected_scheme"]);
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          updateLoadState(LoaderState.loaded);
          return false;
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      return false;
    }
  }

  Future<bool> generateBajajEmiOtp({
    required String cardNumber,
    required String city,
    required bool intercity,
    required String schemeId,
  }) async {
    try {
      updateLoadState(LoaderState.loading);
      var resp = await serviceConfig.generateBajajEmiOtp(
          cardNumber: cardNumber,
          city: city,
          intercity: intercity,
          schemeId: schemeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        return false;
      } else {
        if (resp != null &&
            resp['CustomerBillingOtp'] != null &&
            resp['CustomerBillingOtp']) {
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          updateLoadState(LoaderState.loaded);
          return false;
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      return false;
    }
  }

  Future<bool> verifyBajajEmiOtp({
    required String cardNumber,
    required String schemeId,
    required String otp,
  }) async {
    try {
      updateLoadState(LoaderState.loading);
      var resp = await serviceConfig.verifyBajajEmiOtp(
          cardNumber: cardNumber, schemeId: schemeId, otp: otp);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        return false;
      } else {
        if (resp != null &&
            resp["CustomerBillingAuth"] != null &&
            resp["CustomerBillingAuth"]["status"] &&
            resp["CustomerBillingAuth"]["status"]) {
          transactionRefNumber = resp["CustomerBillingAuth"]["ref_no"];
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            updateOtpErrorMsg(errorModel.message!);
          }
          updateLoadState(LoaderState.loaded);
          return false;
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      return false;
    }
  }

  Future<void> getBajajTermsAndConditions() async {
    try {
      var resp = await serviceConfig.getBajajTermsAndConditions();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp != null && resp["getBajajTermsConditions"] != null) {
          termsAndConditions =
              BajajTermsAndConditions.fromJson(resp["getBajajTermsConditions"]);
        }
      }
    } catch (e) {
      //TODO Handle Exception if needed
    }
  }
}
