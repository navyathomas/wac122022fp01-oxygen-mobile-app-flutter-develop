import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../common/constants.dart';

class EmiOptionsTermsAndConditionsWidget extends StatelessWidget {
  const EmiOptionsTermsAndConditionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Constants.termsAndConditions,
          style: FontPalette.black14Medium,
        ),
        19.verticalSpace,
        const _BuildRow(
            text:
                "The EMI is calculated on the total value of your order at the time of payment"),
        10.verticalSpace,
        const _BuildRow(text: "The minimum order value to avail EMI is ₹2,500"),
        10.verticalSpace,
        const _BuildRow(
            text: "Select your preferred EMI option at the time of payment"),
        10.verticalSpace,
        Text(
          Constants.readMore,
          style: FontPalette.fE50019_14Medium,
        )
      ],
    );
  }
}

class _BuildRow extends StatelessWidget {
  final String? text;

  const _BuildRow({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4.r,
          width: 4.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HexColor("#7B7E8E"),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            text ?? "",
            style: FontPalette.f282C3F_12Regular,
          ).translateWidgetVertically(value: -7),
        ),
      ],
    );
  }
}
