import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';

class HorizontalProductListShimmer extends StatelessWidget {
  const HorizontalProductListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: context.sw(size: 0.4453),
            padding: EdgeInsets.only(
                top: 19.h, bottom: 30.h, left: 17.w, right: 17.w),
            decoration:
                BoxDecoration(border: Border.all(color: HexColor("#E6E6E6"))),
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.white),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 19.h, color: Colors.white),
                    Container(height: 19.h, color: Colors.white),
                    Container(
                        margin: EdgeInsets.only(right: 19.w),
                        height: 19.h,
                        color: Colors.white),
                    Container(
                        margin: EdgeInsets.only(right: 73.w),
                        height: 19.h,
                        color: Colors.white)
                  ],
                )),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => 6.horizontalSpace,
      ),
    );
  }
}
