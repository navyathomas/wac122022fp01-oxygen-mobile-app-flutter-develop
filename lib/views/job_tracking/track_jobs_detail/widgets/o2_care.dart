import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class O2Care extends StatelessWidget {
  const O2Care({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.sw(size: .1387),
              height: context.sw(size: .1733),
              child: Image.asset(Assets.imagesO2Care),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                Constants.experienceTheCompleteCare,
                style: FontPalette.white16Regular,
              ),
            ),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
