import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';

class HomeTitleTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const HomeTitleTile({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h, left: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? '',
              style: FontPalette.black18Medium,
            ).avoidOverFlow(),
          ),
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    onTap != null ? Constants.viewAll : '',
                    style: FontPalette.black16Regular,
                  ),
                  5.horizontalSpace,
                  onTap != null
                      ? SvgPicture.asset(
                          Assets.iconsRightArrow,
                          height: 12.h,
                          width: 6.w,
                        )
                      : 12.verticalSpace
                ],
              ),
            ),
          ).removeSplash()
        ],
      ),
    );
  }
}
