import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendingSearchWidget extends StatelessWidget {
  const TrendingSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.r,
      runSpacing: 6.r,
      children: List.generate(
        7,
        (index) => Container(
          height: 20.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
