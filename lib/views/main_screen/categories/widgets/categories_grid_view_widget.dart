import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/product_listing_arguments.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

import '../../../../models/category_model.dart';

class CategoriesGridViewWidget extends StatelessWidget {
  final List<CategoryContent>? categoryContentList;
  final bool enableShrink;

  const CategoriesGridViewWidget(
      {Key? key, this.categoryContentList, this.enableShrink = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: (categoryContentList ?? []).notEmpty
          ? categoryContentList!.length
          : 0,
      shrinkWrap: enableShrink,
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.h),
      physics: enableShrink ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.r,
          mainAxisSpacing: 20.r,
          mainAxisExtent: context.sw(size: .3547)),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              RouteGenerator.routeProductListingScreen,
              arguments: ProductListingArguments(
                  categoryId: categoryContentList?[index].id ?? '',
                  title: categoryContentList?[index].name ?? '')),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#F4F4F4"),
                    shape: BoxShape.circle,
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: EdgeInsets.all(22.r),
                          child: CommonFadeInImageWithCache(
                            image: categoryContentList![index].image ?? '',
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              6.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text('${categoryContentList![index].name ?? ''}\n',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: FontPalette.black13Regular),
              ),
            ],
          ),
        );
      },
    );
  }
}
