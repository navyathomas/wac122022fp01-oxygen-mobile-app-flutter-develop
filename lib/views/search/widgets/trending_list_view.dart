import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../providers/search_provider.dart';

class TrendingListView extends StatelessWidget {
  const TrendingListView(
      {Key? key,
      required this.trendingSearchList,
      required this.searchProvider})
      : super(key: key);
  final List<String> trendingSearchList;
  final SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          18.verticalSpace,
          Text(
            'Trending Searches',
            style: FontPalette.black16Medium,
          ),
          12.verticalSpace,
          Wrap(
            spacing: 8.r,
            runSpacing: 12.r,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(
              trendingSearchList.length,
              (index) => InkWell(
                onTap: () =>
                    _searchKeyOnTileTap(context, trendingSearchList[index]),
                child: Container(
                    height: 30.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: HexColor('#E6E6E6'),
                      ),
                    ),
                    child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(children: [
                          WidgetSpan(
                              child: Container(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: SvgPicture.asset(
                              Assets.iconsArrowUpLeft,
                              height: 11.h,
                              width: 11.w,
                              fit: BoxFit.fill,
                            ),
                          )),
                          WidgetSpan(
                              child: Container(
                            padding: EdgeInsets.only(top: 2.h, left: 10.w),
                            child: Text(trendingSearchList[index],
                                style: FontPalette.black14Regular),
                          ))
                          //TextSpan(text: 'I phone', style: FontPalette.black14Regular)
                        ]))),
              ),
            ),
          ),
          10.verticalSpace
        ],
      ),
    );
  }

  void _searchKeyOnTileTap(BuildContext context, String item) {
    searchProvider.updateSearchProduct(item);
    searchProvider.searchController.text = item;
    searchProvider.searchProduct(item);
    searchProvider.getRecentlySearchedKeys();
    if (searchProvider.searchController.text.trim().isNotEmpty) {
      searchProvider.searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchProvider.searchController.text.length));
    }
  }
}
