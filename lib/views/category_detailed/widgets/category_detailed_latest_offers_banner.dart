import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class CategoryDetailedLatestOffersBanner extends StatelessWidget {
  final List<DetailContent?>? content;

  const CategoryDetailedLatestOffersBanner({Key? key, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.sw(size: 0.41),
      margin: EdgeInsets.only(bottom: 18.h),
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = content?.elementAt(index);
            return GestureDetector(
              onTap: () {
                NavRoutes.instance.navByType(
                    context, item?.linkType, item?.linkId, item?.categoryPage);
              },
              child: SizedBox(
                width: context.sw(size: 0.778),
                height: double.maxFinite,
                child: CommonFadeInImage(
                  image: item?.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => SizedBox(
                width: 6.w,
              ),
          itemCount: content?.length ?? 0),
    ).convertToSliver();
  }
}
