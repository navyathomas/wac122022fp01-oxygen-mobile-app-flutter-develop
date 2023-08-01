import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';

class ProductListingGridViewShimmer extends StatelessWidget {
  const ProductListingGridViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.shimmerBaseColor,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            crossAxisCount: 2,
            mainAxisExtent: 285.h),
        itemCount: 10,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Expanded(child: Container(color: Colors.white)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(height: 14.h, color: Colors.white),
                        Container(height: 14.h, color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 14.h,
                                width: constraints.maxWidth * 0.50,
                                color: Colors.white),
                            Container(
                                height: 14.h,
                                width: constraints.maxWidth * 0.25,
                                color: Colors.white),
                          ],
                        ),
                        Container(height: 14.h, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ).addShimmer(),
            );
          });
        },
      ),
    );
  }
}
