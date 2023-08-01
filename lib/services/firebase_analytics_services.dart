import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:oxygen/services/helpers.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalyticsService? _instance;

  static FirebaseAnalyticsService get instance {
    _instance ??= FirebaseAnalyticsService();
    return _instance!;
  }

  String currency = 'Rupee';

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver appAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> openApp() async {
    try {
      await _analytics.logAppOpen();
    } catch (_) {
      return;
    }
  }

  Future<void> logShareData({
    required String url,
  }) async {
    try {
      await _analytics.logEvent(name: 'share', parameters: {'url': url});
    } catch (_) {
      return;
    }
  }

  Future<void> loginUser(String loginMethod) async {
    try {
      _analytics.logAppOpen();
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logProductOpen(
      {required int? price,
      double? discount,
      int? qty,
      String? name,
      String? itemId}) async {
    try {
      _analytics.logViewItem(
          currency: currency,
          value: Helpers.convertToDouble(price),
          items: [
            AnalyticsEventItem(
                currency: currency,
                discount: discount,
                quantity: qty,
                itemName: name,
                itemId: itemId)
          ]);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logLoginMethod({required String loginMethod}) async {
    try {
      _analytics.logLogin(loginMethod: loginMethod);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logUserData(
      {required String name, required String loginValue}) async {
    try {
      _analytics.setUserProperty(name: name, value: loginValue);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logProductToCart(
      {int? qty, String? name, String? itemId}) async {
    try {
      _analytics.logAddToCart(currency: currency, items: [
        AnalyticsEventItem(
            currency: currency, quantity: qty, itemName: name, itemId: itemId)
      ]);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logProductToWishlist(
      {int? qty, String? name, String? itemId}) async {
    try {
      _analytics.logAddToWishlist(items: [
        AnalyticsEventItem(
            currency: currency, quantity: qty, itemName: name, itemId: itemId)
      ]);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logRemoveFromCart(
      {int? qty, String? name, String? itemId}) async {
    try {
      _analytics.logRemoveFromCart(items: [
        AnalyticsEventItem(quantity: qty, itemName: name, itemId: itemId)
      ]);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logSearchText({required String text}) async {
    try {
      _analytics.logSearch(searchTerm: text);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logBeginCheckOut({required double value, String? coupon}) async {
    try {
      _analytics.logBeginCheckout(
          value: value, currency: currency, coupon: coupon);
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }

  Future<void> logEcommercePurchase(
      {required double value,
      required String currency,
      String? transactionId}) async {
    try {
      _analytics.logPurchase(
        currency: currency,
        value: value,
      );
    } catch (e) {
      log(e.toString(), name: 'Firebase Analytics');
    }
  }
}
