import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

import '../../../../models/home_data_model.dart';

class HomeBannerSlider extends StatelessWidget {
  final List<Content>? contentData;

  const HomeBannerSlider({Key? key, this.contentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sw(size: 0.41),
      margin: EdgeInsets.only(top: 20.h),
      child: ListView.separated(
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                NavRoutes.instance.navByType(
                  context,
                  contentData?[index].linkType,
                  contentData?[index].linkId,
                  contentData?[index].categoryPage,
                );
              },
              child: CachedImageView(
                image: contentData?[index].imageUrl ?? '',
                width: context.sw(size: 0.778),
                height: double.maxFinite,
              ),
            );
          },
          separatorBuilder: (_, __) => SizedBox(
                width: 6.w,
              ),
          itemCount: contentData?.length ?? 0),
    ).convertToSliver();
  }
}
