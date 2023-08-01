import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/favourite_btn.dart';

class ProductHomeCardWidget extends StatelessWidget {
  final String sku;
  final Box<LocalProducts> box;
  final double width;
  final String? productName;
  final String? shortNote;
  final String? actualPrice;
  final String? discountPrice;
  final String? warningTag;
  final String? discount;
  final String? image;
  final bool isWishListed;
  final String? tag;
  final String? offerSticker;
  final VoidCallback? onTap;
  final String navPath;

  const ProductHomeCardWidget(
      {Key? key,
      required this.sku,
      required this.box,
      required this.width,
      required this.isWishListed,
      required this.navPath,
      this.productName,
      this.shortNote,
      this.actualPrice,
      this.discountPrice,
      this.warningTag,
      this.discount,
      this.image,
      this.tag,
      this.offerSticker,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                                      "$discount".toUpperCase(),
                                      maxLines: 1,
                                      style: FontPalette.white11Medium,
                                    ),
                                  ).translateWidgetHorizontally(value: -1.w)
                                : const SizedBox.shrink(),
                          ),
                          FavoriteIconWidget(
                            isWishListed: isWishListed,
                            box: box,
                            sku: sku,
                            name: productName,
                            navPath: RouteGenerator.routeMainScreen,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (offerSticker.notEmpty)
                    Positioned(
                        left: 12.w,
                        bottom: 3.h,
                        child: CachedImageView(
                          image: offerSticker!,
                          width: 58.r,
                          height: 58.r,
                        ))
                ],
              ),
            ),
            tag.notEmpty
                ? Container(
                    color: HexColor('#1CAF65'),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    margin:
                        EdgeInsets.only(left: 12.w, right: 12.w, bottom: 3.h),
                    child: Text(tag!, style: FontPalette.white11Medium)
                        .avoidOverFlow(),
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    margin:
                        EdgeInsets.only(left: 12.w, right: 12.w, bottom: 3.h),
                    child: Text('', style: FontPalette.white11Medium)
                        .avoidOverFlow(),
                  ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    3.verticalSpace,
                    Text(
                      '${productName ?? ""}\n',
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
                      discountPrice ?? "",
                      maxLines: 1,
                      style: FontPalette.black16Bold,
                    ),
                    if (discount.notEmpty && discount != '0')
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          actualPrice ?? "",
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
      ),
    ).removeSplash();
  }
}
