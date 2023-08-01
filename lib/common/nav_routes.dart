import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/category_detailed_arguments.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/models/home_data_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/services/helpers.dart';

import '../models/arguments/product_listing_arguments.dart';

class NavRoutes {
  static NavRoutes? _instance;

  static NavRoutes get instance {
    _instance ??= NavRoutes();
    return _instance!;
  }

  Future<void> popUntil(BuildContext context, String routeName) async {
    Navigator.of(context).popUntil((route) {
      return route.settings.name != null
          ? route.settings.name == routeName
          : true;
    });
  }

  Future<void> navByType(
      BuildContext context, String? type, String? typeId, String? categoryPage,
      {String title = '',
      FilterPrice? filterPrice,
      Content? contentData}) async {
    switch (type?.toLowerCase()) {
      case 'category':
        if ((contentData?.attribute ?? '').isNotEmpty) {
          Navigator.pushNamed(context, RouteGenerator.routeProductListingScreen,
              arguments: ProductListingArguments(
                  attribute: contentData?.attribute,
                  attributeType: contentData?.attributeType,
                  filterType: contentData?.filterType,
                  title: title,
                  filterPrice: filterPrice));
        } else {
          Navigator.pushNamed(context, RouteGenerator.routeProductListingScreen,
              arguments: ProductListingArguments(
                  categoryId: typeId, title: title, filterPrice: filterPrice));
        }

        break;
      case 'product':
        Navigator.pushNamed(context, RouteGenerator.routeProductDetailScreen,
            arguments: ProductDetailsArguments(
                sku: typeId ?? '',
                isFromInitialState: true)); // Nav to product list
        break;
      case 'category-detail':
        Navigator.pushNamed(context, RouteGenerator.routeCategoryDetailedScreen,
            arguments: CategoryDetailedArguments(
                type: categoryPage, pageTitle: title));
        break;
      case 'order':
        Navigator.pushNamed(context, RouteGenerator.routeMyOrdersScreen);
        break;

      default:
        Helpers.successToast("Not listed");
    }
  }

  Future<void> navToProductDetailScreen(BuildContext context,
      {String? sku, Item? item, bool isFromInitialState = false}) async {
    Navigator.of(context).pushNamed(RouteGenerator.routeProductDetailScreen,
        arguments: ProductDetailsArguments(
            sku: sku, item: item, isFromInitialState: isFromInitialState));
  }

  Future<void> navToProductDetailTermsAndConditionsScreen(BuildContext context,
      {String? identifier}) async {
    Navigator.of(context).pushNamed(
        RouteGenerator.routeProductDetailTermsAndConditionScreen,
        arguments: ProductDetailsArguments(identifier: identifier));
  }

  Future<void> navToProductDetailRatingsAndReviewsScreen(BuildContext context,
      {String? sku}) async {
    Navigator.pushNamed(context, RouteGenerator.routeRatingsAndReviewsScreen,
        arguments: ProductDetailsArguments(sku: sku));
  }

  Future<void> navToSubmitRatingsAndReviewsScreen(BuildContext context,
      {Item? item}) async {
    Navigator.pushNamed(
        context, RouteGenerator.routeSubmitRatingsAndReviewsScreen,
        arguments: item);
  }
}
