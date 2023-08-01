import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/models/home_data_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class CategoryDetailedFourColumnImages extends StatelessWidget {
  final String? title;
  final String? titleColor;
  final List<DetailContent?>? content;

  const CategoryDetailedFourColumnImages({
    Key? key,
    this.title,
    this.titleColor,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "",
              style: FontPalette.black20Medium
                  .copyWith(color: HexColor(titleColor ?? "#000000"))),
          12.verticalSpace,
          GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 6.r,
                  mainAxisExtent: context.sw(size: 0.4747)),
              itemCount: content?.length,
              itemBuilder: (context, index) {
                final item = content?.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    NavRoutes.instance.navByType(context, item?.linkType,
                        item?.linkId, item?.categoryPage,
                        filterPrice: item?.filterPrice,
                        contentData: Content(
                            attribute: content?[index]?.attribute ?? '',
                            attributeType: content?[index]?.attributeType ?? '',
                            filterType: content?[index]?.filterType ?? ''));
                  },
                  child: ColoredBox(
                    color: ColorPalette.shimmerHighlightColor,
                    child: CommonFadeInImage(
                      image: item?.imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
          18.verticalSpace,
        ],
      ),
    ).convertToSliver();
  }
}
