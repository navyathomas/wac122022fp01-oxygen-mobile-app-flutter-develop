import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/repositories/authentication_repo.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/error_model.dart';
import '../models/local_products.dart';
import '../providers/wishlist_provider.dart';
import '../services/helpers.dart';

class CommonFunctions {
  static void afterInit(Function function) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      function();
    });
  }

  static Future<void> checkException(dynamic resp,
      {Function? noCustomer,
      Function? onError,
      Function? onCartIdExpired,
      Function(bool val)? onAuthError,
      bool enableToast = true}) async {
    ErrorModel errorModel = ErrorModel.fromJson(resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          if (enableToast) Helpers.successToast('${errorModel.message}');
          break;
        case 'graphql-authorization':
          if (AppConfig.isAuthorized) {
            if (onAuthError != null) {
              await AuthenticationRepo.validateRefreshToken();
              onAuthError(true);
            }
          } else {
            if (onAuthError != null) onAuthError(true);
          }
          break;
        case 'graphql-no-such-entity':
          if (!AppConfig.isAuthorized) await AuthenticationRepo.getEmptyCart();
          if (onCartIdExpired != null) onCartIdExpired(true);
          break;

        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            if (enableToast) Helpers.successToast('${errorModel.message}');
            if (onError != null) onError(true);
          }
      }
    } else {
      if (errorModel.error != null &&
          errorModel.error == 'error' &&
          errorModel.message != null) {
        if (enableToast) Helpers.successToast('${errorModel.message}');
        onError!(true);
      }
    }
  }

  static showDialogPopUp(BuildContext context, Widget dialogWidget,
      {bool barrierDismissible = true, String? routeName}) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      barrierLabel: "",
      routeSettings: routeName == null ? null : RouteSettings(name: routeName),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () async {
            return barrierDismissible;
          },
          child: Transform.scale(
            scale: curve,
            child: dialogWidget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Future<void> addToWishList(
    BuildContext context, {
    required Box<LocalProducts> box,
    required String sku,
    String? name,
  }) async {
    if (AppConfig.isAuthorized) {
      await context
          .read<WishListProvider>()
          .updateWishListByInput(context, box: box, sku: sku, name: name);
    } else {
      Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
              arguments: true)
          .then((value) async {
        if (AppConfig.isAuthorized) {
          await context
              .read<WishListProvider>()
              .updateWishListByInput(context, box: box, sku: sku);
        }
      });
    }
  }

  static Future<void> buyProduct(
      BuildContext context, ValueNotifier<bool> isLoading) async {
    final cartModel = context.read<CartProvider>();
    final productDetailModel = context.read<ProductDetailProvider>();

    addToCartAndPush() async {
      switch (productDetailModel.productType?.toLowerCase()) {
        case Constants.simpleProduct:
          {
            await cartModel
                .addToCart(context,
                    sku: productDetailModel.selectedItem?.sku ?? "",
                    qty: 1,
                    name: productDetailModel.selectedItem?.name)
                .then((_) async {
              isLoading.value = false;
              await context
                  .read<CartProvider>()
                  .getCartDataList(enableLoader: true);
              CommonFunctions.afterInit(() => Navigator.of(context)
                  .pushNamed(RouteGenerator.routeSelectAddressScreen));
            });
            break;
          }
        case Constants.configurableProduct:
          {
            await cartModel
                .addConfigurableToCart(context,
                    sku: productDetailModel.selectedItem?.sku ?? "",
                    parentSku: productDetailModel.parentSku ?? "",
                    qty: 1,
                    name: productDetailModel.selectedItem?.name)
                .then((_) async {
              isLoading.value = false;
              await context
                  .read<CartProvider>()
                  .getCartDataList(enableLoader: true);
              CommonFunctions.afterInit(() => Navigator.of(context)
                  .pushNamed(RouteGenerator.routeSelectAddressScreen));
            });
            break;
          }
      }
    }

    if (AppConfig.isAuthorized) {
      addToCartAndPush();
    } else {
      HiveServices.instance
          .saveNavPath(RouteGenerator.routeProductDetailScreen);
      Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
              arguments: true)
          .then((_) {
        isLoading.value = false;
        if (AppConfig.isAuthorized) {
          addToCartAndPush();
        }
      });
    }
  }

  static Future<void> openExternalUrl(String url) async {
    var fallbackUrl = AppConfig.baseUrl;

    try {
      bool launched = await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  static Future<int> getBuildVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;
    return Helpers.convertToInt(buildNumber);
  }

  static Future<void> launchAppStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      launchApp(Constants.playStoreURL + packageInfo.packageName);
    } else {
      launchApp(Constants.appleStoreURL + packageInfo.packageName);
    }
  }

  static Future<void> launchApp(String urls) async {
    final Uri url = Uri.parse(urls);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('$e');
    }
  }
}
