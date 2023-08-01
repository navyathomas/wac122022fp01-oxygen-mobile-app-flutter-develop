import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../../utils/color_palette.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -0.1),
      child: ColoredBox(
        color: ColorPalette.primaryColor,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, RouteGenerator.routeSearchScreen),
          child: Container(
            height: double.maxFinite,
            margin:
                EdgeInsets.only(left: 12.w, right: 12.w, bottom: 7.h, top: 6.h),
            width: double.maxFinite,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.iconsSearch,
                  height: 16.h,
                  width: 15.34.w,
                ),
                11.horizontalSpace,
                Text(
                  Constants.whatAreYouLookingFor,
                  style:
                      FontPalette.f7D808B_14Regular.copyWith(wordSpacing: 0.7),
                ).translateWidgetVertically(value: 1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
