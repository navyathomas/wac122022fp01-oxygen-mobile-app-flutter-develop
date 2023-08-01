import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseDynamicLinkServices {
  static FirebaseDynamicLinkServices? _instance;

  static FirebaseDynamicLinkServices get instance {
    _instance ??= FirebaseDynamicLinkServices();
    return _instance!;
  }

  String getExtensionFromUrl(String url) =>
      url.split('.html').first.replaceAll(RegExp("/"), '');

  void navToItemByUrlKey(BuildContext context, {String? urlKey}) async {
    final item = await ProductDetailRepo.getItemByUrlKey(context, urlKey ?? "");
    if (item?.sku != null) {
      CommonFunctions.afterInit(() {
        NavRoutes.instance.navToProductDetailScreen(context,
            sku: item?.sku, isFromInitialState: true);
      });
    }
  }

  Future<String> createDynamicLink(
      {String? sku,
      String? name,
      BuildContext? context,
      String? image,
      String? url}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
          description: 'Check this out $name on Oxygen Digital',
          imageUrl: Uri.parse(image ?? "")),
      uriPrefix: 'https://oxygendigitalshop.page.link',
      link: Uri.parse('${AppConfig.baseUrl}$url.html'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: packageInfo.version,
        appStoreId: '',
      ),
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
        parameters,
        shortLinkType: ShortDynamicLinkType.unguessable);

    return '${dynamicLink.shortUrl}';
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;

      final urlKey = getExtensionFromUrl(deepLink.path);

      navToItemByUrlKey(context, urlKey: urlKey);
    }, onDone: () {}).onError(
      (error) {
        // Handle Errors
      },
    );

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      final urlKey = getExtensionFromUrl(deepLink.path);
      CommonFunctions.afterInit(() {
        navToItemByUrlKey(context, urlKey: urlKey);
      });
    }
  }
}
