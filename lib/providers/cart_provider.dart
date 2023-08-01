import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/cart_data_model.dart';
import 'package:oxygen/repositories/cart_repo.dart';
import 'package:oxygen/repositories/wishlist_repo.dart';

import '../common/common_function.dart';
import '../models/error_model.dart';
import '../services/provider_helper_class.dart';
import '../services/service_config.dart';

class CartProvider extends ChangeNotifier with ProviderHelperClass {
  CartDataModel? cartDataModel;
  bool isCouponApplied = false;
  bool couponLoader = false;
  bool cartLoaderState = false;
  bool restoreCartLoader = false;
  bool emptyCartLoader = false;

  Future<CartDataModel?> getCartDataList(
      {bool enableLoader = true, Function(String)? onCouponOccurs}) async {
    CartDataModel? model;
    if (enableLoader) updateLoadState(LoaderState.loading);
    try {
      dynamic resp = await serviceConfig.getCartData();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
      } else if (resp != null && resp?['cart'] != null) {
        model = CartDataModel.fromJson(resp['cart']);
        if (model.cartItems == null) {
          updateCartDataModel(null);
          updateLoadState(LoaderState.error);
          return model;
        }
        if ((model.cartItems ?? []).isEmpty) {
          updateCartDataModel(null);
          updateLoadState(LoaderState.noData);
        } else {
          if (onCouponOccurs != null &&
              (model.appliedCoupons ?? []).isNotEmpty) {
            onCouponOccurs(model.appliedCoupons?.first.code ?? '');
            isCouponApplied = true;
            notifyListeners();
          }
          updateCartDataModel(model);
          updateLoadState(LoaderState.loaded);
        }
      } else {
        await CommonFunctions.checkException(resp,
            enableToast: false, onAuthError: (val) {});
        updateCartDataModel(null);
        updateLoadState(LoaderState.error);
      }
    } catch (_) {
      updateLoadState(LoaderState.error);
      dev.log("getCartData");
    }
    return model;
  }

  Future<bool> addToCart(BuildContext context,
      {required String sku,
      required int qty,
      String? name,
      int? optionId,
      int? optionTypeId,
      bool refreshData = false}) async {
    bool flag = false;
    bool res = await CartRepo.addSimpleProductToCart(sku,
        qty: qty, optionId: optionId, optionTypeId: optionTypeId, name: name);
    if (res) {
      flag = true;
      //refreshData
    } else {
      flag = false;
    }
    return flag;
  }

  Future<bool> addConfigurableToCart(BuildContext context,
      {required String sku,
      required String parentSku,
      required int qty,
      String? name,
      int? optionId,
      int? optionTypeId,
      bool refreshData = false}) async {
    bool flag = false;
    bool res = await CartRepo.addConfigurableProductToCart(
        sku: sku,
        qty: qty,
        parentSku: parentSku,
        optionId: optionId,
        name: name,
        optionTypeId: optionTypeId);
    if (res) {
      flag = true;
      //refreshData
    } else {
      flag = false;
    }
    return flag;
  }

  Future<bool> removeFromCart(BuildContext context,
      {required String sku,
      required int cartItemId,
      String? name,
      bool refreshData = false}) async {
    bool flag = false;
    try {
      updateCartLoaderState(true);
      bool res = await CartRepo.removeFromCart(cartItemId, sku, name: name);
      if (res) {
        flag = true;
        if (refreshData) await getCartDataList(enableLoader: false);
        updateCartLoaderState(false);
      } else {
        flag = false;
        updateCartLoaderState(false);
      }
    } catch (_) {
      updateCartLoaderState(false);
    }
    return flag;
  }

  Future<bool> moveToWishList(BuildContext context,
      {required String sku,
      required int cartItemId,
      String? name,
      bool refreshData = false}) async {
    bool flag = false;
    try {
      updateCartLoaderState(true);
      bool res = await CartRepo.removeFromCart(cartItemId, sku, name: name);
      if (res) {
        await WishListRepo.addToWishList(sku, name: name);
        if (refreshData) await getCartDataList(enableLoader: false);
        flag = true;
        updateCartLoaderState(false);
      } else {
        flag = false;
        updateCartLoaderState(false);
      }
    } catch (_) {
      updateCartLoaderState(false);
    }
    return flag;
  }

  Future<String> addCouponToCart(String couponCode) async {
    String resText = '';
    try {
      updateCouponLoader(true);
      var resp = await serviceConfig.addCouponToCart(couponCode);
      if (resp != null && resp is ApiExceptions) {
        resText = Constants.noInternet;
        updateCouponLoader(false);
      } else if (resp?['applyCouponToCart'] != null &&
          resp?['applyCouponToCart']?['cart'] != null) {
        await getCartDataList(enableLoader: false);
        isCouponApplied = true;
        updateCouponLoader(false);
        resText = '$couponCode ${Constants.couponAppliedToCart}';
      } else {
        await CommonFunctions.checkException(resp, enableToast: false);
        ErrorModel errorModel = ErrorModel.fromJson(resp);
        if (errorModel.error != null) {
          resText = errorModel.message ?? '';
        }
        updateCouponLoader(false);
      }
    } catch (_) {
      updateCouponLoader(false);
    }
    return resText;
  }

  Future<String> removeCouponFromCart(String couponCode) async {
    String resText = '';
    try {
      updateCouponLoader(true);
      var resp = await serviceConfig.removeCouponFromCart();
      if (resp != null && resp is ApiExceptions) {
        resText = Constants.noInternet;
        updateCouponLoader(false);
      } else if (resp?['removeCouponFromCart'] != null &&
          resp?['removeCouponFromCart']?['cart'] != null) {
        await getCartDataList(enableLoader: false);
        isCouponApplied = false;
        updateCouponLoader(false);
        resText = '$couponCode ${Constants.couponRemovedFromCart}';
      } else {
        await CommonFunctions.checkException(resp);
        ErrorModel errorModel = ErrorModel.fromJson(resp);
        if (errorModel.error != null) {
          resText = errorModel.message ?? '';
        }
        updateCouponLoader(false);
      }
    } catch (_) {
      updateCouponLoader(false);
    }
    return resText;
  }

  Future<bool> updateCartItem(
      {required String sku,
      required int cartItemId,
      required int qty,
      int? optionId,
      int? optionTypeId,
      bool refreshData = false}) async {
    bool flag = false;
    try {
      updateCartLoaderState(true);
      bool res = await CartRepo.updateCartItem(
          cartItemId: cartItemId,
          sku: sku,
          qty: qty,
          optionId: optionId,
          optionTypeId: optionTypeId);
      if (res) {
        flag = true;
        if (refreshData) await getCartDataList(enableLoader: false);
        updateCartLoaderState(false);
      } else {
        flag = false;
        updateCartLoaderState(false);
      }
    } catch (_) {
      flag = false;
      updateCartLoaderState(false);
    }
    return flag;
  }

  Future<bool> removeOptionItemFromCart(
      {required String sku,
      required int cartItemId,
      required int qty,
      required int optionTypeId,
      bool refreshData = false}) async {
    bool flag = false;
    try {
      updateCartLoaderState(true);
      bool res = await CartRepo.removeOptionItemFromCart(
          cartItemId: cartItemId,
          sku: sku,
          qty: qty,
          optionTypeId: optionTypeId);
      if (res) {
        flag = true;
        if (refreshData) await getCartDataList(enableLoader: false);
        updateCartLoaderState(false);
      } else {
        flag = false;
        updateCartLoaderState(false);
      }
    } catch (_) {
      flag = false;
      updateCartLoaderState(false);
    }
    return flag;
  }

  Future<void> restoreCustomerCart(
      {bool restoreCart = true, required Function onPop}) async {
    restoreCart ? updateRestoreCartLoader(true) : updateEmptyCartLoader(true);
    await CartRepo.restoreCustomerCart(restoreCart: restoreCart);
    restoreCart ? updateRestoreCartLoader(false) : updateEmptyCartLoader(false);
    onPop();
  }

  void updateCartDataModel(CartDataModel? model) {
    cartDataModel = model;
    notifyListeners();
  }

  void updateCouponLoader(bool loader) {
    couponLoader = loader;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateCartLoaderState(bool val) {
    cartLoaderState = val;
    notifyListeners();
  }

  void updateRestoreCartLoader(bool loaderState) {
    restoreCartLoader = loaderState;
    notifyListeners();
  }

  void updateEmptyCartLoader(bool loaderState) {
    emptyCartLoader = loaderState;
    notifyListeners();
  }

  @override
  void pageInit() {
    isCouponApplied = false;
    couponLoader = false;
    cartLoaderState = false;
    cartDataModel = null;
    restoreCartLoader = false;
    emptyCartLoader = false;
    notifyListeners();
  }
}
