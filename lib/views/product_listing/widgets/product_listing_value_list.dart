import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/product_listing_provider.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_filter_color_value_list.dart';

import '../../../models/aggregation_list_model.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_check_box.dart';

class ProductListingFilterValueList extends StatelessWidget {
  const ProductListingFilterValueList(
      {Key? key,
      this.aggregateOptionsList,
      required this.productListingProvider})
      : super(key: key);
  final List<AggregateOptions>? aggregateOptionsList;
  final ProductListingProvider productListingProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount:
          aggregateOptionsList.notEmpty ? aggregateOptionsList!.length : 0,
      itemBuilder: (context, index) {
        return productListingProvider.aggregationsList.notEmpty
            ? productListingProvider
                            .aggregationsList[
                                productListingProvider.selectedAggregationTab]
                            .attributeCode ==
                        'color_group' &&
                    (aggregateOptionsList?[index].swatchData?.value ?? '')
                        .isNotEmpty
                ? ProductListingFilterColorValueList(
                    productListingProvider: productListingProvider,
                    aggregateOptions: aggregateOptionsList?[index],
                    isSelected: productListingProvider.valueList
                            .contains(aggregateOptionsList?[index].value)
                        ? true
                        : false,
                  )
                : InkWell(
                    onTap: () {
                      productListingProvider.assignValuesToTempFilterMap(
                          productListingProvider
                                  .aggregationsList[productListingProvider
                                      .selectedAggregationTab]
                                  .attributeCode ??
                              '',
                          aggregateOptionsList![index].value);
                      productListingProvider.updateSelectedAggregationTab(
                          productListingProvider.selectedAggregationTab);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 20.w, left: 20.w, top: 12.h, bottom: 12.h),
                      child: Row(
                        children: [
                          CustomCheckBox(
                            isSelected: productListingProvider.valueList
                                    .contains(
                                        aggregateOptionsList?[index].value)
                                ? true
                                : false,
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              aggregateOptionsList![index].label ?? '',
                              style: FontPalette.black14Medium,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
            : const SizedBox.shrink();
      },
      shrinkWrap: true,
    );
  }
}
