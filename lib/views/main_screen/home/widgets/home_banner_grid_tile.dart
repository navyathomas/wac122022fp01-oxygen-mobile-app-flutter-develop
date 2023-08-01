import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/home_data_model.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_title_tile.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

import '../../../../common/route_generator.dart';
import '../../../../models/arguments/product_listing_arguments.dart';

class HomeBannerGridTile extends StatelessWidget {
  final HomeData? homeData;
  final String? linkId;

  const HomeBannerGridTile({Key? key, this.homeData, this.linkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeTitleTile(
          title: homeData?.title ?? '',
          onTap: linkId.notEmpty
              ? () {
                  Navigator.pushNamed(
                      context, RouteGenerator.routeProductListingScreen,
                      arguments: ProductListingArguments(
                          categoryId: linkId!, title: homeData?.title ?? ''));
                }
              : null,
        ),
        if ((homeData?.mainImageData?.imageUrl ?? '').isNotEmpty) ...[
          InkWell(
            onTap: () {
              NavRoutes.instance.navByType(
                  context,
                  homeData?.mainImageData?.linkType,
                  homeData?.mainImageData?.linkId,
                  "");
            },
            child: CachedImageView(
              image: homeData?.mainImageData?.imageUrl ?? '',
              height: context.sw(size: 0.48),
              width: double.maxFinite,
            ),
          ),
          12.verticalSpace
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: LayoutBuilder(builder: (context, constraints) {
            return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.w,
                    mainAxisSpacing: 6.r,
                    mainAxisExtent: context.sw(size: 0.4747)),
                itemCount: homeData?.content?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      NavRoutes.instance.navByType(
                          context,
                          homeData?.content?[index].linkType,
                          homeData?.content?[index].linkId,
                          homeData?.content?[index].categoryPage);
                    },
                    child: CachedImageView(
                      image: homeData?.content?[index].imageUrl ?? '',
                      height: double.maxFinite,
                      width: double.maxFinite,
                      boxFit: BoxFit.cover,
                    ),
                  );
                });
          }),
        )
      ],
    ).convertToSliver();
  }
}
