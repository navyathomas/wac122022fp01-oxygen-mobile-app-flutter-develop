import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/main_screen/cart/widgets/cart_add_on_bottom_sheet.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:provider/provider.dart';

import '../../../../models/cart_data_model.dart';

class CartProductCardWidget extends StatelessWidget {
  final String? image;
  final String? sku;
  final int? cartItemId;
  final String? productName;
  final int? discountPrice;
  final int? actualPrice;
  final int? discount;
  final int? itemCount;
  final bool isOutOfStock;
  final VoidCallback? onDecrementTap;
  final VoidCallback? onIncrementTap;
  final VoidCallback? onRemoveProduct;
  final List<AddonOptions>? addonOptions;
  final List<ChildCustomizableOptions>? childCustomizableOptions;

  const CartProductCardWidget(
      {Key? key,
      this.image,
      this.sku,
      this.cartItemId,
      this.productName,
      this.discountPrice,
      this.actualPrice,
      this.discount,
      this.itemCount,
      this.isOutOfStock = false,
      this.onDecrementTap,
      this.onIncrementTap,
      this.onRemoveProduct,
      this.addonOptions,
      this.childCustomizableOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteGenerator.routeProductDetailScreen,
            arguments:
                ProductDetailsArguments(sku: sku, isFromInitialState: true));
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 19.h),
            child: Row(
              children: [
                SizedBox(
                  height: context.sw(size: .2627),
                  width: context.sw(size: .2627),
                  child: Stack(
                    children: [
                      CommonFadeInImage(image: image),
                      if (isOutOfStock)
                        Container(
                          color: Colors.white.withOpacity(0.5),
                          height: double.maxFinite,
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8.r),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              Constants.currentlyOutOfStock,
                              style: FontPalette.fE50019_9Medium,
                              textAlign: TextAlign.center,
                            ).avoidOverFlow(maxLine: 2),
                          ),
                        )
                    ],
                  ),
                ),
                3.5.horizontalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName ?? "",
                          style: FontPalette.black14Regular,
                        ).avoidOverFlow(maxLine: 2),
                        4.5.verticalSpace,
                        Text.rich(
                          TextSpan(
                            text: discountPrice?.toRupee,
                            style: FontPalette.black16Bold,
                            children: [
                              if ((discount ?? 0) > 0) ...[
                                WidgetSpan(child: 10.horizontalSpace),
                                TextSpan(
                                  text: actualPrice?.toRupee,
                                  style:
                                      FontPalette.f7E818C_14RegularLineThrough,
                                ),
                                WidgetSpan(child: 10.horizontalSpace),
                                TextSpan(
                                  text: "$discount% OFF",
                                  style: FontPalette.fE50019_14Medium,
                                ),
                              ]
                            ],
                          ),
                        ),
                        13.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (itemCount != null)
                              Expanded(
                                child: Row(
                                  children: [
                                    Material(
                                      color: HexColor("#F4F4F4"),
                                      child: InkWell(
                                        splashFactory: ((itemCount ?? 1) != 1)
                                            ? InkSplash.splashFactory
                                            : NoSplash.splashFactory,
                                        onTap: onDecrementTap,
                                        child: Container(
                                          height: 27.5.r,
                                          width: 27.5.r,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.r),
                                          child: Center(
                                            child: SvgPicture.asset(
                                                Assets.iconsDecrement),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w),
                                        child: Text(
                                          '${itemCount ?? ""}',
                                          style: FontPalette.black16SemiBold,
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: HexColor("#F4F4F4"),
                                      child: InkWell(
                                        splashFactory: isOutOfStock
                                            ? NoSplash.splashFactory
                                            : InkSplash.splashFactory,
                                        onTap: onIncrementTap,
                                        child: Container(
                                          height: 27.5.r,
                                          width: 27.5.r,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.r),
                                          child: SvgPicture.asset(
                                              Assets.iconsIncrement),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            25.horizontalSpace,
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: Colors.grey.shade200,
                                splashColor: Colors.grey.shade300,
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r)),
                                onTap: onRemoveProduct,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    Constants.remove,
                                    style: FontPalette.black14Regular,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _AddOnTile(
            mainContext: context,
            addonOptions: addonOptions ?? [],
            sku: sku,
            itemCount: itemCount,
            cartItemId: cartItemId,
          ),
          _AddedAddOnTile(
            childCustomizableOptions: childCustomizableOptions ?? [],
            onRemove: () async {
              if ((childCustomizableOptions ?? []).isNotEmpty &&
                  (childCustomizableOptions?.first.values ?? []).notEmpty) {
                final res = await context
                    .read<CartProvider>()
                    .removeOptionItemFromCart(
                        sku: sku ?? '',
                        cartItemId: cartItemId ?? -1,
                        qty: itemCount ?? 1,
                        optionTypeId: childCustomizableOptions
                                ?.first.values?.first.value ??
                            -1,
                        refreshData: true);
                if (res) {
                  CommonFunctions.afterInit(() {
                    Helpers.flushToast(context, msg: Constants.updatedYourCart);
                  });
                }
              }
            },
          )
        ],
      ),
    );
  }
}

class _AddOnTile extends StatelessWidget {
  final BuildContext mainContext;
  final List<AddonOptions> addonOptions;
  final String? sku;
  final int? itemCount;
  final int? cartItemId;

  const _AddOnTile(
      {Key? key,
      required this.mainContext,
      required this.addonOptions,
      this.sku,
      this.itemCount,
      this.cartItemId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (addonOptions.isEmpty || (addonOptions.first.value ?? []).isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(
          bottom: 18.h, left: 16.5.w + context.sw(size: .2627), right: 27.w),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.transparent,
            barrierColor: HexColor("#282C3F").withOpacity(.46),
            builder: (_) => CartAddOnBottomSheet(
              addonOptions: addonOptions,
              sku: sku ?? '',
              qty: itemCount ?? 1,
              cartItemId: cartItemId ?? -1,
              mainContext: mainContext,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: HexColor('#CACBD0'),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 9.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Assets.iconsAddOn,
                color: ColorPalette.primaryColor,
              ),
              9.7.horizontalSpace,
              Flexible(
                child: Text(
                  (addonOptions.first.title ?? ''),
                  style: FontPalette.f282C3F_15Medium,
                ).avoidOverFlow(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AddedAddOnTile extends StatelessWidget {
  final List<ChildCustomizableOptions> childCustomizableOptions;
  final VoidCallback? onRemove;

  const _AddedAddOnTile(
      {Key? key, required this.childCustomizableOptions, this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (childCustomizableOptions.isEmpty) return const SizedBox.shrink();
    return Container(
      color: HexColor('#F4F4F4'),
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 13.w, right: 13.w, bottom: 18.5.h),
      child: Stack(
        children: [
          ListView.separated(
            padding: EdgeInsets.all(15.r),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (cxt, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 35.w, bottom: 12.h),
                    child: Text.rich(TextSpan(
                      text: childCustomizableOptions[index].label,
                      style: FontPalette.black14Regular,
                    )),
                  ),
                  if (childCustomizableOptions[index].values != null)
                    Text.rich(TextSpan(children: [
                      ...List.generate(
                          childCustomizableOptions[index].values!.length,
                          (subIndex) => TextSpan(
                                  text:
                                      '${childCustomizableOptions[index].values?[subIndex].label ?? ''} - ',
                                  style: FontPalette.black16Regular,
                                  children: [
                                    TextSpan(
                                        text:
                                            '₹${childCustomizableOptions[index].values?[subIndex].price?.value ?? ''}',
                                        style: FontPalette.black16Medium)
                                  ]))
                    ]))
                ],
              );
            },
            itemCount: childCustomizableOptions.length,
            separatorBuilder: (_, __) => 10.verticalSpace,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
                onPressed: onRemove,
                splashColor: Colors.transparent,
                iconSize: 31.r,
                icon: SvgPicture.asset(
                  Assets.iconsCloseDarkGrey,
                  height: 21.r,
                  width: 21.r,
                )),
          )
        ],
      ),
    );
  }
}
