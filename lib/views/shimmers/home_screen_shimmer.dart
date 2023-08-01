import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/views/shimmers/widgets/banner_shimmer.dart';
import 'package:oxygen/views/shimmers/widgets/category_grid_view_shimmer.dart';
import 'package:oxygen/views/shimmers/widgets/emi_shimmer.dart';
import 'package:oxygen/views/shimmers/widgets/horizontal_produt_list_shimmer.dart';
import 'package:oxygen/views/shimmers/widgets/products_grid_view_shimmer.dart';
import 'package:oxygen/views/shimmers/widgets/title_heading_shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const BannerShimmer(),
        19.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const EmiShimmer(),
        ),
        19.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const CategoryGridViewShimmer(),
        ),
        19.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const TitleHeadingShimmer(),
        ),
        19.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const ProductsGridViewShimmer(),
        ),
        19.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: const TitleHeadingShimmer(),
        ),
        19.verticalSpace,
        const HorizontalProductListShimmer(),
        50.verticalSpace,
      ],
    ).addShimmer();
  }
}
