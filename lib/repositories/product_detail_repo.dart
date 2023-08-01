import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/cms_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/service_config.dart';

class ProductDetailRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();

  static Future<CmsItem?> getCmsBlocks(
      BuildContext context, String identifier) async {
    try {
      var resp = await _serviceConfig.getCmsBlocks(identifier: identifier);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        return null;
      } else {
        if (resp != null &&
            resp['cmsBlocks'] != null &&
            resp['cmsBlocks']["items"] != null) {
          List<CmsItem?>? items = resp['cmsBlocks']["items"] == null
              ? null
              : List<CmsItem?>.from(resp['cmsBlocks']["items"]
                  .map((x) => x != null ? CmsItem.fromJson(x) : null));
          return items?.first;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Item?> getItemByUrlKey(
      BuildContext context, String urlKey) async {
    try {
      var resp = await _serviceConfig.getItemByUrlKey(urlKey: urlKey);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        return null;
      } else {
        if (resp != null &&
            resp['products'] != null &&
            resp['products']['items'] != null) {
          List<Item?>? items = resp['products']["items"] == null
              ? null
              : List<Item?>.from(resp['products']["items"]
                  .map((x) => x != null ? Item.fromJson(x) : null));
          return items?.first;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> submitReview(
    BuildContext context, {
    required String sku,
    required String summary,
    String? text,
    required int ratingValue,
    String? nickName,
  }) async {
    try {
      context.circularLoaderPopUp;
      var resp = await _serviceConfig.submitReview(
        sku: sku,
        ratingValue: ratingValue,
        summary: summary,
        text: text,
        nickName: nickName,
      );
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        context.rootPop;
        return false;
      } else {
        if (resp != null &&
            resp["createProductReview"] != null &&
            resp["createProductReview"]["review"] != null) {
          context.rootPop;
          return true;
        } else {
          context.rootPop;
          return false;
        }
      }
    } catch (e) {
      context.rootPop;
      return false;
    }
  }

  static Future<String?> getStockNotification(BuildContext context,
      {String? email, int? id}) async {
    try {
      var resp = await _serviceConfig.getStockNotification(
          email: email ?? "", id: id ?? 0);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        return null;
      } else {
        if (resp != null &&
            resp["getStockNotificationAlertToEmail"] != null &&
            resp["getStockNotificationAlertToEmail"]) {
          return "Thank you. We will notify you once the product is available.";
        } else {
          return "This product already in alert section.";
        }
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> addToRecentlyViewed({int? productId}) async {
    try {
      await _serviceConfig
          .addToRecentlyViewed(productId: productId ?? 0)
          .then((value) {
        debugPrint(value.toString());
      });
    } catch (e) {
      //Handle Exception
    }
  }
}
