import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentlyViewedWidget extends StatelessWidget {
  const RecentlyViewedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 1.r,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 83.w,
          height: 120.h,
          decoration: const BoxDecoration(color: Colors.white),
        );
      },
    );
  }
}
