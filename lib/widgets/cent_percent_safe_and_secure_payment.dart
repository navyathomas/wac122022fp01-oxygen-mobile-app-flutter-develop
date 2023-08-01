import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class CentPercentSafeAndSecurePayment extends StatelessWidget {
  const CentPercentSafeAndSecurePayment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#F4F4F4"),
      padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 14.h),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 22.r,
            child: SvgPicture.asset(Assets.iconsSecurePayment),
          ),
          13.horizontalSpace,
          Expanded(
            child: Text(
              Constants.safeAndSecurePayments,
              style: FontPalette.black12Regular,
            ),
          ),
        ],
      ),
    );
  }
}
