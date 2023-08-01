import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_btn.dart';

class LoyaltyErrorView extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onTap;
  const LoyaltyErrorView(
      {Key? key, required this.title, required this.subTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 231.w,
            height: 134.h,
            child: SvgPicture.asset(Assets.iconsNoLoyaltyPoints),
          ),
        ),
        36.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: FontPalette.black20Medium,
        ),
        8.verticalSpace,
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: FontPalette.f282C3F_14Regular,
        ),
        39.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.sw(size: 0.2)),
          child: CustomButton(
            height: 45.h,
            title: Constants.continueShopping,
            onPressed: () {
              onTap?.call();
            },
          ),
        ),
        30.5.verticalSpace
      ],
    );
  }
}
