import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/providers/product_listing_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_filter_label_list.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_value_list.dart';
import 'package:provider/provider.dart';

import '../../common/common_function.dart';
import '../../common/constants.dart';
import '../../utils/font_palette.dart';
import '../../widgets/common_appbar.dart';
import '../order_complete/widgets/continue_shopping_button.dart';

class ProductListingFilterScreen extends StatefulWidget {
  const ProductListingFilterScreen(
      {Key? key,
      required this.productListingProvider,
      required this.categoryId,
      required this.scrollController})
      : super(key: key);
  final ProductListingProvider productListingProvider;
  final String categoryId;
  final ScrollController scrollController;

  @override
  State<ProductListingFilterScreen> createState() =>
      _ProductListingFilterScreenState();
}

class _ProductListingFilterScreenState
    extends State<ProductListingFilterScreen> {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      widget.productListingProvider.updateAggregationOptionsList(
          widget.productListingProvider.selectedAggregationTab);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.productListingProvider,
      child: Scaffold(
          appBar: CommonAppBar(
            buildContext: context,
            titleWidget: Text(
              Constants.filterBy,
              style: FontPalette.black18Medium,
            ),
            actionList: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.5.w),
                  child: InkWell(
                    highlightColor: Colors.grey.shade200,
                    splashColor: Colors.grey.shade300,
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r)),
                    onTap: () => widget.productListingProvider
                        .clearFilterMap(isFromSort: false),
                    child: Padding(
                      padding: EdgeInsets.all(7.w),
                      child: Text(
                        Constants.clearAll,
                        style: FontPalette.black16Regular,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Consumer<ProductListingProvider>(
              builder: (context, value, child) {
                return Column(children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              color: HexColor('#F4F4F4'),
                              child: ProductListingFilterLabelList(
                                productListingProvider:
                                    widget.productListingProvider,
                                aggregationList: widget
                                    .productListingProvider.aggregationsList,
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            child: ProductListingFilterValueList(
                              productListingProvider:
                                  widget.productListingProvider,
                              aggregateOptionsList: widget
                                          .productListingProvider
                                          .aggregationsList[widget
                                              .productListingProvider
                                              .selectedAggregationTab]
                                          .attributeCode ==
                                      'price'
                                  ? widget.productListingProvider.priceValueList
                                  : widget.productListingProvider
                                      .aggregateOptionsList,
                            )),
                      ],
                    ),
                  ),
                  ContinueShoppingButton(
                    buttonText: Constants.showResults,
                    onTap: () {
                      widget.productListingProvider
                        ..assignValuesToFilterMap()
                        ..clearPageLoader()
                        ..getProductDetails(widget.categoryId)
                        ..getAggregationsList(widget.categoryId);
                      widget.scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn);
                      Navigator.pop(context);
                    },
                  )
                ]);
              },
            ),
          )),
    );
  }
}
