import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/latest_offers_data_model.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class LatestOffersSlidingProducts extends StatelessWidget {
  const LatestOffersSlidingProducts({Key? key, this.content}) : super(key: key);

  final List<LatestOffersContent>? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: context.sw(size: 0.41),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  log('${content?[index].linkId}');
                  log('${content?[index].linkType}');
                  NavRoutes.instance.navByType(context,
                      content?[index].linkType, content?[index].linkId, '');
                },
                child: CommonFadeInImage(
                  image: content?[index].imageUrl,
                  width: context.sw(size: 0.778),
                  height: double.maxFinite,
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(
                  width: 6.w,
                ),
            itemCount: 2),
      ),
    ).convertToSliver();
  }
}
