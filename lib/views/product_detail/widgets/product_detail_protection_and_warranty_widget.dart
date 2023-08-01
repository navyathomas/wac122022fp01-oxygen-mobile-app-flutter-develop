import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProductDetailProtectionAndWarrantyWidget extends StatelessWidget {
  const ProductDetailProtectionAndWarrantyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartModel = context.read<CartProvider>();
    final productDetailModel = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider, Tuple3<List<Option?>?, Item?, bool>>(
        selector: (context, provider) => Tuple3(provider.selectedItem?.options,
            provider.selectedItem, provider.variantNotAvailable),
        builder: (context, value, child) {
          return (value.item1 == null || (value.item1?.isEmpty ?? true))
              ? const SizedBox.shrink()
              : (value.item2?.stockStatus == "IN_STOCK" && !value.item3)
                  ? Container(
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(bottom: 5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 18.h),
                      child: ListView.separated(
                        itemCount: value.item1?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = value.item1?.elementAt(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: context.sw(size: .10)),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item?.title ?? "",
                                        style: FontPalette.black16Regular,
                                      ),
                                      if (item?.termsAndConditions
                                              ?.identifier !=
                                          null) ...[
                                        WidgetSpan(child: 5.horizontalSpace),
                                        TextSpan(
                                          text: "T&C",
                                          style: FontPalette
                                              .fE50019_14MediumUnderLine,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              NavRoutes.instance
                                                  .navToProductDetailTermsAndConditionsScreen(
                                                      context,
                                                      identifier: item
                                                          ?.termsAndConditions
                                                          ?.identifier);
                                            },
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              12.verticalSpace,
                              Text(
                                item?.description ?? "",
                                style: FontPalette.f7E818C_14Regular,
                              ),
                              12.verticalSpace,
                              ValueListenableBuilder<Box<LocalProducts>>(
                                  valueListenable: Hive.box<LocalProducts>(
                                          HiveServices.instance.cartBoxName)
                                      .listenable(),
                                  builder: (context, box, child) {
                                    return ListView.separated(
                                        itemCount: item?.value?.length ?? 0,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final listItem =
                                              item?.value?.elementAt(index);

                                          final localProducts = box.get(
                                              productDetailModel
                                                  .selectedItem?.sku);

                                          final isAddOnAdded =
                                              (localProducts?.cartPlanId ==
                                                  listItem?.optionTypeId);

                                          final quantity = box
                                              .get(productDetailModel
                                                  .selectedItem?.sku)
                                              ?.quantity;

                                          final cartItemId = box
                                              .get(productDetailModel
                                                  .selectedItem?.sku)
                                              ?.cartItemId;

                                          bool addedToCart =
                                              (quantity != null &&
                                                  quantity > 0);

                                          return (listItem == null ||
                                                  listItem.optionTypeId == null)
                                              ? const SizedBox.shrink()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 11.h,
                                                      horizontal: 13.w),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#DBDBDB"),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              listItem.price
                                                                  .toRupee,
                                                              style: FontPalette
                                                                  .black16Medium,
                                                            ),
                                                            4.verticalSpace,
                                                            Text(
                                                              listItem.title
                                                                      ?.toString() ??
                                                                  "",
                                                              style: FontPalette
                                                                  .f282C3F_12Regular,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      _AddOrRemovePlanButton(
                                                        isAdded: isAddOnAdded,
                                                        onTap: () async {
                                                          if (isAddOnAdded) {
                                                            await context
                                                                .read<
                                                                    CartProvider>()
                                                                .removeOptionItemFromCart(
                                                                  sku: productDetailModel
                                                                          .selectedItem
                                                                          ?.sku ??
                                                                      "",
                                                                  cartItemId:
                                                                      cartItemId ??
                                                                          -1,
                                                                  qty: 1,
                                                                  optionTypeId:
                                                                      listItem.optionTypeId ??
                                                                          1,
                                                                )
                                                                .then((value) {
                                                              if (value) {
                                                                Helpers.flushToast(
                                                                    context,
                                                                    msg:
                                                                        "Your plan has been removed from the selected product");
                                                              }
                                                            });
                                                          } else {
                                                            if (addedToCart) {
                                                              await cartModel
                                                                  .updateCartItem(
                                                                      sku: productDetailModel
                                                                              .selectedItem
                                                                              ?.sku ??
                                                                          "",
                                                                      cartItemId:
                                                                          cartItemId ??
                                                                              0,
                                                                      qty: 1,
                                                                      optionId: item
                                                                          ?.optionId,
                                                                      optionTypeId:
                                                                          listItem
                                                                              .optionTypeId)
                                                                  .then(
                                                                      (value) {
                                                                if (value) {
                                                                  Helpers.flushToast(
                                                                      context,
                                                                      msg:
                                                                          "Your plan has been added to the selected product");
                                                                }
                                                              });
                                                            } else {
                                                              switch (productDetailModel
                                                                  .productType
                                                                  ?.toLowerCase()) {
                                                                case Constants
                                                                    .simpleProduct:
                                                                  {
                                                                    await cartModel
                                                                        .addToCart(
                                                                            context,
                                                                            sku: productDetailModel.selectedItem?.sku ??
                                                                                "",
                                                                            qty:
                                                                                1,
                                                                            optionId: item
                                                                                ?.optionId,
                                                                            optionTypeId: listItem
                                                                                .optionTypeId,
                                                                            name: productDetailModel
                                                                                .selectedItem?.name)
                                                                        .then(
                                                                            (value) {
                                                                      if (value) {
                                                                        Helpers.flushToast(
                                                                            context,
                                                                            msg:
                                                                                "Your plan has been added to the selected product");
                                                                      }
                                                                    });
                                                                    break;
                                                                  }
                                                                case Constants
                                                                    .configurableProduct:
                                                                  {
                                                                    await cartModel
                                                                        .addConfigurableToCart(
                                                                            context,
                                                                            sku: productDetailModel.selectedItem?.sku ??
                                                                                "",
                                                                            parentSku: productDetailModel.parentSku ??
                                                                                "",
                                                                            qty:
                                                                                1,
                                                                            optionId: item
                                                                                ?.optionId,
                                                                            optionTypeId: listItem
                                                                                .optionTypeId,
                                                                            name: productDetailModel
                                                                                .selectedItem?.name)
                                                                        .then(
                                                                            (value) {
                                                                      if (value) {
                                                                        Helpers.flushToast(
                                                                            context,
                                                                            msg:
                                                                                "Your plan has been added to the selected product");
                                                                      }
                                                                    });
                                                                    break;
                                                                  }
                                                              }
                                                            }
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                        },
                                        separatorBuilder: (context, index) {
                                          final listItem =
                                              item?.value?.elementAt(index);
                                          return (listItem == null ||
                                                  listItem.optionTypeId == null)
                                              ? const SizedBox.shrink()
                                              : 8.verticalSpace;
                                        });
                                  }),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => 5.verticalSpace,
                      ),
                    )
                  : const SizedBox.shrink();
        });
  }
}

class _AddOrRemovePlanButton extends StatefulWidget {
  final bool isAdded;
  final Future<void> Function()? onTap;

  const _AddOrRemovePlanButton({
    Key? key,
    this.isAdded = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<_AddOrRemovePlanButton> createState() => _AddOrRemovePlanButtonState();
}

class _AddOrRemovePlanButtonState extends State<_AddOrRemovePlanButton> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void onTap() async {
    if (widget.onTap != null) {
      isLoading.value = true;
      await widget.onTap!().then((_) {
        isLoading.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, value, child) {
        return value
            ? SizedBox(
                width: 86.w,
                child: ThreeBounce(
                  size: 25.r,
                  color: ColorPalette.primaryColor,
                ),
              )
            : widget.isAdded
                ? Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
                        height: 30.h,
                        width: 86.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: FittedBox(
                            child: Text(
                              Constants.remove.toUpperCase(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: FontPalette.black14Medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Material(
                    color: ColorPalette.primaryColor,
                    child: InkWell(
                      splashColor: HexColor("#ff4f62"),
                      onTap: onTap,
                      child: SizedBox(
                        height: 30.h,
                        width: 86.w,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: FittedBox(
                            child: Text(
                              Constants.addPlan.toUpperCase(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: FontPalette.white14Medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
      },
    );
  }
}
