import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/mobile_force_update_model.dart';
import 'package:oxygen/repositories/app_data_repo.dart';
import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/services/service_config.dart';

import '../common/common_function.dart';
import '../common/constants.dart';
import '../models/cart_data_model.dart';
import '../models/error_model.dart';
import '../models/restore_cart_model.dart';
import '../services/helpers.dart';
import '../services/hive_services.dart';

class CartRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();

  static Future<CartDataModel?> getCartProductSkuList() async {
    CartDataModel? model;
    try {
      dynamic resp = await _serviceConfig.getCartProductSkuList();
      if (resp != null && resp['cart'] != null) {
        model = CartDataModel.fromJson(resp['cart']);
      } else {
        await CommonFunctions.checkException(resp, enableToast: false,
            onCartIdExpired: (val) async {
          if (val) {}
        });
      }
    } catch (_) {
      dev.log("getCartProductSkuList");
    }
    return model;
  }

  static Future<bool> addSimpleProductToCart(String sku,
      {int qty = 1, int? optionId, int? optionTypeId, String? name}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.addSimpleProductToCart(sku,
          qty: qty, optionId: optionId, optionTypeId: optionTypeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp?['addSimpleProductsToCart'] != null &&
          resp?['addSimpleProductsToCart']?['cart'] != null) {
        CartDataModel cartDataModel =
            CartDataModel.fromJson(resp?['addSimpleProductsToCart']?['cart']);
        if (cartDataModel.cartItems.notEmpty) {
          CartItems? item = cartDataModel.cartItems!.firstWhere(
              (CartItems? element) => element?.cartProduct?.sku == sku);
          if (item.cartItemId != null) {
            await HiveServices.instance.addToCartLocal(sku,
                cartItemId: item.cartItemId,
                qty: qty,
                optionTypeId: optionTypeId);
          }
          FirebaseAnalyticsService.instance
              .logProductToCart(qty: qty, itemId: sku, name: name);
        }
        flag = true;
      } else {
        await CommonFunctions.checkException(resp);
        flag = false;
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> addConfigurableProductToCart(
      {required String sku,
      required String parentSku,
      int qty = 1,
      int? optionId,
      int? optionTypeId,
      String? name}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.addConfigurableToCart(
          sku: sku,
          qty: qty,
          parentSku: parentSku,
          optionId: optionId,
          optionTypeId: optionTypeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp?['addConfigurableProductsToCart'] != null &&
          resp?['addConfigurableProductsToCart']?['cart'] != null) {
        CartDataModel cartDataModel = CartDataModel.fromJson(
            resp?['addConfigurableProductsToCart']?['cart']);
        if (cartDataModel.cartItems.notEmpty) {
          CartItems? item = cartDataModel.cartItems!.firstWhere(
              (CartItems? element) =>
                  (element?.variationData?.sku ?? element?.cartProduct?.sku) ==
                  sku);
          if (item.cartItemId != null) {
            await HiveServices.instance.addToCartLocal(sku,
                cartItemId: item.cartItemId,
                qty: qty,
                optionTypeId: optionTypeId);
          }
          FirebaseAnalyticsService.instance
              .logProductToCart(qty: qty, itemId: sku, name: name);
        }
        flag = true;
      } else {
        await CommonFunctions.checkException(resp);
        flag = false;
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> removeFromCart(int cartItemId, String sku,
      {required String? name}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.removeFromCart(cartItemId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp?['removeItemFromCart'] != null &&
          resp?['removeItemFromCart']?['cart'] != null) {
        await HiveServices.instance.removeFromCartLocal(sku);
        // if (refreshData) await getWishListProducts(enableLoader: false);
        FirebaseAnalyticsService.instance
            .logRemoveFromCart(qty: 1, itemId: sku, name: name);
        flag = true;
      } else {
        await CommonFunctions.checkException(resp);
        flag = false;
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> updateCartItem(
      {required int cartItemId,
      required String sku,
      required int qty,
      int? optionId,
      int? optionTypeId}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.updateCartItem(cartItemId, qty,
          optionId: optionId, optionTypeId: optionTypeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp?['updateCartItems'] != null &&
          resp?['updateCartItems']?['cart'] != null) {
        await HiveServices.instance.addToCartLocal(sku,
            cartItemId: cartItemId, qty: qty, optionTypeId: optionTypeId);
        flag = true;
      } else {
        await CommonFunctions.checkException(resp);
        flag = false;
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> removeOptionItemFromCart(
      {required String sku,
      required int qty,
      required int cartItemId,
      required int optionTypeId}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.removeOptionItemFromCart(
          cartItemId, optionTypeId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp?['removeOptionItemFromCart'] != null &&
          resp?['removeOptionItemFromCart']) {
        await HiveServices.instance.addToCartLocal(sku,
            cartItemId: cartItemId, qty: qty, removeOptionId: true);
        flag = true;
      } else {
        await CommonFunctions.checkException(resp);
        flag = false;
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> restoreCustomerCart({bool restoreCart = true}) async {
    bool resFlag = false;
    try {
      var resp = await _serviceConfig.restoreCustomerCart(restoreCart);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        resFlag = false;
      } else {
        if (resp['restoreAction'] != null) {
          await AppDataRepo.getAppData();
          resFlag = true;
        } else {
          await AppDataRepo.getAppData();
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            resFlag = false;
          }
        }
      }
    } catch (e) {
      resFlag = false;
    }
    return resFlag;
  }

  static Future<RestoreCartModel?> checkRestoreCart() async {
    RestoreCartModel? restoreCartModel;
    try {
      var resp = await _serviceConfig.checkRestoreCart();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['customer'] != null) {
          restoreCartModel = RestoreCartModel.fromJson(resp);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return restoreCartModel;
  }

  static Future<MobileForceUpdate?> getForceUpdateData() async {
    MobileForceUpdate? mobileForceUpdate;
    try {
      var resp = await _serviceConfig.getForceUpdateData();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['mobileForceUpdate'] != null) {
          mobileForceUpdate =
              MobileForceUpdate.fromJson(resp['mobileForceUpdate']);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return mobileForceUpdate;
  }
}
