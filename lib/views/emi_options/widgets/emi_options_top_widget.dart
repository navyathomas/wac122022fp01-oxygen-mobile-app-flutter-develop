import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:oxygen/common/extensions.dart';

class EmiOptionsTopWidget extends StatelessWidget {
  final Item? item;
  const EmiOptionsTopWidget({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discount = item?.priceRange?.maximumPrice?.discount?.percentOff;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
        child: Row(
          children: [
            SizedBox(
              height: constraints.maxWidth * .1968,
              width: constraints.maxWidth * .1968,
              child: CommonFadeInImage(image: item?.mediaGallery?.first?.url),
            ),
            20.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item?.name ?? ""),
                  5.verticalSpace,
                  RichText(
                    text: TextSpan(
                      children: [
                        if (item?.priceRange?.maximumPrice?.finalPrice?.value !=
                            null)
                          TextSpan(
                            text: item?.priceRange?.maximumPrice?.finalPrice
                                ?.value?.toRupee,
                            style: FontPalette.black16Bold,
                          ),
                        WidgetSpan(child: 10.horizontalSpace),
                        if (discount != null && discount.toString() != "0.0")
                          TextSpan(
                            text: item?.priceRange?.maximumPrice?.regularPrice
                                ?.value?.toRupee,
                            style: FontPalette.f7E818C_14RegularLineThrough,
                          ),
                        WidgetSpan(child: 10.horizontalSpace),
                        if (discount != null && discount.toString() != "0.0")
                          TextSpan(
                            text:
                                "${item?.priceRange?.maximumPrice?.discount?.percentOff?.round() ?? ""}% OFF",
                            style: FontPalette.fE50019_14Medium,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
