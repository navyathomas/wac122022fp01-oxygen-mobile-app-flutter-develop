import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/cart_data_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/main_screen/cart/widgets/cart_bottom_sheet.dart';
import 'package:oxygen/views/main_screen/cart/widgets/cart_product_listing_widget.dart';
import 'package:oxygen/views/main_screen/cart/widgets/coupon_and_price_details_widget.dart';
import 'package:oxygen/views/shimmers/cart_shimmer.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:provider/provider.dart';

import '../../../common/common_function.dart';
import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/local_products.dart';
import '../../../repositories/app_data_repo.dart';
import '../../../services/app_config.dart';
import '../../../services/helpers.dart';
import '../../../services/hive_services.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';
import '../../error_screens/api_error_screens.dart';
import '../../error_screens/custom_error_screens.dart';

class CartScreen extends StatefulWidget {
  final Function(int) onTabSwitch;
  final bool? enableBackBtn;

  const CartScreen({Key? key, required this.onTabSwitch, this.enableBackBtn})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  final ValueNotifier<bool> _showBottomSheet = ValueNotifier(true);
  late final CartProvider cartProvider;
  late final TextEditingController couponController;
  late final ValueNotifier<String> couponValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        actionList: const [],
        titleWidget: Selector<CartProvider, CartDataModel?>(
          selector: (context, provider) => provider.cartDataModel,
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Constants.myCart,
                  style: FontPalette.f282C3F_18Bold,
                ),
                AnimatedCrossFade(
                  firstChild: Text(
                    " (${value?.cartItems?.length ?? 0} Items)",
                    style: FontPalette.f282C3F_18Bold,
                  ).avoidOverFlow(),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: ((value?.cartItems?.length ?? 0) > 0)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                ),
                35.horizontalSpace
              ],
            );
          },
        ),
        enableNavBack: widget.enableBackBtn ?? false,
      ),
      backgroundColor: Colors.white,
      bottomSheet: ValueListenableBuilder<bool>(
          valueListenable: _showBottomSheet,
          builder: (_, value, child) {
            return value
                ? CartBottomSheet(
                    onTap: () {
                      if (AppConfig.isAuthorized) {
                        Navigator.pushNamed(
                            context, RouteGenerator.routeSelectAddressScreen);
                      } else {
                        HiveServices.instance
                            .saveNavPath(RouteGenerator.routeMainScreen);
                        Navigator.pushNamed(
                                context, RouteGenerator.routeAuthScreen,
                                arguments: true)
                            .then((value) {
                          if (AppConfig.isAuthorized) {
                            context.read<CartProvider>().getCartDataList();
                          }
                        });
                      }
                    },
                  )
                : const SizedBox.shrink();
          }),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<CartProvider>()
                .getCartDataList(enableLoader: false);
            AppDataRepo.getCartData(clearData: false);
          },
          child: _SwitchView(
            couponValue: couponValue,
            couponController: couponController,
            onDecrementTap: (CartItems? item) => onDecrement(item),
            onIncrementTap: (CartItems? item) => onIncrement(item),
            onRemoveItem: (CartItems? item) => onRemoveTap(item),
            onCouponTap: (bool isApplied) => onApplyCoupon(isApplied),
            onMainTabSwitch: widget.onTabSwitch,
            onTryAgain: () => fetchData(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    couponValue = ValueNotifier('');
    couponController = TextEditingController();
    cartProvider = context.read<CartProvider>();
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    couponController.dispose();
    couponValue.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (WidgetsBinding.instance.window.viewInsets.bottom == 0) {
      _showBottomSheet.value = true;
    } else {
      _showBottomSheet.value = false;
    }
    super.didChangeMetrics();
  }

  void fetchData() {
    CommonFunctions.afterInit(() {
      cartProvider
        ..pageInit()
        ..getCartDataList(onCouponOccurs: (String val) {
          couponController.text = val;
        });
      AppDataRepo.getCartData(clearData: false);
    });
  }

  void onIncrement(CartItems? item) async {
    if (cartProvider.cartLoaderState) return;
    if ((item?.cartProduct?.productQuantity ?? 0) <= (item?.quantity ?? 0)) {
      Helpers.flushToast(context, msg: Constants.qtyNotAvailable);
      return;
    }
    bool res = await cartProvider.updateCartItem(
        sku: item?.cartProduct?.sku ?? '',
        cartItemId: item?.cartItemId ?? -1,
        qty: (item?.quantity ?? 1) + 1,
        refreshData: true);
    if (res && mounted) {
      Helpers.flushImageToast(context,
          msg: Constants.updatedYourCart,
          image: item?.cartProduct?.smallImage?.url ?? '');
    }
  }

  void onDecrement(CartItems? item) async {
    if (cartProvider.cartLoaderState) return;
    if ((item?.quantity ?? 1) > 1) {
      bool res = await cartProvider.updateCartItem(
          sku: item?.cartProduct?.sku ?? '',
          cartItemId: item?.cartItemId ?? -1,
          qty: (item?.quantity ?? 1) - 1,
          refreshData: true);
      if (res && mounted) {
        Helpers.flushImageToast(context,
            msg: Constants.updatedYourCart,
            image: item?.cartProduct?.smallImage?.url ?? '');
      }
    }
  }

  void onRemoveFromCart(CartItems? item, {bool moveToMyItems = false}) async {
    if (cartProvider.cartLoaderState) return;
    bool res = moveToMyItems
        ? await cartProvider.moveToWishList(context,
            sku: item?.variationData?.sku ?? item?.cartProduct?.sku ?? '',
            cartItemId: item?.cartItemId ?? -1,
            name: item?.cartProduct?.name,
            refreshData: true)
        : await cartProvider.removeFromCart(context,
            sku: item?.variationData?.sku ?? item?.cartProduct?.sku ?? '',
            cartItemId: item?.cartItemId ?? -1,
            refreshData: true);
    if (res && mounted) {
      if (moveToMyItems) {
        Helpers.flushImageToast(context,
            msg: Constants.movedToMyItems,
            image: item?.cartProduct?.smallImage?.url ?? '');
      } else {
        Helpers.flushImageToast(context,
            msg: Constants.removedFromCart,
            image: item?.cartProduct?.smallImage?.url ?? '');
      }
    }
  }

  void onRemoveTap(CartItems? item) {
    if (cartProvider.cartLoaderState) return;
    CommonFunctions.showDialogPopUp(
        context,
        CustomAlertDialog(
          title: Constants.removeItem,
          message: Constants.removeItemDesc,
          actionButtonText: Constants.moveToMyItems.toUpperCase(),
          cancelButtonText: Constants.remove.toUpperCase(),
          onActionButtonPressed: () {
            Navigator.pop(context);
            if (AppConfig.isAuthorized) {
              onRemoveFromCart(item, moveToMyItems: true);
            } else {
              HiveServices.instance.saveNavPath(RouteGenerator.routeMainScreen);
              Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
                  arguments: true);
            }
          },
          onCancelButtonPressed: () {
            Navigator.pop(context);
            onRemoveFromCart(item);
          },
          isLoading: false,
        ),
        barrierDismissible: false);
  }

  Future<void> onApplyCoupon(bool isApplied) async {
    if (cartProvider.cartLoaderState) return;
    FocusScope.of(context).unfocus();
    String val = isApplied
        ? await cartProvider.removeCouponFromCart(couponController.text)
        : await cartProvider.addCouponToCart(couponController.text);
    if (isApplied) couponController.clear();
    if (val.isNotEmpty && mounted) {
      Helpers.flushToast(context, msg: val);
    }
  }
}

class _SwitchView extends StatelessWidget {
  final ValueNotifier<String> couponValue;
  final TextEditingController couponController;
  final Function(CartItems?) onDecrementTap;
  final Function(CartItems?) onIncrementTap;
  final Function(CartItems?) onRemoveItem;
  final Function(int) onMainTabSwitch;
  final VoidCallback? onTryAgain;
  final Function(bool) onCouponTap;

  const _SwitchView(
      {Key? key,
      required this.couponValue,
      required this.couponController,
      required this.onDecrementTap,
      required this.onIncrementTap,
      required this.onRemoveItem,
      required this.onCouponTap,
      required this.onMainTabSwitch,
      required this.onTryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<LocalProducts>>(
      valueListenable:
          Hive.box<LocalProducts>(HiveServices.instance.cartBoxName)
              .listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return CustomErrorScreen(
            errorType: CustomErrorType.myCartEmpty,
            onButtonPressed: () {
              onMainTabSwitch(0);
            },
          );
        }
        return Selector<CartProvider, LoaderState>(
            selector: (context, provider) => provider.loaderState,
            builder: (context, value, child) {
              switch (value) {
                case LoaderState.loaded:
                  return _CartMainView(
                    couponValue: couponValue,
                    couponController: couponController,
                    onDecrementTap: onDecrementTap,
                    onIncrementTap: onIncrementTap,
                    onRemoveItem: onRemoveItem,
                    onCouponTap: onCouponTap,
                  );
                case LoaderState.loading:
                  return const CartShimmer();
                case LoaderState.error:
                  return CustomSlidingFadeAnimation(
                    slideDuration: const Duration(milliseconds: 300),
                    child: ApiErrorScreens(
                      loaderState: LoaderState.error,
                      onTryAgain: onTryAgain,
                    ),
                  );
                case LoaderState.networkErr:
                  return CustomSlidingFadeAnimation(
                    slideDuration: const Duration(milliseconds: 300),
                    child: ApiErrorScreens(
                      loaderState: LoaderState.networkErr,
                      onTryAgain: onTryAgain,
                    ),
                  );
                case LoaderState.noData:
                  return CustomErrorScreen(
                    errorType: CustomErrorType.myCartEmpty,
                    onButtonPressed: () {
                      onMainTabSwitch(0);
                    },
                  );
                case LoaderState.noProducts:
                  return const SizedBox.shrink();
                  break;
              }
            });
      },
    );
  }
}

class _CartMainView extends StatelessWidget {
  final ValueNotifier<String> couponValue;
  final TextEditingController couponController;
  final Function(CartItems?) onDecrementTap;
  final Function(CartItems?) onIncrementTap;
  final Function(CartItems?) onRemoveItem;
  final Function(bool) onCouponTap;

  const _CartMainView(
      {Key? key,
      required this.couponValue,
      required this.couponController,
      required this.onDecrementTap,
      required this.onIncrementTap,
      required this.onRemoveItem,
      required this.onCouponTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<CartProvider, bool>(
            selector: (context, provider) => provider.cartLoaderState,
            builder: (context, state, _) {
              return WidgetExtension.crossSwitch(
                  first: const CommonLinearProgress(), value: state);
            }),
        Expanded(
          child: Selector<CartProvider, CartDataModel?>(
            selector: (context, provider) => provider.cartDataModel,
            builder: (context, value, child) {
              if (value == null) return const CartShimmer();
              return CustomSlidingFadeAnimation(
                slideDuration: const Duration(milliseconds: 300),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    CartProductListingWidget(
                      cartDataModel: value,
                      onDecrementTap: onDecrementTap,
                      onIncrementTap: onIncrementTap,
                      onRemoveItem: onRemoveItem,
                    ),
                    Divider(
                      height: 5.h,
                      thickness: 5.h,
                      color: HexColor("#F3F3F7"),
                    ).convertToSliver(),
                    CouponAndPriceDetailsWidget(
                      couponValue: couponValue,
                      couponController: couponController,
                      cartDataModel: value,
                      onCouponTap: onCouponTap,
                    ).convertToSliver(),
                    90.verticalSpace.convertToSliver(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
