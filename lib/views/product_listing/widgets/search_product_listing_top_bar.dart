import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/arguments/search_filter_arguments.dart';
import 'package:oxygen/providers/search_provider.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../generated/assets.dart';
import '../../../providers/search_product_listing_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../my_orders/widgets/my_orders_modal_bottom_sheet.dart';

class SearchProductListingTopBar extends StatelessWidget {
  const SearchProductListingTopBar(
      {Key? key,
      required this.searchProductListingProvider,
      required this.scrollController,
      this.searchProvider})
      : super(key: key);
  final SearchProductListingProvider searchProductListingProvider;
  final ScrollController scrollController;
  final SearchProvider? searchProvider;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 40.h,
      pinned: false,
      snap: false,
      floating: true,
      automaticallyImplyLeading: false,
      elevation: .5,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Padding(
          padding: EdgeInsets.zero,
        ),
      ),
      flexibleSpace: Container(
        height: 40.h,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: HexColor("#E6E6E6")))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: (searchProductListingProvider
                            .aggregationsList.notEmpty &&
                        searchProductListingProvider.sortOptionsList.notEmpty)
                    ? () {
                        sortFunction(context);
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(Constants.sort.toUpperCase(),
                            maxLines: 1,
                            style: FontPalette.black14Medium.copyWith(
                                color: searchProductListingProvider
                                            .aggregationsList.notEmpty &&
                                        searchProductListingProvider
                                            .sortOptionsList.notEmpty
                                    ? Colors.black
                                    : Colors.black.withOpacity(.5))),
                      ),
                      7.5.horizontalSpace,
                      SizedBox.square(
                        dimension: 14.r,
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: SvgPicture.asset(
                            Assets.iconsRightArrow,
                            color: searchProductListingProvider
                                        .aggregationsList.notEmpty &&
                                    searchProductListingProvider
                                        .sortOptionsList.notEmpty
                                ? Colors.black
                                : Colors.black.withOpacity(.5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1.w, color: HexColor("#E6E6E6"), height: 26.h),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: searchProductListingProvider.aggregationsList.notEmpty ||
                        searchProductListingProvider.valueList.notEmpty
                    ? () {
                        searchProductListingProvider
                            .updateSelectedAggregationTab(0);
                        Navigator.pushNamed(
                            context, RouteGenerator.routeFilterScreen,
                            arguments: SearchFilterArguments(
                                scrollController: scrollController,
                                searchProductListingProvider:
                                    searchProductListingProvider,
                                searchProvider: searchProvider));
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.square(
                        dimension: 16.r,
                        child: SvgPicture.asset(
                          Assets.iconsFilter,
                          color: searchProductListingProvider
                                      .aggregationsList.notEmpty ||
                                  searchProductListingProvider
                                      .valueList.notEmpty
                              ? Colors.black
                              : Colors.black.withOpacity(.5),
                        ),
                      ),
                      7.5.horizontalSpace,
                      Flexible(
                        child: Text(Constants.filter.toUpperCase(),
                            maxLines: 1,
                            style: FontPalette.black14Medium.copyWith(
                                color: searchProductListingProvider
                                            .aggregationsList.notEmpty ||
                                        searchProductListingProvider
                                            .valueList.notEmpty
                                    ? Colors.black
                                    : Colors.black.withOpacity(.5))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1.w, color: HexColor("#E6E6E6"), height: 26.h),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: InkWell(
                  onTap: () =>
                      searchProductListingProvider.updateIsCompareTapped(
                          !searchProductListingProvider.isCompareTapped),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.square(
                        dimension: 16.r,
                        child: SvgPicture.asset(
                          Assets.iconsCompare,
                          color: searchProductListingProvider.isCompareTapped
                              ? HexColor('#E50019')
                              : Colors.black,
                        ),
                      ),
                      7.5.horizontalSpace,
                      Flexible(
                        child: Text(Constants.compare.toUpperCase(),
                            maxLines: 1,
                            style: FontPalette.black14Medium.copyWith(
                              color:
                                  searchProductListingProvider.isCompareTapped
                                      ? HexColor('#E50019')
                                      : Colors.black,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1.w, color: HexColor("#E6E6E6"), height: 26.h),
            InkWell(
              onTap: () => searchProductListingProvider.changeView(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: SizedBox.square(
                  dimension: 16.r,
                  child: SvgPicture.asset(
                    searchProductListingProvider.isListView
                        ? Assets.iconsGridView
                        : Assets.iconsProductList,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sortFunction(BuildContext context) {
    searchProductListingProvider.getSortOrderIndex(
        searchProductListingProvider.sortOrderValue ?? '',
        searchProductListingProvider.sortDirection ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: HexColor("#282C3F").withOpacity(.46),
      builder: (context) => FilterBottomSheet(
        searchProductListingProvider: searchProductListingProvider,
        sortOptionsList: searchProductListingProvider.sortOptionsList,
        scrollController: scrollController,
        searchProvider: searchProvider,
      ),
    );
  }
}
