import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../generated/assets.dart';

class RecentlySearchedListTile extends StatelessWidget {
  String? name;

  RecentlySearchedListTile({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name ?? '',
              style: FontPalette.black14Regular,
            ).avoidOverFlow(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 55.w),
            child: SvgPicture.asset(
              Assets.iconsArrowUp,
              height: 12.h,
              width: 12.w,
            ),
          ),
        ],
      ),
    );
  }
}
