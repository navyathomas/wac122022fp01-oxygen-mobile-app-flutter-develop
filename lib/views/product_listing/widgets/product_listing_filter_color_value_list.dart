import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/aggregation_list_model.dart';
import '../../../providers/product_listing_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_check_box.dart';

class ProductListingFilterColorValueList extends StatelessWidget {
  const ProductListingFilterColorValueList(
      {Key? key,
      required this.aggregateOptions,
      required this.isSelected,
      required this.productListingProvider})
      : super(key: key);
  final AggregateOptions? aggregateOptions;
  final bool isSelected;
  final ProductListingProvider productListingProvider;

  @override
  Widget build(BuildContext context) {
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
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
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
