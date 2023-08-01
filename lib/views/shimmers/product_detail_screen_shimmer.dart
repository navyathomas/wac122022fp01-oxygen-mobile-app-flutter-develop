import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class ProductDetailScreenShimmer extends StatelessWidget {
  const ProductDetailScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                height: context.sw(size: 0.7947),
                color: Colors.white,
              ),
              40.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 14.h,
                        width: context.sw(size: 0.3813),
                        color: Colors.white),
                    16.verticalSpace,
                    Container(
                        height: 14.h,
                        width: context.sw(size: 0.7467),
                        color: Colors.white),
                    18.verticalSpace,
                    Container(
                        height: 14.h,
                        width: context.sw(size: 0.7467),
                        color: Colors.white),
                    38.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 14.h,
                            width: context.sw(size: 0.3813),
                            color: Colors.white),
                        Container(
                            height: 14.h,
                            width: context.sw(size: 0.1387),
                            color: Colors.white),
                      ],
                    ),
                    16.verticalSpace,
                    Container(
                        height: 14.h,
                        width: double.maxFinite,
                        color: Colors.white),
                    16.verticalSpace,
                    Container(
                        height: 14.h,
                        width: double.maxFinite,
                        color: Colors.white),
                    33.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => Container(
                          height: context.sw(size: 0.12),
                          width: context.sw(size: 0.12),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    23.verticalSpace,
                    Container(
                        height: 14.h,
                        width: context.sw(size: .3813),
                        color: Colors.white),
                    23.verticalSpace,
                    Container(
                        height: 14.h,
                        width: double.maxFinite,
                        color: Colors.white),
                    100.verticalSpace,
                  ],
                ),
              )
            ],
          ),
        ],
      ).addShimmer(),
    );
  }
}

class ProductDetailScreenPartialShimmer extends StatelessWidget {
  const ProductDetailScreenPartialShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            38.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 14.h,
                    width: context.sw(size: 0.3813),
                    color: Colors.white),
                Container(
                    height: 14.h,
                    width: context.sw(size: 0.1387),
                    color: Colors.white),
              ],
            ),
            16.verticalSpace,
            Container(
                height: 14.h, width: double.maxFinite, color: Colors.white),
            16.verticalSpace,
            Container(
                height: 14.h, width: double.maxFinite, color: Colors.white),
            33.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => Container(
                  height: context.sw(size: 0.12),
                  width: context.sw(size: 0.12),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
            23.verticalSpace,
            Container(
                height: 14.h,
                width: context.sw(size: .3813),
                color: Colors.white),
            23.verticalSpace,
            Container(
                height: 14.h, width: double.maxFinite, color: Colors.white),
            100.verticalSpace,
          ],
        ),
      ).addShimmer(),
    );
  }
}
