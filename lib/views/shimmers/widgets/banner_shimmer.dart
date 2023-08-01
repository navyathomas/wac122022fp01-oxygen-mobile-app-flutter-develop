import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          height: context.sw(size: 0.56),
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircleDots(),
              10.horizontalSpace,
              _buildCircleDots(),
              10.horizontalSpace,
              _buildCircleDots(),
              10.horizontalSpace,
              _buildCircleDots(),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildCircleDots() {
    return Container(
      height: 7.r,
      width: 7.r,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade400),
    );
  }
}
