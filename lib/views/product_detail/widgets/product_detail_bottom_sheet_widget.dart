import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../models/arguments/main_screen_arguments.dart';
import 'dialogues/show_notify_dialogue.dart';

class ProductDetailBottomSheetWidget extends StatefulWidget {
  const ProductDetailBottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailBottomSheetWidget> createState() =>
      _ProductDetailBottomSheetWidgetState();
}

class _ProductDetailBottomSheetWidgetState
    extends State<ProductDetailBottomSheetWidget> with WidgetsBindingObserver {
  ValueNotifier<bool> showKeyBoard = ValueNotifier<bool>(false);

  void checkVisibility() {
    if (WidgetsBinding.instance.window.viewInsets.bottom == 0) {
      showKeyBoard.value = false;
    } else {
      showKeyBoard.value = true;
    }
  }

  @override
  void didChangeMetrics() {
    checkVisibility();
    super.didChangeMetrics();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productDetailModel = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider, Tuple2<Item?, bool>>(
        selector: (context, provider) =>
            Tuple2(provider.selectedItem, provider.variantNotAvailable),
        builder: (_, value, __) {
          return (value.item1 == null)
              ? const SizedBox.shrink()
              : ValueListenableBuilder(
                  valueListenable: showKeyBoard,
                  builder: (context, keyboardValue, child) {
                    return (keyboardValue
                            ? const SizedBox.shrink()
                            : Container(
                                height: 73.h,
                                decoration: CommonStyles.bottomDecoration,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 15.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: (value.item1?.stockStatus ==
                                                    "IN_STOCK" &&
                                                !value.item2)
                                            ? ValueListenableBuilder<
                                                    Box<LocalProducts>>(
                                                valueListenable:
                                                    Hive.box<LocalProducts>(
                                                            HiveServices
                                                                .instance
                                                                .cartBoxName)
                                                        .listenable(),
                                                builder: (context, box, child) {
                                                  final quantity = box
                                                      .get(productDetailModel
                                                          .selectedItem?.sku)
                                                      ?.quantity;
                                                  bool showAddToCart = true;
                                                  if (quantity != null &&
                                                      quantity > 0) {
                                                    showAddToCart = false;
                                                  }
                                                  return showAddToCart
                                                      ? _AddToCartButton()
                                                      : const _GoToCartButton();
                                                })
                                            : Center(
                                                child: Text(
                                                  Constants.outOfStock
                                                      .toUpperCase(),
                                                  style: FontPalette
                                                      .fE50019_15Bold,
                                                ),
                                              ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                          child: (value.item1?.stockStatus ==
                                                      "IN_STOCK" &&
                                                  !value.item2)
                                              ? _BuyNowButton()
                                              : const _NotifyMeButton()),
                                    ],
                                  ),
                                ),
                              ).translateWidgetVertically(value: 1))
                        .animatedSwitch(reverseDuration: 0);
                  },
                );
        });
  }
}

class _AddToCartButton extends StatelessWidget {
  _AddToCartButton({Key? key}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final productDetailModel = context.read<ProductDetailProvider>();
    final cartModel = context.read<CartProvider>();
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomOutlineButton(
            title: Constants.addToCart,
            isLoading: value,
            onPressed: () async {
              if (isLoading.value) return;
              isLoading.value = true;
              switch (productDetailModel.productType?.toLowerCase()) {
                case Constants.configurableProduct:
                  await cartModel.addConfigurableToCart(context,
                      sku: productDetailModel.selectedItem?.sku ?? "",
                      parentSku: productDetailModel.parentSku ?? "",
                      qty: 1,
                      name: productDetailModel.selectedItem?.name);
                  isLoading.value = false;
                  break;
                case Constants.simpleProduct:
                  await cartModel.addToCart(context,
                      sku: productDetailModel.selectedItem?.sku ?? "",
                      qty: 1,
                      name: productDetailModel.selectedItem?.name);
                  isLoading.value = false;
                  break;
              }
            },
          );
        });
  }
}

class _GoToCartButton extends StatelessWidget {
  const _GoToCartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomOutlineButton(
      title: Constants.goToCart,
      onPressed: () async {
        Navigator.pushNamed(context, RouteGenerator.routeMainScreen,
            arguments: MainScreenArguments(tabIndex: 3, enableNavButton: true));
        /*NavRoutes.instance.popUntil(context, RouteGenerator.routeMainScreen);*/
      },
    );
  }
}

class _BuyNowButton extends StatelessWidget {
  _BuyNowButton({Key? key}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomButton(
            title: Constants.buyNow,
            isLoading: value,
            onPressed: () async {
              if (isLoading.value) return;
              isLoading.value = true;
              await CommonFunctions.buyProduct(context, isLoading);
            },
          );
        });
  }
}

class _NotifyMeButton extends StatefulWidget {
  const _NotifyMeButton({Key? key}) : super(key: key);

  @override
  State<_NotifyMeButton> createState() => _NotifyMeButtonState();
}

class _NotifyMeButtonState extends State<_NotifyMeButton> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final productDetailModel = context.read<ProductDetailProvider>();
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomOutlineButton(
            title: Constants.notifyMe,
            isLoading: value,
            onPressed: () async {
              if (isLoading.value) return;
              isLoading.value = true;
              if (AppConfig.isAuthorized) {
                final authCustomerData =
                    await HiveServices.instance.getUserData();
                if (!productDetailModel.variantNotAvailable) {
                  if (!mounted) return;
                  final result = await ProductDetailRepo.getStockNotification(
                    context,
                    id: productDetailModel.selectedItem?.id,
                    email: authCustomerData?.email,
                  );
                  isLoading.value = false;
                  if (result != null) {
                    if (!mounted) return;
                    Helpers.flushToast(context, msg: result);
                  }
                }
              } else {
                isLoading.value = true;
                showGeneralDialog(
                  barrierDismissible: true,
                  context: context,
                  useRootNavigator: false,
                  routeSettings: const RouteSettings(name: "/showNotifyPopUp"),
                  barrierLabel: "",
                  pageBuilder: (_, __, ___) {
                    return const SizedBox.shrink();
                  },
                  transitionBuilder: (_, animation, __, ___) {
                    var curve = Curves.easeInOut.transform(animation.value);
                    return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: Transform.scale(
                        scale: curve,
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShowNotifyDialogue(
                                  id: productDetailModel.selectedItem?.id ?? 1),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ).then((_) => isLoading.value = false);
              }
            },
          );
        });
  }
}
