import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class MyItemsProductCardWidget extends StatelessWidget {
  final String? productName;
  final String? category;
  final int actualPrice;
  final int discountPrice;
  final int discount;
  final String image;
  final String? offerImage;
  final bool showTopMargin;
  final bool? isOutOfStock;
  final bool? isNew;
  final bool isEven;
  final VoidCallback? onClear;
  final VoidCallback? onMoveToCart;
  final VoidCallback? onTap;

  const MyItemsProductCardWidget(
      {Key? key,
      this.productName,
      this.category,
      required this.actualPrice,
      required this.discountPrice,
      required this.discount,
      required this.image,
      this.offerImage,
      this.showTopMargin = false,
      this.isOutOfStock,
      this.isNew,
      this.isEven = false,
      this.onClear,
      this.onMoveToCart,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: showTopMargin
                  ? BorderSide(color: HexColor("#E6E6E6"), width: 1.r)
                  : BorderSide.none,
              right: isEven
                  ? BorderSide(color: HexColor("#E6E6E6"), width: 1.r)
                  : BorderSide.none,
              bottom: BorderSide(color: HexColor("#E6E6E6"), width: 1.r))),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 151.5.h,
                  child: Stack(
                    children: [
                      CommonFadeInImage(
                          image: image,
                          placeHolderImage: Assets.imagesBlankImage),
                      if (discount > 0)
                        Positioned(
                          top: 12.h,
                          child: Container(
                            color: ColorPalette.primaryColor,
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Text(
                              "$discount% OFF",
                              maxLines: 1,
                              style: FontPalette.white11Medium,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (offerImage != null &&
                                (offerImage?.isNotEmpty ?? false))
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 3.h, left: 16.w),
                                child: SizedBox.square(
                                  dimension: 59.r,
                                  child: CommonFadeInImage(
                                      image: offerImage,
                                      placeHolderImage:
                                          Assets.imagesBlankImage),
                                ),
                              ),
                            if (isNew ?? false)
                              Container(
                                color: HexColor("#1CAF65"),
                                margin: EdgeInsets.only(
                                    right: 10.w, bottom: 3.h, left: 16.w),
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (productName ?? "") * 4,
                          style: FontPalette.black15Regular,
                          strutStyle: const StrutStyle(height: 1.3),
                        ).avoidOverFlow(maxLine: 2),
                        3.verticalSpace,
                        if (category.notEmpty)
                          Text(category ?? "",
                              maxLines: 1,
                              style: FontPalette.f7E818C_13Regular),
                        6.verticalSpace,
                        Text(discountPrice.toRupee,
                            maxLines: 1, style: FontPalette.black16Bold),
                        1.verticalSpace,
                        if (discount > 0)
                          Text(actualPrice.toRupee,
                              maxLines: 1,
                              style: FontPalette.f7E818C_14RegularLineThrough),
                      ],
                    ),
                  ),
                ),
                (isOutOfStock ?? false)
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 16.w, right: 16.w, bottom: 18.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 9.w),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black)),
                        child: Text(Constants.outOfStock.toUpperCase(),
                                style: FontPalette.white13Medium)
                            .avoidOverFlow(),
                      )
                    : InkWell(
                        onTap: onMoveToCart,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 16.w, right: 16.w, bottom: 18.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 9.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Text(Constants.moveToCart.toUpperCase(),
                                  style: FontPalette.black13Medium)
                              .avoidOverFlow(),
                        ),
                      ).removeSplash(),
              ],
            ),
          ).removeSplash(),
          if (isOutOfStock ?? false)
            InkWell(
                    onTap: onTap,
                    child: Container(color: Colors.white.withOpacity(.5)))
                .removeSplash(),
          Positioned(
            top: 0.h,
            right: 0.w,
            child: IconButton(
              onPressed: onClear,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: SvgPicture.asset(
                Assets.iconsMyItemsClose,
                height: 23.r,
                width: 23.r,
              ),
            ),
          )
        ],
      ),
    );
  }
}
