import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';

class LatestOffersTitleTile extends StatelessWidget {
  final String? title;

  const LatestOffersTitleTile({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? '',
              style: FontPalette.black18Medium,
            ).avoidOverFlow(),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    Constants.viewAll,
                    style: FontPalette.black16Regular,
                  ),
                  3.horizontalSpace,
                  SvgPicture.asset(
                    Assets.iconsRightArrow,
                    height: 12.h,
                    width: 6.w,
                  )
                ],
              ),
            ),
          ).removeSplash()
        ],
      ),
    );
  }
}
