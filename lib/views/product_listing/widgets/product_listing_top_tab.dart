import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/product_listing_provider.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_filter_bottom_sheet.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../generated/assets.dart';
import '../../../models/arguments/filter_arguments.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class ProductListingTopTab extends StatelessWidget {
  const ProductListingTopTab(
      {Key? key,
      required this.productListingProvider,
      required this.categoryId,
      required this.scrollController})
      : super(key: key);
  final ProductListingProvider productListingProvider;
  final String categoryId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 40.h,
      pinned: false,
      snap: false,
      floating: true,
      automaticallyImplyLeading: false,
      elevation: .5,
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
                onTap: productListingProvider.aggregationsList.notEmpty &&
                        productListingProvider.sortOptionsList.notEmpty
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
                        child: FittedBox(
                          child: Text(Constants.sort.toUpperCase(),
                              maxLines: 1,
                              style: FontPalette.black14Medium.copyWith(
                                  color: productListingProvider
                                              .aggregationsList.notEmpty &&
                                          productListingProvider
                                              .sortOptionsList.notEmpty
                                      ? Colors.black
                                      : Colors.black.withOpacity(.5))),
                        ),
                      ),
                      7.5.horizontalSpace,
                      SizedBox.square(
                        dimension: 14.r,
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: SvgPicture.asset(
                            Assets.iconsRightArrow,
                            color: productListingProvider
                                        .aggregationsList.notEmpty &&
                                    productListingProvider
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
                onTap: productListingProvider.aggregationsList.notEmpty ||
                        productListingProvider.valueList.notEmpty
                    ? () {
                        productListingProvider.updateSelectedAggregationTab(0);
                        Navigator.pushNamed(context,
                                RouteGenerator.routeProductListingFilterScreen,
                                arguments: FilterArguments(
                                    context: context,
                                    categoryId: categoryId,
                                    productListingProvider:
                                        productListingProvider,
                                    scrollController: scrollController))
                            .then((value) {
                          // clearTempValueList();
                        });
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
                          color: productListingProvider
                                      .aggregationsList.notEmpty ||
                                  productListingProvider.valueList.notEmpty
                              ? Colors.black
                              : Colors.black.withOpacity(.5),
                        ),
                      ),
                      7.5.horizontalSpace,
                      Flexible(
                        child: FittedBox(
                          child: Text(Constants.filter.toUpperCase(),
                              maxLines: 1,
                              style: FontPalette.black14Medium.copyWith(
                                  color: productListingProvider
                                              .aggregationsList.notEmpty ||
                                          productListingProvider
                                              .valueList.notEmpty
                                      ? Colors.black
                                      : Colors.black.withOpacity(.5))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1.w, color: HexColor("#E6E6E6"), height: 26.h),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () => productListingProvider.updateIsCompareTapped(
                    !productListingProvider.isCompareTapped),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox.square(
                        dimension: 16.r,
                        child: productListingProvider.isCompareTapped
                            ? SvgPicture.asset(
                                Assets.iconsCompare,
                                color: ColorPalette.primaryColor,
                              )
                            : SvgPicture.asset(Assets.iconsCompare,
                                color: Colors.black),
                      ),
                    ),
                    7.5.horizontalSpace,
                    Flexible(
                      child: FittedBox(
                        child: Text(Constants.compare.toUpperCase(),
                            maxLines: 1,
                            style: FontPalette.black14Medium.copyWith(
                                color: productListingProvider.isCompareTapped
                                    ? HexColor('#E50019')
                                    : Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1.w, color: HexColor("#E6E6E6"), height: 26.h),
            InkWell(
              onTap: () => productListingProvider.changeView(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: SizedBox.square(
                  dimension: 16.r,
                  child: SvgPicture.asset(
                    productListingProvider.isListView
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
    productListingProvider.getSortOrderIndex(
        productListingProvider.sortOrderValue ?? '',
        productListingProvider.sortDirection ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: HexColor("#282C3F").withOpacity(.46),
      builder: (context) => ProductListingFilterBottomSheet(
        sortOptionsList: productListingProvider.sortOptionsList,
        categoryId: categoryId,
        productListingProvider: productListingProvider,
        scrollController: scrollController,
      ),
    );
  }
}
