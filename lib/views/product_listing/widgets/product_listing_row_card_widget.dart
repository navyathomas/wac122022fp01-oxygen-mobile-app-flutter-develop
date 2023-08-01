import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/providers/product_listing_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:oxygen/widgets/custom_divider.dart';
import 'package:provider/provider.dart';

import '../../../common/route_generator.dart';
import '../../../models/local_products.dart';
import '../../../services/hive_services.dart';
import '../../../widgets/favourite_btn.dart';
import '../../../widgets/three_bounce.dart';

class ProductListingRowCardWidget extends StatelessWidget {
  final String? image;
  final String? offerImage;
  final String? productName;
  final int? actualPrice;
  final int? discountPrice;
  final String? status;
  final String? discount;
  final List<String>? attributes;
  final bool? isNew;
  final bool? notInStock;
  final int? length;
  final int? index;
  final String? sku;
  final bool isFromProductListing;
  final bool isAddedToCompare;
  final Future<void> Function() onAddToCompareTap;
  final bool isShowAddToCompare;
  final bool isLoading;
  final ProductListingProvider? productListingProvider;
  final String? productId;

  const ProductListingRowCardWidget(
      {Key? key,
      required this.onAddToCompareTap,
      this.image,
      this.offerImage,
      this.productName,
      this.actualPrice,
      this.discountPrice,
      this.status,
      this.discount,
      this.attributes,
      this.isNew,
      this.notInStock,
      this.length,
      this.index,
      this.sku,
      this.isFromProductListing = true,
      this.isAddedToCompare = false,
      this.isShowAddToCompare = false,
      this.isLoading = false,
      this.productListingProvider,
      this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: productListingProvider,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.verticalSpace,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (discount != null && (discount?.isNotEmpty ?? false))
                          ? Container(
                              color: ColorPalette.primaryColor,
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              child: Text(
                                discount == null ? "" : "$discount% OFF",
                                maxLines: 1,
                                style: FontPalette.white11Medium,
                              ),
                            )
                          : 0.horizontalSpace,
                      Padding(
                        padding: EdgeInsets.only(right: 12.3.w),
                        child: ValueListenableBuilder<Box<LocalProducts>>(
                            valueListenable: Hive.box<LocalProducts>(
                                    HiveServices.instance.wishlistBoxName)
                                .listenable(),
                            builder: (context, box, child) {
                              return FavoriteIconWidget(
                                  isWishListed:
                                      (box.get(sku ?? '')?.isFavourite ??
                                          false),
                                  sku: sku ?? "",
                                  box: box,
                                  name: productName,
                                  size: 18.r,
                                  navPath:
                                      RouteGenerator.routeProductDetailScreen);
                            }),
                      ),
                    ]),
                Row(
                  children: [
                    SizedBox.square(
                      dimension: constraints.maxWidth * .2667,
                      child: Stack(
                        // alignment: AlignmentDirectional.centerStart,
                        children: [
                          CommonCachedNetworkImageFixed(
                            image: image,
                            height: constraints.maxWidth * .2667,
                            width: constraints.maxWidth * .2667,
                          ),
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
                          if (offerImage != null &&
                              (offerImage?.isNotEmpty ?? false))
                            Positioned(
                              bottom: 0,
                              left: 12.w,
                              child: SizedBox.square(
                                dimension: 59.r,
                                child: CommonFadeInImageWithCache(
                                    image: offerImage,
                                    height: 59.r,
                                    width: 59.r,
                                    placeHolderImage: Assets.imagesBlankImage),
                              ),
                            ),
                        ],
                      ),
                    ),
                    27.horizontalSpace,
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            if (isNew ?? false) 4.verticalSpace,
                            Text(
                              productName ?? "",
                              style: FontPalette.black15Regular,
                            ).avoidOverFlow(maxLine: 2),
                            6.verticalSpace,
                            RichText(
                              text: TextSpan(
                                children: [
                                  if (discountPrice != 0)
                                    TextSpan(
                                      text: discountPrice.toRupee,
                                      style: FontPalette.black18Bold,
                                    ),
                                  WidgetSpan(child: 10.horizontalSpace),
                                  if (actualPrice != 0)
                                    TextSpan(
                                      text: actualPrice.toRupee,
                                      style: FontPalette
                                          .f7E818C_16RegularLineThrough,
                                    )
                                ],
                              ),
                            ),
                            if (!(notInStock ?? true) && (status.notEmpty))
                              6.verticalSpace,
                            if (!(notInStock ?? true) && (status.notEmpty))
                              Text(
                                status ?? "",
                                style: FontPalette.f179614_13Medium,
                              ),
                            6.verticalSpace,
                            if (isShowAddToCompare)
                              ValueListenableBuilder<Box<CompareProducts>>(
                                valueListenable: Hive.box<CompareProducts>(
                                        HiveServices
                                            .instance.compareProductBoxName)
                                    .listenable(),
                                builder: (context, box, child) {
                                  return box.containsKey(productId ?? '')
                                      ? const AddedToCompare()
                                      : AddToCompare(
                                          onTap: onAddToCompareTap,
                                          isLoading: isLoading);
                                },
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Wrap(
                    spacing: 6.r,
                    runSpacing: 6.r,
                    children: List.generate(
                      (attributes).notEmpty
                          ? attributes!.length > 4
                              ? 4
                              : attributes?.length ?? 0
                          : 0,
                      (index) => (attributes?.elementAt(index).isEmpty ?? true)
                          ? const SizedBox.shrink()
                          : _BuildWrap(
                              text: attributes?.elementAt(index) ?? "",
                            ),
                    ),
                  ),
                ),
                if (length != (index ?? 0) + 1)
                  CustomDivider(
                    thickness: 2.h,
                  ),
                //10.verticalSpace
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BuildWrap extends StatelessWidget {
  final String text;

  const _BuildWrap({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: HexColor("#7E818C").withOpacity(.5),
        ),
      ),
      child: Text(
        text.trim(),
        style: FontPalette.f7E818C_13Regular,
      ).avoidOverFlow(maxLine: 1),
    );
  }
}

class AddToCompare extends StatefulWidget {
  const AddToCompare(
      {Key? key,
      required this.onTap,
      required this.isLoading,
      this.productListingProvider})
      : super(key: key);
  final Future<void> Function() onTap;
  final bool isLoading;
  final ProductListingProvider? productListingProvider;

  @override
  State<AddToCompare> createState() => _AddToCompareState();
}

class _AddToCompareState extends State<AddToCompare> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 27.h,
          width: 118.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorPalette.primaryColor.withOpacity(.5),
            ),
          ),
          child: isLoading
              ? ThreeBounce(
                  size: 20.h,
                  color: ColorPalette.primaryColor,
                )
              : FittedBox(
                  child: Text(
                    Constants.addToCompare,
                    style: FontPalette.fE50019_14Medium,
                    // style: FontPalette.black14Medium,
                  ),
                ),
        ));
  }

  onTap() async {
    setState(() {
      isLoading = true;
    });

    await widget.onTap().then((value) => isLoading = false);
  }
}

class AddedToCompare extends StatelessWidget {
  const AddedToCompare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27.h,
      width: 72.w,
      color: ColorPalette.primaryColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            size: 11.h,
            color: Colors.white,
          ),
          3.horizontalSpace,
          Text(
            Constants.added,
            style: FontPalette.white13Medium,
          )
        ],
      ),
    );
  }
}
