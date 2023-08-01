import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/filter/widgets/filter_label_list.dart';
import 'package:oxygen/views/filter/widgets/filter_value_list.dart';
import 'package:oxygen/views/order_complete/widgets/continue_shopping_button.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../providers/search_product_listing_provider.dart';
import '../../providers/search_provider.dart';
import '../../utils/color_palette.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen(
      {Key? key,
      required this.scrollController,
      required this.searchProductListingProvider,
      this.searchProvider})
      : super(key: key);
  final ScrollController scrollController;
  final SearchProductListingProvider searchProductListingProvider;
  final SearchProvider? searchProvider;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      widget.searchProductListingProvider.updateAggregationOptionsList(
          widget.searchProductListingProvider.selectedAggregationTab);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.searchProductListingProvider,
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
                  onTap: () => widget.searchProductListingProvider
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
          child: Consumer<SearchProductListingProvider>(
            builder: (context, productListingProvider, child) {
              return Stack(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                          color: HexColor('#F4F4F4'),
                          child: FilterLabelList(
                            aggregationList:
                                productListingProvider.aggregationsList,
                          ),
                        )),
                    Flexible(
                        flex: 2,
                        child: FilterValueList(
                          aggregateOptionsList: productListingProvider
                                      .aggregationsList[productListingProvider
                                          .selectedAggregationTab]
                                      .attributeCode ==
                                  'price'
                              ? productListingProvider.priceValueList
                              : productListingProvider.aggregateOptionsList,
                        )),
                  ],
                ),
                ContinueShoppingButton(
                  buttonText: Constants.showResults,
                  onTap: () {
                    productListingProvider
                      ..assignValuesToFilterMap()
                      ..clearPageLoader()
                      ..getSearchProductDetails(
                          widget.searchProvider?.productItem ?? '')
                      ..getAggregationsList(
                          widget.searchProvider?.productItem ?? '');
                    widget.scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastLinearToSlowEaseIn);
                    Navigator.pop(context);
                  },
                )
              ]);
            },
          ),
        ),
      ),
    );
  }
}
