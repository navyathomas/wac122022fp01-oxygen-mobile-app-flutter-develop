import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/shipping_mrthods_response.dart';
import 'package:oxygen/services/provider_helper_class.dart';

import '../models/customer_address_model.dart';
import '../models/error_model.dart';
import '../services/helpers.dart';
import '../services/service_config.dart';

class SelectAddressProvider extends ChangeNotifier with ProviderHelperClass {
  List<Addresses> addressList = [];
  CustomerAddressModel? addressListResponse;
  String? customerEmail;
  int selectedShippingIndex = 0;
  int selectedBillingAddressIndex = 0;
  String errorMessage = '';
  bool isDeleteAddressLoading = false;
  bool isUseSameBillingAddress = false;
  int shippingAddressId = -1;
  int billingAddressId = -1;
  ShippingMethodData? shippingMethodData;
  List<AvailableShippingMethods> availableShippingMethods = [];

  Future<void> getCustomerAddressList({Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getCustomerAddresses();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        addressListResponse = CustomerAddressModel.fromJson(resp['customer']);
        if (addressListResponse != null &&
            addressListResponse!.addresses.notEmpty) {
          updateAddressList(addressListResponse);
        } else {
          isUseSameBillingAddress = false;
          addressList.clear();
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
        }
        updateLoadState(LoaderState.loaded);
      }
    } catch (e) {
      isUseSameBillingAddress = false;
      updateLoadState(LoaderState.error);
    }
  }

  Future<void> removeCustomerAddress(int addressId,
      {Function? onSuccess, Function? onFailure}) async {
    updateDeleteAddressLoaderState(true);
    try {
      var resp =
          await serviceConfig.removeCustomerAddress(addressId: addressId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['deleteCustomerAddress'] != null) {
          if (onSuccess != null) onSuccess();
          updateDeleteAddressLoaderState(false);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateDeleteAddressLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  Future<void> setShippingAddress(String addressId,
      {Function? onSuccess, Function? onFailure}) async {
    updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.setShippingAddress(addressId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['setShippingAddressesOnCart'] != null) {
          shippingMethodData = ShippingMethodData.fromJson(resp);
          if (shippingMethodData != null) {
            updateAvailableShippingMethodList(shippingMethodData!);
          }
          if (onSuccess != null) onSuccess();

          //updateBtnLoaderState(false);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          // updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  Future<void> setBillingAddress(String billingAddressId,
      {Function? onSuccess, Function? onFailure}) async {
    updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.setBillingAddress(billingAddressId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['setBillingAddressOnCart'] != null) {
          if (onSuccess != null) onSuccess();
          updateBtnLoaderState(false);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  updateAddressList(CustomerAddressModel? addressListResponse) {
    addressList = addressListResponse?.addresses ?? [];
    if (addressList.notEmpty) {
      int index = addressList.indexWhere(
          (Addresses? element) => (element?.defaultShipping ?? false) == true);
      if (index != -1) {
        selectedShippingIndex = index;
        selectedBillingAddressIndex = index;
        shippingAddressId = addressList[index].id ?? -1;
      } else {
        shippingAddressId = addressList[0].id ?? -1;
        billingAddressId = shippingAddressId;
      }
      notifyListeners();
      updateIsSameBillingAddress(true);
    }
  }

  updateSelectedShippingIndex(int index) {
    selectedShippingIndex = index;
    notifyListeners();
  }

  updateSelectedShippingAddressId(int id) {
    shippingAddressId = id;
    notifyListeners();
  }

  updateSelectedBillingAddressIndex(int index) {
    selectedBillingAddressIndex = index;
    if (addressList.notEmpty && index != -1) {
      updateSelectedBillingAddressId(addressList[index].id ?? 0);
    }
    notifyListeners();
  }

  updateSelectedBillingAddressId(int id) {
    billingAddressId = id;
    notifyListeners();
  }

  updateDeleteAddressLoaderState(bool state) {
    isDeleteAddressLoading = state;
    debugPrint('is delete address loading $isDeleteAddressLoading');
    notifyListeners();
  }

  updateIsSameBillingAddress(bool value,
      {bool isUpdateBillingAddressIndex = true}) {
    isUseSameBillingAddress = value;
    updateSelectedBillingAddressIndex(
        isUseSameBillingAddress ? selectedShippingIndex : 0);
    notifyListeners();
  }

  updateAvailableShippingMethodList(ShippingMethodData shippingMethodData) {
    if (shippingMethodData
        .setShippingAddressOnCart!.cart!.shippingAddresses.notEmpty) {
      availableShippingMethods = shippingMethodData.setShippingAddressOnCart
              ?.cart?.shippingAddresses![0].availableShippingMethods ??
          [];
    }

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
