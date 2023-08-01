import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/widgets/cached_image_view.dart';
import 'package:oxygen/widgets/favourite_btn.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';

class DynamicProductCardWidget extends StatelessWidget {
  final String sku;
  final double width;
  final String? productName;
  final String? shortNote;
  final String? actualPrice;
  final String? discountPrice;
  final String? warningTag;
  final String? discount;
  final String? image;
  final bool isWishListed;
  final void Function()? onFavouritesPressed;
  final Box<LocalProducts> box;

  const DynamicProductCardWidget({
    Key? key,
    required this.sku,
    required this.width,
    required this.isWishListed,
    this.productName,
    this.shortNote,
    this.actualPrice,
    this.discountPrice,
    this.warningTag,
    this.discount,
    this.image,
    this.onFavouritesPressed,
    required this.box,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.r,
          color: HexColor("#E6E6E6"),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 161.h,
            width: double.maxFinite,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CachedImageView(
                  image: image ?? '',
                  width: double.maxFinite,
                  height: double.maxFinite,
                  enableLoader: false,
                ),
                Positioned(
                  left: 0,
                  right: 6.w,
                  top: 6.h,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: (discount.notEmpty && discount != '0')
                              ? Container(
                                  color: ColorPalette.primaryColor,
                                  margin: EdgeInsets.only(right: 12.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  child: Text(
                                    "$discount % OFF",
                                    maxLines: 1,
                                    style: FontPalette.white11Medium,
                                  ),
                                ).translateWidgetHorizontally(value: -1.w)
                              : const SizedBox.shrink(),
                        ),
                        FavoriteIconWidget(
                          isWishListed: isWishListed,
                          sku: sku,
                          box: box,
                          name: productName,
                          navPath: RouteGenerator.routeProductDetailScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Text(
                    productName ?? "",
                    style: FontPalette.black15Regular,
                  ).avoidOverFlow(maxLine: 2),
                  5.verticalSpace,
                  if (shortNote.notEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Text(
                        shortNote ?? "",
                        maxLines: 1,
                        style: FontPalette.f7E818C_13Regular,
                      ),
                    ),
                  Text(
                    Helpers.convertToInt(discountPrice).toRupee,
                    maxLines: 1,
                    style: FontPalette.black16Bold,
                  ),
                  if (discount.notEmpty && discount != '0')
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        Helpers.convertToInt(actualPrice).toRupee,
                        maxLines: 1,
                        style: FontPalette.f7E818C_14RegularLineThrough,
                      ),
                    ),
                  5.verticalSpace,
                  Text(
                    warningTag ?? "",
                    maxLines: 1,
                    style: FontPalette.f179614_12Medium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
