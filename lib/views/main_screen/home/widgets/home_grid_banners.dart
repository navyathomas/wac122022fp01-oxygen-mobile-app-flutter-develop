import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

import '../../../../common/route_generator.dart';
import '../../../../models/arguments/product_listing_arguments.dart';
import '../../../../models/home_data_model.dart';
import 'home_title_tile.dart';

class HomeGridTile extends StatelessWidget {
  final String? title;
  final String? linkId;
  final List<Content>? contentData;

  const HomeGridTile({Key? key, this.title, this.contentData, this.linkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeTitleTile(
          title: title ?? '',
          onTap: linkId.notEmpty
              ? () {
                  Navigator.pushNamed(
                      context, RouteGenerator.routeProductListingScreen,
                      arguments: ProductListingArguments(
                          categoryId: linkId!, title: title ?? ''));
                }
              : null,
        ),
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
                itemCount: contentData?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      NavRoutes.instance.navByType(
                          context,
                          contentData?[index].linkType,
                          contentData?[index].linkId,
                          contentData?[index].title,
                          contentData: contentData?[index]);
                    },
                    child: CachedImageView(
                      image: contentData?[index].imageUrl ?? '',
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
