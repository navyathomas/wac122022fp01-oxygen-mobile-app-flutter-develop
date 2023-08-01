import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_row_card_widget.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

import '../../../common/route_generator.dart';
import '../../../models/compare_products_model.dart';
import '../../../models/local_products.dart';
import '../../../providers/product_listing_provider.dart';
import '../../../services/hive_services.dart';
import '../../../widgets/favourite_btn.dart';

class ProductListingGridCardWidget extends StatelessWidget {
  final String? image;
  final String? offerImage;
  final String? productName;
  final String? category;
  final int? actualPrice;
  final int? discountPrice;
  final String? status;
  final String? discount;
  final bool? isNew;
  final bool? notInStock;
  final String? sku;
  final bool isEven;
  final bool isFromProductListing;
  final bool isAddedToCompare;
  final Future<void> Function() onAddToCompareTap;
  final bool isShowAddToCompare;
  final bool isLoading;
  final ProductListingProvider? productListingProvider;
  final String? productId;
  final bool showTopMargin;

  const ProductListingGridCardWidget(
      {Key? key,
      this.image,
      this.offerImage,
      this.productName,
      this.category,
      this.actualPrice,
      this.discountPrice,
      this.status,
      this.discount,
      this.isNew,
      this.notInStock,
      this.sku,
      this.isEven = false,
      this.isFromProductListing = true,
      this.isAddedToCompare = false,
      this.isShowAddToCompare = false,
      this.isLoading = false,
      this.productListingProvider,
      required this.onAddToCompareTap,
      this.productId,
      this.showTopMargin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            right: isEven
                ? BorderSide(color: HexColor("#E6E6E6"), width: 1.r)
                : BorderSide.none,
            top: showTopMargin
                ? BorderSide(color: HexColor("#E6E6E6"), width: 1.r)
                : BorderSide.none,
            bottom: BorderSide(color: HexColor("#E6E6E6"), width: 1.r),
            //width: .3
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: (discount != null && (discount?.isNotEmpty ?? false))
                      ? Container(
                          color: ColorPalette.primaryColor,
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          child: Text(
                            discount == null ? "" : "$discount% OFF",
                            maxLines: 1,
                            style: FontPalette.white11Medium,
                          ),
                        ).translateWidgetHorizontally(value: -1.5.w)
                      : 0.horizontalSpace,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 13.3.w),
                  child: ValueListenableBuilder<Box<LocalProducts>>(
                      valueListenable: Hive.box<LocalProducts>(
                              HiveServices.instance.wishlistBoxName)
                          .listenable(),
                      builder: (context, box, child) {
                        return FavoriteIconWidget(
                            isWishListed:
                                (box.get(sku ?? '')?.isFavourite ?? false),
                            sku: sku ?? "",
                            box: box,
                            size: 18.r,
                            name: productName,
                            navPath: RouteGenerator.routeProductDetailScreen);
                      }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return CommonCachedNetworkImageFixed(
                      image: image,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    );
                  }),
                  if (notInStock ?? false)
                    Container(
                      color: Colors.white.withOpacity(.40),
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.20),
                                    blurRadius: 10)
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 9.w, vertical: 6.h),
                          child: Text(
                            Constants.currentlyOutOfStock,
                            textAlign: TextAlign.center,
                            style: FontPalette.fE50019_13Medium
                                .copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (offerImage != null &&
                            (offerImage?.isNotEmpty ?? false))
                          SizedBox.square(
                            dimension: 59.r,
                            child: CommonFadeInImage(
                                image: offerImage,
                                placeHolderImage: Assets.imagesBlankImage),
                          ),
                        if (isNew ?? false)
                          Container(
                            color: HexColor("#1CAF65"),
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Text(
                              Constants.newText,
                              style: FontPalette.white11Medium,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                5.verticalSpace,
                Text(productName ?? "",
                        maxLines: 1, style: FontPalette.black15Regular)
                    .avoidOverFlow(maxLine: 2),
                2.verticalSpace,
                Text(category ?? "",
                        maxLines: 1, style: FontPalette.f7E818C_13Regular)
                    .avoidOverFlow(maxLine: 1),
                6.verticalSpace,
                RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      if (discountPrice != 0)
                        TextSpan(
                          text: discountPrice?.toRupee,
                          style: FontPalette.black16Bold,
                        ),
                      WidgetSpan(child: 10.horizontalSpace),
                      if (actualPrice != 0)
                        TextSpan(
                          text: actualPrice?.toRupee,
                          style: FontPalette.f7E818C_14RegularLineThrough,
                        )
                    ],
                  ),
                ),
                if (isShowAddToCompare) 6.verticalSpace,
                if (isShowAddToCompare)
                  ValueListenableBuilder<Box<CompareProducts>>(
                    valueListenable: Hive.box<CompareProducts>(
                            HiveServices.instance.compareProductBoxName)
                        .listenable(),
                    builder: (context, box, child) {
                      return box.containsKey(productId ?? '')
                          ? const AddedToCompare()
                          : AddToCompare(
                              onTap: onAddToCompareTap, isLoading: isLoading);
                    },
                  ),
                6.verticalSpace,
                ((!(notInStock ?? true) && (status.notEmpty)))
                    ? Text(status ?? "",
                        maxLines: 1, style: FontPalette.f179614_13Medium)
                    : const Text(""),
                15.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
