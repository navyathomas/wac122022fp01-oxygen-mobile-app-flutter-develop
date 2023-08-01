import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/models/local_products.dart';

class HiveServices {
  static HiveServices? _instance;
  final String cartBoxName = 'cart_box';
  final String wishlistBoxName = 'wishlist_box';
  final String generalBoxName = 'general_box_name';
  final String authUserData = 'auth_user_data';
  final String recentSearchBox = 'recent_search_box';
  final String compareProductBoxName = 'compare_products';
  final String _pinCode = "pinCode";

  static HiveServices get instance {
    _instance ??= HiveServices();
    return _instance!;
  }

  late final Box<LocalProducts> cartProductBox;
  late final Box<LocalProducts> wishlistProductBox;
  late final Box<CompareProducts> compareProductsBox;
  late final Box generalBox;
  late final Box<AuthCustomer> customerBox;
  late final Box recentlySearchedBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<LocalProducts>(LocalProductsAdapter());
    Hive.registerAdapter<AuthCustomer>(AuthCustomerAdapter());
    Hive.registerAdapter<CompareProducts>(CompareProductsAdapter());
    generalBox = await Hive.openBox(generalBoxName);
    cartProductBox = await Hive.openBox<LocalProducts>(cartBoxName);
    wishlistProductBox = await Hive.openBox<LocalProducts>(wishlistBoxName);
    customerBox = await Hive.openBox<AuthCustomer>(authUserData);
    compareProductsBox =
        await Hive.openBox<CompareProducts>(compareProductBoxName);
    recentlySearchedBox = await Hive.openBox(recentSearchBox);
  }

  Future<void> saveNotificationCount(int count) async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    await generalBox.put('notificationCount', count);
  }

  Future<int?> getNotificationCount() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    return await generalBox.get('notificationCount');
  }

  Future<void> saveUserData(AuthCustomer? authCustomer) async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    await generalBox.put(authUserData, authCustomer);
  }

  Future<AuthCustomer?> getUserData() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    return generalBox.get(authUserData);
  }

  Future<void> addToCartLocal(String sku,
      {required int? cartItemId,
      int? qty,
      int? optionTypeId,
      bool removeOptionId = false}) async {
    if (!Hive.isBoxOpen(cartBoxName)) {
      cartProductBox = await Hive.openBox<LocalProducts>(cartBoxName);
    }
    if (cartProductBox.containsKey(sku)) {
      LocalProducts localTempProducts =
          cartProductBox.get(sku) ?? LocalProducts();
      int? cartOptionId = localTempProducts.cartPlanId ?? optionTypeId;
      LocalProducts localProducts = LocalProducts()
        ..quantity = qty ?? (localTempProducts.quantity + 1)
        ..sku = sku
        ..cartPlanId = removeOptionId ? null : cartOptionId
        ..cartItemId = cartItemId;
      cartProductBox.put(sku, localProducts);
    } else {
      LocalProducts localProducts = LocalProducts()
        ..quantity = qty ?? 1
        ..cartItemId = cartItemId
        ..cartPlanId = optionTypeId
        ..sku = sku;
      cartProductBox.put(sku, localProducts);
    }
  }

  Future<void> addProductsToCompareLocal(
      {String? name,
      String? imageUrl,
      String? productId,
      int? index,
      int? productTypeSet}) async {
    if (!Hive.isBoxOpen(compareProductBoxName)) {
      compareProductsBox =
          await Hive.openBox<CompareProducts>(compareProductBoxName);
      if (!compareProductsBox.containsKey(productId)) {
        CompareProducts compareProducts = CompareProducts()
          ..name = name ?? ''
          ..imageUrl = imageUrl ?? ''
          ..itemIndex = index ?? 0
          ..productId = productId
          ..productTypeSet = productTypeSet ?? 0;

        compareProductsBox.put(productId, compareProducts);
      }
    } else {
      if (!compareProductsBox.containsKey(productId)) {
        CompareProducts compareProducts = CompareProducts()
          ..name = name ?? ''
          ..imageUrl = imageUrl ?? ''
          ..itemIndex = index ?? 0
          ..productId = productId
          ..productTypeSet = productTypeSet;
        compareProductsBox.put(productId, compareProducts);
      }
    }
  }

  Future<LocalProducts?> getCartLocalProductBySku(String sku) async {
    if (!Hive.isBoxOpen(cartBoxName)) {
      cartProductBox = await Hive.openBox<LocalProducts>(cartBoxName);
    }
    return cartProductBox.get(sku);
  }

  Future getComparedProductsLocalValues() async {
    if (!Hive.isBoxOpen(compareProductBoxName)) {
      compareProductsBox =
          await Hive.openBox<CompareProducts>(compareProductBoxName);
    }
    return compareProductsBox.values.toList();
  }

  Future<CompareProducts?> getComparedProductsLocal(String productId) async {
    if (!Hive.isBoxOpen(compareProductBoxName)) {
      compareProductsBox =
          await Hive.openBox<CompareProducts>(compareProductBoxName);
    }

    return compareProductsBox.get(productId);
  }

  Future<LocalProducts?> getWishListLocalProductBySku(String sku) async {
    if (!Hive.isBoxOpen(wishlistBoxName)) {
      wishlistProductBox = await Hive.openBox<LocalProducts>(wishlistBoxName);
    }
    return wishlistProductBox.get(sku);
  }

  Future<void> removeFromCartLocal(String sku) async {
    if (!Hive.isBoxOpen(cartBoxName)) {
      cartProductBox = await Hive.openBox<LocalProducts>(cartBoxName);
    }
    if (cartProductBox.containsKey(sku)) {
      cartProductBox.delete(sku);
    }
  }

  Future<void> addToWishListLocal(String sku, {required int? itemId}) async {
    if (!Hive.isBoxOpen(wishlistBoxName)) {
      wishlistProductBox = await Hive.openBox<LocalProducts>(wishlistBoxName);
    }
    LocalProducts localProducts = LocalProducts()
      ..isFavourite = true
      ..sku = sku
      ..itemId = itemId;
    wishlistProductBox.put(sku, localProducts);
  }

  Future<void> removeFromWishListLocal(String sku) async {
    if (!Hive.isBoxOpen(wishlistBoxName)) {
      wishlistProductBox = await Hive.openBox<LocalProducts>(wishlistBoxName);
    }
    if (wishlistProductBox.containsKey(sku)) {
      wishlistProductBox.delete(sku);
    }
  }

  Future<void> removeFromCompareListLocal(String id) async {
    if (!Hive.isBoxOpen(compareProductBoxName)) {
      compareProductsBox =
          await Hive.openBox<CompareProducts>(compareProductBoxName);
    }
    if (compareProductsBox.containsKey(id)) {
      compareProductsBox.delete(id);
    }
  }

  Future<void> clearCompareProducts() async {
    if (compareProductsBox.isOpen) await compareProductsBox.clear();
  }

  Future<void> clearLocalProductBox() async {
    await clearCartProductBox();
    await clearWishListProductBox();
  }

  Future<void> clearCartProductBox() async {
    if (cartProductBox.isOpen) await cartProductBox.clear();
  }

  Future<void> clearWishListProductBox() async {
    if (wishlistProductBox.isOpen) await wishlistProductBox.clear();
  }

  Future<void> clearBoxData() async {
    if (cartProductBox.isOpen) await cartProductBox.clear();
    if (wishlistProductBox.isOpen) await wishlistProductBox.clear();
    if (generalBox.isOpen) await generalBox.clear();
    if (compareProductsBox.isOpen) await compareProductsBox.clear();
  }

  Future<void> openBoxes() async {
    if (!cartProductBox.isOpen) {
      cartProductBox = await Hive.openBox<LocalProducts>(cartBoxName);
    }
    if (!wishlistProductBox.isOpen) {
      wishlistProductBox = await Hive.openBox<LocalProducts>(wishlistBoxName);
    }
    if (!generalBox.isOpen) generalBox = await Hive.openBox(generalBoxName);
  }

  Future<void> closeBoxes() async {
    if (cartProductBox.isOpen) await cartProductBox.close();
    if (wishlistProductBox.isOpen) await wishlistProductBox.close();
    if (generalBox.isOpen) await generalBox.close();
  }

  Future<void> savePinCode(
      {String? pinCode, bool? status, String? message}) async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    Map<String, dynamic> pinCodeMap = {
      "code": pinCode,
      "status": status,
      "message": message,
    };
    await generalBox.put(_pinCode, pinCodeMap);
  }

  Future<Map<dynamic, dynamic>?> getPinCode() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    return await generalBox.get(_pinCode);
  }

  Future<void> clearPinCode() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    generalBox.delete(_pinCode);
  }

  Future<void> saveNavPath(String path) async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    generalBox.put("auth_nav_path", path);
  }

  Future<String?> getNavPath() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    return generalBox.get("auth_nav_path");
  }

  Future<void> saveNavArgs(int arguments) async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    generalBox.put("auth_nav_path", '');
    generalBox.put("auth_nav_args", arguments);
  }

  Future<int> getNavArgs() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    return generalBox.get("auth_nav_args") ?? 0;
  }

  Future<void> deleteNavPath() async {
    if (!Hive.isBoxOpen(generalBoxName)) {
      generalBox = await Hive.openBox(generalBoxName);
    }
    generalBox.delete('auth_nav_path');
    generalBox.delete('auth_nav_args');
  }

  Future<void> addRecentlySearchedKeys(val, sku) async {
    if (!Hive.isBoxOpen(recentSearchBox)) {
      recentlySearchedBox = await Hive.openBox<dynamic>(recentSearchBox);
    }
    recentlySearchedBox.add(val);
  }

  Future<List<dynamic>> getRecentlySearchedKeys() async {
    dynamic res;
    dynamic reversedList;
    if (!Hive.isBoxOpen(recentSearchBox)) {
      recentlySearchedBox = await Hive.openBox<dynamic>(recentSearchBox);
    }
    res = recentlySearchedBox.values.toList();
    reversedList = res.reversed.toList();
    return reversedList;
  }

  Future<void> deleteItemFromRecentlySearchedList(String value) async {
    dynamic res;
    if (!Hive.isBoxOpen(recentSearchBox)) {
      recentlySearchedBox = await Hive.openBox<dynamic>(recentSearchBox);
    }
    res = recentlySearchedBox.values.toList();
    for (int i = 0; i < res.length; i++) {
      if (res[i] == value) {
        recentlySearchedBox.deleteAt(i);
      }
    }
  }

  Future<void> clearRecentlySearchedList() async {
    if (recentlySearchedBox.isOpen) await recentlySearchedBox.clear();
  }

  Future<void> closeRecentlySearchedBox() async {
    if (Hive.isBoxOpen(recentSearchBox)) {
      Box<dynamic> box = Hive.box(recentSearchBox);
      box.close();
    } else {
      Box<dynamic> box = await Hive.openBox<dynamic>(recentSearchBox);
      box.close();
    }
  }
}
