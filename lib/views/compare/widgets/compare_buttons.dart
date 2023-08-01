import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/arguments/main_screen_arguments.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_btn.dart';
import '../../../widgets/custom_outline_button.dart';

class AddToCartButton extends StatelessWidget {
  final String? sku;
  final String? name;

  AddToCartButton({Key? key, this.sku, this.name}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final cartModel = context.read<CartProvider>();
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomOutlineButtonFitted(
            title: Constants.addToCart,
            height: 30.h,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            fontStyle: FontPalette.black13Medium,
            isLoading: value,
            onPressed: () async {
              if (isLoading.value) return;
              isLoading.value = true;
              await cartModel.addToCart(context,
                  sku: sku ?? "", qty: 1, name: name);
              isLoading.value = false;
            },
          );
        });
  }
}

class ViewProductButton extends StatelessWidget {
  final String? sku;

  ViewProductButton({Key? key, this.sku}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomOutlineButton(
            title: Constants.viewProduct,
            height: 30.h,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            fontStyle: FontPalette.black13Medium,
            isLoading: value,
            onPressed: () {
              NavRoutes.instance.navToProductDetailScreen(context,
                  sku: sku, isFromInitialState: true);
            },
          );
        });
  }
}

class BuyNowButton extends StatelessWidget {
  final String? sku;
  final String? name;

  BuyNowButton({Key? key, this.sku, this.name}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> buyProduct(
      BuildContext context, ValueNotifier<bool> isLoading) async {
    final cartModel = context.read<CartProvider>();

    addToCartAndPush() async {
      await cartModel
          .addToCart(context, sku: sku ?? "", qty: 1, name: name)
          .then((_) async {
        isLoading.value = false;
        await context.read<CartProvider>().getCartDataList(enableLoader: true);
        CommonFunctions.afterInit(() => Navigator.of(context)
            .pushNamed(RouteGenerator.routeSelectAddressScreen));
      });
    }

    if (AppConfig.isAuthorized) {
      addToCartAndPush();
    } else {
      HiveServices.instance.saveNavPath(RouteGenerator.routeCompareScreen);
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomButton(
            title: Constants.buyNow,
            height: 30.h,
            width: double.maxFinite,
            fontStyle: FontPalette.white13Medium,
            isLoading: value,
            onPressed: () async {
              if (isLoading.value) return;
              isLoading.value = true;
              buyProduct(context, isLoading);
            },
          );
        });
  }
}

class GoToCartButton extends StatelessWidget {
  const GoToCartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomOutlineButton(
      title: Constants.goToCart,
      height: 30.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      fontStyle: FontPalette.black13Medium,
      onPressed: () async {
        Navigator.pushNamed(context, RouteGenerator.routeMainScreen,
            arguments: MainScreenArguments(tabIndex: 3, enableNavButton: true));
      },
    );
  }
}
