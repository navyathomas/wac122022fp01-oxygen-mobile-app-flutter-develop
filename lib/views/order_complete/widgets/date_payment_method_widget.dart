import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

import '../../../common/constants.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class DatePaymentMethodWidget extends StatelessWidget {
  const DatePaymentMethodWidget({Key? key, this.paymentMethod})
      : super(key: key);
  final String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 19.h),
      color: HexColor('#FFFFFF'),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       Constants.estimatedDate,
          //       style: FontPalette.black15Regular,
          //     ),
          //     Text(
          //       'Sep 4 - Sep 6',
          //       style: FontPalette.black15Medium,
          //     )
          //   ],
          // ),
          // 12.verticalSpace,
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Constants.paymentMethod,
                style: FontPalette.black15Regular,
              ),
              Text(
                paymentMethod ?? '',
                style: FontPalette.black15Medium,
              ).avoidOverFlow(maxLine: 1)
            ],
          ),
        ],
      ),
    );
  }
}
