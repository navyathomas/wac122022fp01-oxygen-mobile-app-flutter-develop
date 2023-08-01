import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../models/loyalty_point_model.dart';

class LoyaltyBillTile extends StatelessWidget {
  final WacLoyaltyPoint? wacLoyaltyPoint;
  const LoyaltyBillTile({Key? key, required this.wacLoyaltyPoint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.5.w),
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: HexColor('#E6E6E6')))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                wacLoyaltyPoint?.label ?? '',
                style: FontPalette.black14Regular,
              )),
              Text(
                (wacLoyaltyPoint?.credited ?? true)
                    ? '+ ${wacLoyaltyPoint?.points ?? '0'}'
                    : '- ${wacLoyaltyPoint?.points ?? '0'}',
                style: FontPalette.black14Medium.copyWith(
                    color: (wacLoyaltyPoint?.credited ?? true)
                        ? HexColor('#46942F')
                        : HexColor('#E50019')),
              )
            ],
          ),
          4.verticalSpace,
          Text(
            wacLoyaltyPoint?.createdAt ?? '',
            style:
                FontPalette.black12Regular.copyWith(color: HexColor('#787B88')),
          )
        ],
      ),
    );
  }
}
