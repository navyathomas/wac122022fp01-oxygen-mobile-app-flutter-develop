import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';

class CartShimmer extends StatelessWidget {
  const CartShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                ...List.generate(
                  3,
                  (index) => Container(
                    padding: EdgeInsets.symmetric(vertical: 22.w),
                    decoration: BoxDecoration(
                      border: index == 2
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: HexColor("#F3F3F7"),
                              ),
                            ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: constraints.maxWidth * .2627,
                          width: constraints.maxWidth * .2627,
                          color: Colors.white,
                        ),
                        3.5.horizontalSpace,
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(height: 14.h, color: Colors.white),
                                5.verticalSpace,
                                Container(height: 14.h, color: Colors.white),
                                5.verticalSpace,
                                Container(height: 14.h, color: Colors.white),
                                15.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 27.5.r,
                                              width: 27.5.r,
                                              color: Colors.white),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              height: 27.5.r,
                                              width: 27.5.r,
                                              color: Colors.white),
                                          Container(
                                              height: 27.5.r,
                                              width: 27.5.r,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: 27.5.r,
                                        width: 50.r,
                                        color: Colors.white),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).addShimmer(),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 5.h,
          thickness: 5.h,
          color: HexColor("#F3F3F7"),
        ),
      ],
    );
  }
}
