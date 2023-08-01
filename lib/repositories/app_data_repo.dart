import 'package:flutter/material.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/whatsapp_model.dart';
import 'package:oxygen/repositories/wishlist_repo.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/service_config.dart';

import '../models/cart_data_model.dart';
import '../models/wish_list_data_model.dart';
import 'cart_repo.dart';

class AppDataRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();

  static Future<void> getAppData() async {
    await getCartData();
    await getWishListData();
  }

  static Future<void> getCartData({bool clearData = true}) async {
    if (clearData) await HiveServices.instance.clearCartProductBox();
    CartDataModel? cartDataModel = await CartRepo.getCartProductSkuList();
    await _updateCartListData(cartDataModel);
  }

  static Future<void> getWishListData({bool clearData = true}) async {
    if (clearData) await HiveServices.instance.clearWishListProductBox();
    WishListDataModel? wishListDataModel =
        await WishListRepo.getWishListProductSkuList();
    await _updateWishListData(wishListDataModel);
  }

  static Future<void> _updateWishListData(
      WishListDataModel? wishListDataModel) async {
    List<WishListItems>? items = wishListDataModel?.wishlist?.items;
    if (items.notEmpty) {
      for (WishListItems item in items!) {
        await HiveServices.instance
            .addToWishListLocal(item.product?.sku ?? '', itemId: item.itemId);
      }
    }
  }

  static Future<void> _updateCartListData(CartDataModel? cartDataModel) async {
    List<CartItems>? cartItems = cartDataModel?.cartItems;
    if (cartItems.notEmpty) {
      for (CartItems item in cartItems!) {
        if ((item.childCustomizableOptions ?? []).isNotEmpty &&
            (item.childCustomizableOptions?.first.values ?? []).isNotEmpty) {
          await HiveServices.instance.addToCartLocal(
              item.variationData?.sku ?? item.cartProduct?.sku ?? '',
              cartItemId: item.cartItemId,
              qty: item.quantity,
              optionTypeId:
                  item.childCustomizableOptions!.first.values!.first.value);
          continue;
        }
        if ((item.simpleAddonOptions ?? []).isNotEmpty &&
            (item.simpleAddonOptions?.first.values ?? []).isNotEmpty) {
          await HiveServices.instance.addToCartLocal(
              item.variationData?.sku ?? item.cartProduct?.sku ?? '',
              cartItemId: item.cartItemId,
              qty: item.quantity,
              optionTypeId: item.simpleAddonOptions!.first.values!.first.value);
          continue;
        }
        await HiveServices.instance.addToCartLocal(
          item.variationData?.sku ?? item.cartProduct?.sku ?? '',
          cartItemId: item.cartItemId,
          qty: item.quantity,
        );
      }
    }
  }

  static Future<WhatsappModel?> getWhatsappChatConfiguration() async {
    try {
      var resp = await _serviceConfig.getWhatsappChatConfiguration();
      if (resp['whatsappConfigurationStatus'] != null) {
        return WhatsappModel.fromJson(resp['whatsappConfigurationStatus']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
