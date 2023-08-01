import 'dart:developer' as devTool;

import 'package:flutter/material.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/service_config.dart';
import 'package:oxygen/services/shared_preference_helper.dart';

import '../common/common_function.dart';
import '../common/constants.dart';
import '../models/auth_data_model.dart';
import '../services/app_config.dart';
import '../services/helpers.dart';

class AuthenticationRepo {
  static final ServiceConfig serviceConfig = ServiceConfig();

  static Future<String> getEmptyCart({bool enableToast = false}) async {
    String emptyCartId = '';
    try {
      await SharedPreferencesHelper.removeLoginToken();
      var resp = await serviceConfig.createEmptyCart();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        await setCartId('');
      } else {
        if (resp?['createEmptyCart'] != null) {
          emptyCartId = resp?['createEmptyCart'];
          await setCartId(emptyCartId);
          emptyCartId.log(name: 'Empty cart id');
          return emptyCartId;
        } else {
          await CommonFunctions.checkException(resp, enableToast: enableToast);
          await setCartId('');
        }
      }
    } catch (e) {
      await setCartId('');
      'Create empty cart $e'.log(name: 'AuthProvider');
    }
    return emptyCartId;
  }

  static Future<String> createCustomerCart({bool cacheCart = false}) async {
    String customerCartId = '';
    try {
      var resp = await serviceConfig.createCustomerCart();
      debugPrint(resp.toString());
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp?['customerCart'] != null) {
          customerCartId = resp['customerCart']?['id'] ?? '';
          customerCartId.log(name: 'customer cart id');
          if (cacheCart) await setCartId(customerCartId);
          return customerCartId;
        } else {
          await CommonFunctions.checkException(resp);
        }
      }
    } catch (e) {
      'Create customer cart $e'.log(name: 'AuthProvider');
    }
    return customerCartId;
  }

  static Future<String> mergeCartId(String emptyCartId) async {
    String mergeCartId = '';
    try {
      String customerId = await createCustomerCart();
      if (customerId.isNotEmpty) {
        var resp = await serviceConfig.mergeCartId(emptyCartId, customerId);
        if (resp != null && resp is ApiExceptions) {
          Helpers.successToast(Constants.noInternet);
        } else {
          if (resp?['mergeCarts'] != null) {
            mergeCartId = resp['mergeCarts']?['id'] ?? '';

            await setCartId(mergeCartId);
            mergeCartId.log(name: 'merge cart id');
            return mergeCartId;
          } else {
            await CommonFunctions.checkException(resp);
          }
        }
      } else {
        return mergeCartId;
      }
    } catch (e) {
      'Merge customer cart $e'.log(name: 'AuthProvider');
    }
    return mergeCartId;
  }

  static Future<String> checkRefreshToken(String token) async {
    String tokenId = '';
    try {
      final resp = await serviceConfig.checkRefreshToken(token);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        final response = resp['checkCustomerTokenValidV2'];
        if (response?['refresh_token_id'] != null &&
            (response?['status'] ?? true) == false) {
          tokenId = response?['refresh_token_id'];
        }
      }
    } catch (_) {
      tokenId = '';
    }
    return tokenId;
  }

  static Future<String?> refreshToken(String tokenId, String email) async {
    try {
      final resp = await serviceConfig.refreshToken(tokenId, email);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['customerRefreshToken'] != null) {
          await SharedPreferencesHelper.saveUserToken(
              resp['customerRefreshToken']);
          return resp['customerRefreshToken'];
        }
      }
    } catch (e) {
      '$e'.log();
    }
    return null;
  }

  static Future<void> validateRefreshToken() async {
    String token = await SharedPreferencesHelper.getAuthToken();
    String tokenStat = await checkRefreshToken(token);
    if (tokenStat.isNotEmpty) {
      AuthCustomer? customer = await HiveServices.instance.getUserData();
      if ((customer?.email ?? '').isEmpty) {
        await SharedPreferencesHelper.removeAllTokens();
        await getEmptyCart();
      } else {
        String? token = await refreshToken(tokenStat, customer?.email ?? '');
        if ((token ?? '').isEmpty) {
          await SharedPreferencesHelper.removeAllTokens();
          await getEmptyCart();
        } else {
          await createCustomerCart(cacheCart: true);
        }
      }
    } else {
      await createCustomerCart(cacheCart: true);
    }
  }

  static Future<void> setCartId(val, {bool save = true}) async {
    AppConfig.cartId = val;
    if (save) await SharedPreferencesHelper.saveCartId(val);
  }

  static Future<bool> logoutUser() async {
    bool resFlag = false;
    try {
      final resp = await serviceConfig.revokeCustomerToken();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['revokeCustomerToken'] == null ||
            (resp['revokeCustomerToken']['result'] ?? false) == false) {
          CommonFunctions.checkException(resp, enableToast: false);
          resFlag = true;
        } else {
          resFlag = true;
        }
      }
    } catch (e) {
      resFlag = true;
      devTool.log("Logout error $e");
    }
    return resFlag;
  }
}
