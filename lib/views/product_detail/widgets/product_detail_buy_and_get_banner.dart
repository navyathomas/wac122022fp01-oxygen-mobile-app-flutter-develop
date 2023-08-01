import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:provider/provider.dart';

class ProductDetailBuyAndGetBanner extends StatelessWidget {
  const ProductDetailBuyAndGetBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          return (value?.buyAndGetBanner?.url?.isEmpty ?? true)
              ? const SizedBox.shrink()
              : ColoredBox(
                  color: Colors.white,
                  child: Container(
                    width: double.maxFinite,
                    height: context.sw() * .408,
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: CommonCachedNetworkImage(
                        image: value?.buyAndGetBanner?.url,
                        fit: BoxFit.cover,
                        imageErrorWidget: Container(
                          color: Colors.white,
                        ).addShimmer()),
                  ),
                );
        });
  }
}
