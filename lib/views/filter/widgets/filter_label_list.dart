import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

import '../../../models/aggregation_list_model.dart';
import '../../../providers/search_product_listing_provider.dart';

class FilterLabelList extends StatelessWidget {
  FilterLabelList({Key? key, this.aggregationList}) : super(key: key);
  final List<Aggregations>? aggregationList;

  // final dataKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    SearchProductListingProvider productListingProvider =
        context.read<SearchProductListingProvider>();
    return Consumer<SearchProductListingProvider>(
      builder: (context, value, child) {
        // Scrollable.ensureVisible(dataKey.currentContext!);
        // scrollController.jumpTo(value);
        return ListView.builder(
          // key: dataKey,
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
      },
    );
  }
}
