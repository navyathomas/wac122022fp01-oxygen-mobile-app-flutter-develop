import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class CategoryDetailedTopCategory extends StatelessWidget {
  final List<DetailContent?>? content;

  const CategoryDetailedTopCategory({Key? key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * .3467,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: content?.length ?? 0,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = content?.elementAt(index);
              return GestureDetector(
                onTap: () {
                  NavRoutes.instance.navByType(context, item?.linkType,
                      item?.linkId, item?.categoryPage);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorPalette.shimmerBaseColor,
                        shape: BoxShape.circle,
                      ),
                      height: constraints.maxWidth * .2027,
                      width: constraints.maxWidth * .2027,
                      clipBehavior: Clip.antiAlias,
                      child: CommonFadeInImage(
                        image: item?.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      item?.imageText ?? "",
                      maxLines: 1,
                      style: FontPalette.black13Regular,
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => 11.horizontalSpace,
          ),
        );
      },
    ).convertToSliver();
  }
}
