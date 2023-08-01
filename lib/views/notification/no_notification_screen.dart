import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';

class NoNotificationScreen extends StatelessWidget {
  const NoNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSlidingFadeAnimation(
      slideDuration: const Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: context.sw()),
          225.verticalSpace,
          SvgPicture.asset(Assets.iconsNoNotifications),
          40.21.verticalSpace,
          Text(
            Constants.noNotificationsTitle,
            style: FontPalette.black18Medium,
          ),
          6.verticalSpace,
          Text(
            Constants.noNotificationsSub,
            style: FontPalette.f282C3F_14Regular,
          )
        ],
      ),
    );
  }
}
