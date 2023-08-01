import 'dart:developer' as dev;

import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/services/service_config.dart';

import '../common/common_function.dart';
import '../common/constants.dart';
import '../models/wish_list_data_model.dart';
import '../services/helpers.dart';
import '../services/hive_services.dart';

class WishListRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();

  static Future<WishListDataModel?> getWishListProductSkuList() async {
    WishListDataModel? model;
    try {
      dynamic resp = await _serviceConfig.getWishListProductSkuList();
      if (resp is! ApiExceptions && resp?['customer'] != null) {
        model = WishListDataModel.fromJson(resp['customer']);
      }
    } catch (_) {
      dev.log("getWishListProductSkuList");
    }
    return model;
  }

  static Future<bool> addToWishList(String sku, {String? name}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.addToWishList(sku);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else if (resp != null && resp?['saveWishlistItem']?['id'] != null) {
        int id = resp?['saveWishlistItem']?['id'];
        await HiveServices.instance.addToWishListLocal(sku, itemId: id);
        FirebaseAnalyticsService.instance
            .logProductToWishlist(qty: 1, itemId: sku, name: name);
        flag = true;
      } else {
        CommonFunctions.checkException(resp);
      }
    } catch (e) {
      flag = false;
    }

    return flag;
  }

  static Future<bool> removeFromWishList(
      {required int? itemId, required String sku}) async {
    bool flag = false;
    int? id = itemId;
    if (id == null) {
      WishListDataModel? model = await WishListRepo.getWishListProductSkuList();
      if (model?.wishlist?.items?.elementAt(0) != null) {
        int index = model!.wishlist!.items!
            .indexWhere((element) => element.product?.sku == sku);
        if (index != -1 && model.wishlist!.items![index].itemId != null) {
          id = model.wishlist!.items![index].itemId;
        }
      }
    }
    dynamic resp = await _serviceConfig.removeFromWishlist(id ?? -1);
    if (resp != null && resp is ApiExceptions) {
      Helpers.successToast(Constants.noInternet);
      flag = false;
    } else if (resp != null && (resp?['removeProductFromWishlist'] ?? false)) {
      await HiveServices.instance.removeFromWishListLocal(sku);
      flag = true;
    } else {
      CommonFunctions.checkException(resp, onError: (value) {
        if (value != null && value) {
          flag = false;
        }
      }, onAuthError: (value) {
        if (value) {
          flag = false;
        }
      });
    }
    return flag;
  }
}
