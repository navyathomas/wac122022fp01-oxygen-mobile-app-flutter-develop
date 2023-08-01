import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

class SharedPreferencesHelper {
  static const String authToken = "loginToken";
  static const String userEmail = "user_email";
  static const String userCartId = "user_cart_id";
  static const String userLocation = "user_location";
  static const String localLocale = "local_locale";
  static const String wishListId = "wish_list_id";
  static const String loginStatus = "login_status";
  static const String authCustomerDetails = "auth_customer_details";

  static Future<String> getHeaderToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(authToken);
    return stringValue != null && stringValue.isNotEmpty
        ? "Bearer $stringValue"
        : "";
  }

  static Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(authToken);
    return stringValue ?? "";
  }

  static Future<void> removeAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    AppConfig.accessToken = null;
    AppConfig.cartId = null;
    log("ALL LOCAL CREDENTIALS CLEARED");
  }

  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authToken, token);
    AppConfig.accessToken = "Bearer $token";
  }

  static Future<void> removeLoginToken() async {
    final prefs = await SharedPreferences.getInstance();
    AppConfig.accessToken = '';
    await prefs.remove(authToken);
  }

  static Future<void> saveLoginStatus(bool stat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginStatus, stat);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginStatus) ?? false;
  }

  static Future<void> saveWishListId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(wishListId, id);
  }

  static Future<int?> getWishListId() async {
    int? val;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(wishListId)) {
      val = prefs.getInt(wishListId)!;
    }
    return val;
  }

  static Future<void> removeWishListId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(wishListId)) {
      prefs.remove(wishListId);
    }
  }

  static Future<void> saveCartId(String? cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userCartId, cartId ?? '');
  }

  static Future<String> getCartId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userCartId) ?? '';
  }
}
