import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/compare_products_response_model.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/providers/compare_provider.dart';
import 'package:oxygen/repositories/compare_repo.dart';
import 'package:oxygen/views/compare/widgets/compare_buttons.dart';

import '../../../common/constants.dart';
import '../../../common/nav_routes.dart';
import '../../../generated/assets.dart';
import '../../../services/hive_services.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_fade_in_image.dart';

class CompareHorizontalListview extends StatelessWidget {
  const CompareHorizontalListview({
    Key? key,
    required this.compareProvider,
  }) : super(key: key);
  final CompareProvider compareProvider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                  compareProvider.compareProductList.notEmpty
                      ? compareProvider.compareProductList.length
                      : 0, (index) {
                GetCompareProducts compareProductItem =
                    compareProvider.compareProductList[index];
                return Container(
                  width: constraints.maxWidth /
                      compareProvider.compareProductList.length,
                  // height: 293.h,
                  padding: EdgeInsets.only(
                      top: 0.h, bottom: 18.h, left: 12.w, right: 12.w),
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(color: HexColor("#E6E6E6"), width: .7.r),
                    bottom: BorderSide(color: HexColor("#E6E6E6"), width: .7.r),
                  )),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                NavRoutes.instance.navToProductDetailScreen(
                                  context,
                                  sku: compareProductItem.productInterface?.sku,
                                  isFromInitialState: true,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  5.verticalSpace,
                                  Center(
                                    child: CommonFadeInImage(
                                      image: compareProductItem.image ?? '',
                                      height: constraints.maxWidth * .2367.w,
                                      width: constraints.maxWidth * .2367.w,
                                    ),
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    compareProductItem.productName ?? '',
                                    style: FontPalette.black12Regular,
                                  ).avoidOverFlow(maxLine: 2),
                                  5.verticalSpace,
                                  FittedBox(
                                    child: Text(
                                      compareProductItem.price.notEmpty
                                          ? compareProductItem
                                              .price.removeDecimal
                                          : compareProductItem.regularPrice
                                                  ?.removeDecimal ??
                                              '',
                                      maxLines: 1,
                                      style: FontPalette.black18Bold,
                                    ),
                                  ),
                                  2.verticalSpace,
                                  if (compareProductItem.price.notEmpty)
                                    FittedBox(
                                      child: Text(
                                        compareProductItem
                                                .regularPrice?.removeDecimal ??
                                            '',
                                        maxLines: 1,
                                        style: FontPalette
                                            .f7E818C_16RegularLineThrough
                                            .copyWith(fontSize: 12)
                                            .copyWith(
                                                color: HexColor('#7E818C')),
                                      ).addEllipsis(),
                                    ),
                                  16.verticalSpace,
                                ],
                              ),
                            ),
                          ),
                          compareProductItem.productInterface?.sTypename
                                      ?.toLowerCase() ==
                                  Constants.simpleProduct
                              ? ValueListenableBuilder<Box<LocalProducts>>(
                                  valueListenable: Hive.box<LocalProducts>(
                                          HiveServices.instance.cartBoxName)
                                      .listenable(),
                                  builder: (context, box, child) {
                                    final quantity = box
                                        .get(compareProductItem
                                            .productInterface?.sku)
                                        ?.quantity;
                                    bool showAddToCart = true;
                                    if (quantity != null && quantity > 0) {
                                      showAddToCart = false;
                                    }
                                    return showAddToCart
                                        ? AddToCartButton(
                                            sku: compareProductItem
                                                .productInterface?.sku,
                                            name:
                                                compareProductItem.productName,
                                          )
                                        : const GoToCartButton();
                                  })
                              : ViewProductButton(
                                  sku:
                                      compareProductItem.productInterface?.sku),
                          10.verticalSpace,
                          (compareProductItem.productInterface?.sTypename
                                      ?.toLowerCase() ==
                                  Constants.simpleProduct)
                              ? BuyNowButton(
                                  sku: compareProductItem.productInterface?.sku,
                                  name: compareProductItem.productName,
                                )
                              : SizedBox(height: 30.h)
                        ],
                      ),
                      Positioned(
                        top: 2.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (compareProductItem.discount.notEmpty &&
                                (compareProductItem.discount ?? '0') != '0')
                              Transform.translate(
                                offset: Offset(-12.5.w, 0),
                                child: Container(
                                  color: ColorPalette.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  child: Text(
                                    compareProductItem.discount ?? '',
                                    maxLines: 1,
                                    style: FontPalette.white11Medium,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                    height: 40.r,
                                    width: 40.r,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.10),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Container(
                                        height: 17.5.h,
                                        width: 17.5.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: HexColor('#BEC0CC'),
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          Assets.iconsClose,
                                          color: Colors.white,
                                          height: 8.h,
                                          width: 8.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    await CompareRepo.removeProductFromCompare(
                                        compareProductItem.productId ?? '');
                                    await compareProvider
                                        .getCompareProductDetails();
                                  },
                                ).translateWidgetHorizontally(value: 12.5.w),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
        );
      },
    );
  }
}
