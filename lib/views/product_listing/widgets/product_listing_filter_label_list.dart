import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/product_listing_provider.dart';

import '../../../models/aggregation_list_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class ProductListingFilterLabelList extends StatelessWidget {
  ProductListingFilterLabelList({
    Key? key,
    this.aggregationList,
    required this.productListingProvider,
  }) : super(key: key);
  final List<Aggregations>? aggregationList;
  final ProductListingProvider productListingProvider;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: aggregationList.notEmpty ? aggregationList!.length : 0,
      padding: EdgeInsets.only(bottom: 10.h),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            productListingProvider.updateSelectedAggregationTab(index);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 22.h),
            color: index == productListingProvider.selectedAggregationTab
                ? Colors.white
                : HexColor('#F4F4F4'),
            child: Text(
              aggregationList![index].label ?? "",
              textAlign: TextAlign.start,
              style: index == productListingProvider.selectedAggregationTab
                  ? FontPalette.black14Medium
                      .copyWith(color: HexColor('#E50019'))
                  : FontPalette.black14Medium,
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
