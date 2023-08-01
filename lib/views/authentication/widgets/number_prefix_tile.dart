import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';

import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class NumberPrefixTile extends StatelessWidget {
  const NumberPrefixTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.iconsFlag,
            height: 15.w,
            width: 23.w,
          ),
          4.horizontalSpace,
          Text(
            Constants.countryDialCode,
            style: FontPalette.f282C3F_14Regular,
          ),
          /*Icon(
            Icons.arrow_drop_down,
            size: 18.r,
          ),*/
          Container(
            width: 1.0.w,
            height: 18.h,
            color: HexColor('#DBDBDB'),
            margin: EdgeInsets.only(right: 10.w, left: 4.w),
          )
        ],
      ),
    );
  }
}
