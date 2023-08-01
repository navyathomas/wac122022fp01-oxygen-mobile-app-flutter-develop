import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/filter/widgets/filter_color_value_list.dart';
import 'package:oxygen/widgets/custom_check_box.dart';
import 'package:provider/provider.dart';

import '../../../models/aggregation_list_model.dart';
import '../../../providers/search_product_listing_provider.dart';

class FilterValueList extends StatelessWidget {
  const FilterValueList({Key? key, this.aggregateOptionsList})
      : super(key: key);
  final List<AggregateOptions>? aggregateOptionsList;

  @override
  Widget build(BuildContext context) {
    SearchProductListingProvider productListingProvider =
        context.read<SearchProductListingProvider>();
    return Consumer<SearchProductListingProvider>(
      builder: (context, value, child) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount:
              aggregateOptionsList.notEmpty ? aggregateOptionsList!.length : 0,
          padding: EdgeInsets.only(bottom: 10.h),
          itemBuilder: (context, index) {
            return productListingProvider.aggregationsList.notEmpty
                ? productListingProvider
                                .aggregationsList[productListingProvider
                                    .selectedAggregationTab]
                                .attributeCode ==
                            'color_group' &&
                        (aggregateOptionsList?[index].swatchData?.value ?? '')
                            .isNotEmpty
                    ? FilterColorValueList(
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
      },
    );
  }
}
