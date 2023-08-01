import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class ProductCardWidget extends StatelessWidget {
  final double width;
  final String? productName;
  final String? category;
  final String? actualPrice;
  final String? discountPrice;
  final String? warningTag;
  final String? discount;
  final String? image;
  final String? offerImage;
  final bool? isNew;

  const ProductCardWidget({
    Key? key,
    required this.width,
    this.productName,
    this.category,
    this.actualPrice,
    this.discountPrice,
    this.warningTag,
    this.discount,
    this.image,
    this.offerImage,
    this.isNew,
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
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CommonFadeInImage(
                      image: image, placeHolderImage: Assets.imagesBlankImage),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: 13.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: (discount != null)
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.3.w),
                            child: SizedBox.square(
                              dimension: 21.r,
                              child: SvgPicture.asset((true)
                                  ? Assets.iconsFavouriteFilled
                                  : Assets.iconsFavourite),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                Text(
                  productName ?? "",
                  maxLines: 1,
                  style: FontPalette.black15Regular,
                ),
                5.verticalSpace,
                Text(
                  category ?? "",
                  maxLines: 1,
                  style: FontPalette.f7E818C_13Regular,
                ),
                7.verticalSpace,
                Text(
                  discountPrice ?? "",
                  maxLines: 1,
                  style: FontPalette.black16Bold,
                ),
                3.verticalSpace,
                Text(
                  actualPrice ?? "",
                  maxLines: 1,
                  style: FontPalette.f7E818C_14RegularLineThrough,
                ),
                7.verticalSpace,
                Text(
                  warningTag ?? "",
                  maxLines: 1,
                  style: FontPalette.f179614_12Medium,
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
