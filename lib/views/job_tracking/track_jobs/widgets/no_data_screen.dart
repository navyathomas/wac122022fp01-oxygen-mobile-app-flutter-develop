import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';

class NoDataScreen extends StatelessWidget {
  final String? titleText;
  final String? subText;
  final Function()? onTryAgain;
  const NoDataScreen({Key? key, this.onTryAgain, this.titleText, this.subText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: context.sw(),
      margin: EdgeInsets.only(top: 10.h),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            125.verticalSpace,
            SvgPicture.asset(Assets.iconsServiceTrackingNoData),
            49.33.verticalSpace,
            Text(
              titleText ?? "",
              style: FontPalette.black18Medium,
            ),
            6.verticalSpace,
            Text(
              subText ?? "",
              style: FontPalette.f282C3F_14Regular,
            ),
            30.33.verticalSpace,
            CustomButton(
              title: Constants.tryAgain,
              width: 132.w,
              onPressed: onTryAgain,
            )
          ],
        ),
      ),
    );
  }
}
