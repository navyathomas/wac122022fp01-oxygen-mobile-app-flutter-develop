import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/views/product_listing/widgets/compare_product_list_view.dart';
import 'package:oxygen/widgets/custom_btn.dart';

import '../../../common/constants.dart';
import '../../../models/compare_products_model.dart';

class ProductListingCompareBottomWidget extends StatefulWidget {
  const ProductListingCompareBottomWidget({Key? key}) : super(key: key);

  @override
  State<ProductListingCompareBottomWidget> createState() =>
      _ProductListingCompareBottomWidgetState();
}

class _ProductListingCompareBottomWidgetState
    extends State<ProductListingCompareBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 168.h,
        width: double.maxFinite,
        decoration: CommonStyles.bottomDecoration,
        child: ValueListenableBuilder<Box<CompareProducts>>(
          valueListenable: Hive.box<CompareProducts>(
                  HiveServices.instance.compareProductBoxName)
              .listenable(),
          builder: (context, box, child) {
            return Column(
              children: [
                12.verticalSpace,
                CompareProductListView(
                  compareProductsList: [...box.values],
                ),
                9.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: CustomButton(
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        RouteGenerator.routeCompareScreen,
                      );
                    },
                    title: box.values.length > 1
                        ? Constants.compareNow
                        : Constants.addProducts,
                    enabled: box.values.length > 1 ? true : false,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
