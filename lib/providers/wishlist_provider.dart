import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/repositories/cart_repo.dart';
import 'package:oxygen/services/hive_services.dart';

import '../models/cart_data_model.dart';
import '../models/local_products.dart';
import '../models/wish_list_data_model.dart';
import '../repositories/wishlist_repo.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import '../services/service_config.dart';

class WishListProvider extends ChangeNotifier with ProviderHelperClass {
  WishListDataModel? wishListDataModel;
  int pageCount = 1;
  int totalPageLength = 0;
  bool paginationLoader = false;
  List<WishListItems>? wishListItems;

  Future<WishListDataModel?> getWishListProducts(
      {bool enableLoader = true, Function(bool)? onAuthError}) async {
    WishListDataModel? model;
    if (enableLoader) updateLoadState(LoaderState.loading);
    try {
      dynamic resp = await serviceConfig.getWishListProduct();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else if (resp != null && resp?['customer'] != null) {
        model = WishListDataModel.fromJson(resp['customer']);
        if ((model.wishlist?.items ?? []).isEmpty) {
          updateLoadState(LoaderState.noData);
        } else {
          updateWishListData(model);
          updateLoadState(LoaderState.loaded);
        }
      } else {
        await CommonFunctions.checkException(resp, enableToast: false,
            onAuthError: (val) {
          Helpers.successToast(Constants.userNotAuthorized);
          if (onAuthError != null) onAuthError(val);
        });
        updateWishListData(null);
        updateLoadState(LoaderState.error);
      }
    } catch (_) {
      updateLoadState(LoaderState.error);
      log("getWishListProduct");
    }
    return model;
  }

  Future<bool> updateWishListByInput(BuildContext context,
      {required Box<LocalProducts> box,
      required String sku,
      String? name,
      bool refreshData = false}) async {
    if (box.get(sku)?.isFavourite ?? false) {
      return await removeFromWishList(itemId: box.get(sku)?.itemId, sku: sku);
    } else {
      return addToWishList(sku: sku, name: name);
    }
  }

  Future<bool> addToWishList(
      {required String sku, bool refreshData = false, String? name}) async {
    bool flag = false;
    updateBtnLoaderState(true);
    bool res = await WishListRepo.addToWishList(sku, name: name);
    if (res) {
      if (refreshData) await getWishListProducts(enableLoader: false);
      flag = true;
      updateBtnLoaderState(false);
    } else {
      updateBtnLoaderState(false);
    }
    return flag;
  }

  Future<bool> removeFromWishList(
      {required int? itemId,
      required String sku,
      bool refreshData = false}) async {
    bool flag = false;
    updateBtnLoaderState(true);
    try {
      bool res =
          await WishListRepo.removeFromWishList(itemId: itemId, sku: sku);
      if (res) {
        if (refreshData) await getWishListProducts(enableLoader: false);
        flag = true;
        updateBtnLoaderState(false);
      } else {
        updateBtnLoaderState(false);
      }
    } catch (_) {
      flag = false;
      updateBtnLoaderState(false);
    }
    return flag;
  }

  Future<bool> moveFromMyItem(
      {required String sku, required int? itemId}) async {
    bool flag = false;
    try {
      updateBtnLoaderState(true);
      bool cartRes = await CartRepo.addSimpleProductToCart(sku);
      if (cartRes) {
        bool res =
            await WishListRepo.removeFromWishList(itemId: itemId, sku: sku);
        if (res) {
          await getWishListProducts(enableLoader: false);
          flag = true;
          updateBtnLoaderState(false);
        } else {
          updateBtnLoaderState(false);
        }
      } else {
        bool res =
            await WishListRepo.removeFromWishList(itemId: itemId, sku: sku);
        if (res) {
          await getWishListProducts(enableLoader: false);
          flag = true;
          updateBtnLoaderState(false);
        } else {
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateBtnLoaderState(false);
      flag = false;
    }
    return flag;
  }

  Future<bool> restoreProduct(
      {required String sku, required int? itemId, String? name}) async {
    bool flag = false;
    updateBtnLoaderState(true);
    try {
      LocalProducts? localProducts =
          await HiveServices.instance.getCartLocalProductBySku(sku);
      if (localProducts?.cartItemId != null) {
        flag =
            await _restoreProduct(localProducts!.cartItemId!, sku, name: name);
        updateBtnLoaderState(false);
      } else {
        CartDataModel? cartDataModel = await CartRepo.getCartProductSkuList();
        if (cartDataModel?.cartItems?.elementAt(0) != null) {
          CartItems? item = cartDataModel!.cartItems!.firstWhere(
              (CartItems? element) => element?.cartProduct?.sku == sku);
          if (item.cartItemId != null) {
            flag = await _restoreProduct(localProducts!.cartItemId!, sku,
                name: name);
            updateBtnLoaderState(false);
          } else {
            updateBtnLoaderState(false);
          }
        } else {
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateBtnLoaderState(false);
      flag = false;
    }
    return flag;
  }

  Future<bool> _restoreProduct(int cartItemId, String sku,
      {String? name}) async {
    bool flag = false;
    bool cartRes = await CartRepo.removeFromCart(cartItemId, sku, name: name);
    if (cartRes) {
      bool res = await WishListRepo.addToWishList(sku, name: name);
      if (res) {
        await getWishListProducts(enableLoader: false);
        flag = true;
      }
    } else {
      bool res = await WishListRepo.addToWishList(sku);
      if (res) {
        await getWishListProducts(enableLoader: false);
        flag = true;
      }
    }
    return flag;
  }

  void updateWishListData(WishListDataModel? model) {
    wishListDataModel = model;
    if (pageCount == 1) {
      wishListItems = model?.wishlist?.items;
    } else {
      List<WishListItems> tempWishList = [...?wishListItems];
      wishListItems = [...tempWishList, ...?model?.wishlist?.items];
    }
    notifyListeners();
  }

/*  void paginateToNext(ScrollController scrollController) {
    if (scrollController.position.pixels.toInt() >=
        scrollController.position.maxScrollExtent ~/ 1.3) {
      if (wishListDataModel?.totalCount != null &&
          (pageCount * 10) < productsListModel!.totalCount! &&
          pageLoadState != LoadState.loading) {
        updatePageCount();
        updatePaginationLoader(true);
        getProductListData();
      }
    }
  }*/

  void initData({LoaderState? state}) {
    wishListDataModel = null;
    btnLoaderState = false;
    pageCount = 1;
    totalPageLength = 0;
    loaderState = state ?? LoaderState.loaded;
    paginationLoader = false;
    wishListItems = null;
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoader = val;
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
