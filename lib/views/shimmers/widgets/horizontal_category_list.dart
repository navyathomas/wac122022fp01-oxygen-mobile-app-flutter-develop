import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class HorizontalCategoryList extends StatelessWidget {
  const HorizontalCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sw(size: .3467),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                height: context.sw(size: .2027),
                width: context.sw(size: .2027),
              ),
              6.verticalSpace,
            ],
          );
        },
        separatorBuilder: (context, index) => 11.horizontalSpace,
      ),
    );
  }
}
