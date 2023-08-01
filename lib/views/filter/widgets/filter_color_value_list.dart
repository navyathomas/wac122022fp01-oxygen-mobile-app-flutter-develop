import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/aggregation_list_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_product_listing_provider.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_check_box.dart';

class FilterColorValueList extends StatelessWidget {
  const FilterColorValueList(
      {Key? key, required this.aggregateOptions, required this.isSelected})
      : super(key: key);
  final AggregateOptions? aggregateOptions;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    SearchProductListingProvider productListingProvider =
        context.read<SearchProductListingProvider>();
    return InkWell(
      onTap: () {
        productListingProvider.assignValuesToTempFilterMap(
            productListingProvider
                    .aggregationsList[
                        productListingProvider.selectedAggregationTab]
                    .attributeCode ??
                '',
            aggregateOptions?.value);
        productListingProvider.updateSelectedAggregationTab(
            productListingProvider.selectedAggregationTab);
      },
      child: Padding(
        padding:
            EdgeInsets.only(right: 20.w, left: 20.w, top: 22.h, bottom: 7.h),
        child: Row(
          children: [
            CustomCheckBox(
              isSelected: isSelected,
            ),
            8.horizontalSpace,
            Container(
              height: 20.h,
              width: 20.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  shape: BoxShape.circle,
                  color: HexColor(
                      aggregateOptions?.swatchData?.value ?? '0x00000000')),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                aggregateOptions?.label ?? '',
                style: FontPalette.black14Medium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
