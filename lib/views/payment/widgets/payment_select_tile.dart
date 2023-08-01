import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

import '../../../common/constants.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio_button.dart';

class PaymentSelectTile extends StatelessWidget {
  const PaymentSelectTile(
      {Key? key,
      this.paymentTitle,
      this.paymentIcon,
      this.index,
      this.isSelected,
      this.onTap})
      : super(key: key);
  final String? paymentTitle;
  final String? paymentIcon;
  final int? index;
  final bool? isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomRadioButton(
            isSelected: isSelected ?? false,
          ),
          16.horizontalSpace,
          CommonFadeInImage(
            image: paymentIcon ?? '',
            height: 30.h,
            width: 30.w,
          ),
          5.horizontalSpace,
          Expanded(
              child: Text(
            paymentTitle ?? Constants.creditOrDebitOrATMCard,
            style: FontPalette.black16Regular,
          ))
        ],
      ),
    );
  }
}
