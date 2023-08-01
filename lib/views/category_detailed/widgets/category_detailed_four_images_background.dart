import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class CategoryDetailedFourColumnImagesBackground extends StatelessWidget {
  final String? title;
  final String? titleColor;
  final String? backgroundImage;
  final List<DetailContent?>? content;

  const CategoryDetailedFourColumnImagesBackground({
    Key? key,
    this.title,
    this.titleColor,
    this.backgroundImage,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: SizedBox(
        height: context.sw(size: 1.1467),
        width: double.maxFinite,
        child: Stack(
          children: [
            CommonFadeInImage(
              image: backgroundImage,
              fit: BoxFit.cover,
            ),
            Container(
              height: double.maxFinite,
              padding: EdgeInsets.only(
                  top: 18.h, bottom: 12.h, left: 12.w, right: 12.w),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "",
                        maxLines: 1,
                        style: FontPalette.black20Medium
                            .copyWith(color: HexColor(titleColor ?? "#000000")),
                      ),
                      12.verticalSpace,
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6.r,
                                      mainAxisSpacing: 6.r,
                                      mainAxisExtent:
                                          (constraints.maxHeight / 2) - 3.r),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                final item = content?.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    NavRoutes.instance.navByType(
                                      context,
                                      item?.linkType,
                                      item?.linkId,
                                      item?.categoryPage,
                                      filterPrice: item?.filterPrice,
                                    );
                                  },
                                  child: CommonFadeInImage(
                                    image: item?.imageUrl,
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).convertToSliver();
  }
}
