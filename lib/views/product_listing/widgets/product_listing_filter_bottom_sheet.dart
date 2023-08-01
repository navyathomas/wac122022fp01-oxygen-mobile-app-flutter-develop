import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/product_listing_provider.dart';

import '../../../common/constants.dart';
import '../../../models/aggregation_list_model.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio_button.dart';

class ProductListingFilterBottomSheet extends StatelessWidget {
  const ProductListingFilterBottomSheet(
      {Key? key,
      required this.sortOptionsList,
      required this.productListingProvider,
      required this.categoryId,
      required this.scrollController})
      : super(key: key);
  final List<SortOptions>? sortOptionsList;
  final ProductListingProvider productListingProvider;
  final String categoryId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.filters, style: FontPalette.black18Medium),
                22.verticalSpace,
                ListView.builder(
                  itemCount:
                      sortOptionsList.notEmpty ? sortOptionsList!.length : 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        productListingProvider
                          ..updateSortValuesIndex(index)
                          ..assignValuesToSortMap()
                          ..getProductDetails(categoryId);
                        scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastLinearToSlowEaseIn);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 25.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sortOptionsList?[index].label ?? '',
                              style: FontPalette.black16Regular,
                            ),
                            CustomRadioButton(
                                isSelected:
                                    productListingProvider.sortOrderIndex ==
                                        index)
                          ],
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
              ]));
    });
  }
}
