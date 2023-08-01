import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/generated/assets.dart';

import '../../../../models/home_data_model.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/common_fade_in_image.dart';

class HomeCategories extends StatelessWidget {
  final List<Content>? contentData;

  const HomeCategories({Key? key, this.contentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            onTap: () => NavRoutes.instance.navByType(
                context,
                contentData?[index].linkType ?? '',
                contentData?[index].linkId ?? '',
                contentData?[index].categoryPage ?? '',
                title: contentData?[index].imageText ?? ''),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      height: constraints.maxWidth,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: HexColor("#F4F4F4"),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: CommonFadeInImage(
                            placeHolderImage: Assets.imagesBlankImage,
                            image: contentData?[index].image ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                6.verticalSpace,
                Text(contentData?[index].imageText ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: FontPalette.black13Regular),
              ],
            ),
          );
        }, childCount: contentData?.length ?? 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          mainAxisExtent: (context.sw() - 24.w) * 0.2667,
          /*constraints.maxWidth /
              (constraints.maxHeight / 1)*/
        ),
      ),
    );
  }
}
