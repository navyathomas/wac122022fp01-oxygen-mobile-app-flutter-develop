import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';

class CancelOrderReasonWidget extends StatelessWidget {
  const CancelOrderReasonWidget({
    Key? key,
  }) : super(key: key);

  static final List<String> reason = [
    "Order created by mistake",
    "Item(s) would not arrive on time",
    "Shipping cost too high",
    "Item price too high",
    "Found cheaper somewhere else",
    "Need to change payment method",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Text(
              Constants.reasonForCancellation,
              style: FontPalette.black18Medium,
            ),
            18.verticalSpace,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reason.length,
              itemBuilder: (context, index) => _BuildRow(
                isSelected: index == 0 ? true : false,
                reason: reason.elementAt(index),
              ),
              separatorBuilder: (context, index) => Divider(
                height: 32.h,
                thickness: 1.h,
                color: HexColor("#F3F3F7"),
              ),
            ),
            50.verticalSpace,
            CustomButton(onPressed: () {}, title: Constants.cancelOrder),
            30.5.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final bool? isSelected;
  final String? reason;

  const _BuildRow({
    Key? key,
    this.isSelected,
    this.reason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomRadioButton(isSelected: isSelected ?? false),
        12.horizontalSpace,
        Expanded(
          child: Text(
            reason ?? "",
            style: FontPalette.black14Regular,
          ),
        ),
      ],
    );
  }
}
