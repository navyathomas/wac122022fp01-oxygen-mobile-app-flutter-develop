import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/views/shimmers/widgets/recently_viewed_widget.dart';
import 'package:oxygen/views/shimmers/widgets/search_tile_widget.dart';
import 'package:oxygen/views/shimmers/widgets/trending_search_widget.dart';

class SearchTileShimmer extends StatelessWidget {
  const SearchTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      10.verticalSpace,
      const SearchTileWidget(),
      30.verticalSpace,
      const TrendingSearchWidget(),
      30.verticalSpace,
      const RecentlyViewedWidget()
    ]).addShimmer();
  }
}
