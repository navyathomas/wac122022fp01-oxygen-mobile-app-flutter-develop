import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class ProductDetailKeyFeaturesWidget extends StatelessWidget {
  const ProductDetailKeyFeaturesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          final tagHighlights = value?.highlight;
          final List<String>? splitHighlights = tagHighlights?.split(',');
          return (tagHighlights == null || tagHighlights.isEmpty)
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.keyFeatures,
                          style: FontPalette.black16Medium,
                        ),
                        12.verticalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            splitHighlights?.length ?? 0,
                            (index) => Column(
                              children: [
                                Text(
                                  splitHighlights?.elementAt(index).trim() ??
                                      "",
                                  style: FontPalette.black14Regular,
                                ),
                                7.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
