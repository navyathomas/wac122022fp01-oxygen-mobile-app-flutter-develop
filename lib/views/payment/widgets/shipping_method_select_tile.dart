import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/providers/select_address_provider.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio_button.dart';

class ShippingMethodSelectTile extends StatelessWidget {
  const ShippingMethodSelectTile(
      {Key? key,
      required this.selectAddressProvider,
      this.title,
      this.index,
      this.onTap,
      this.isSelected})
      : super(key: key);
  final String? title;
  final int? index;
  final SelectAddressProvider selectAddressProvider;
  final Function()? onTap;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CustomRadioButton(
              isSelected: isSelected ?? false,
            ),
            8.horizontalSpace,
            Expanded(
                child: Text(
              title ?? '',
              style: FontPalette.black16Regular,
            ))
          ],
        ),
      ),
      20.verticalSpace,
      index != selectAddressProvider.availableShippingMethods.length - 1
          ? Divider(
              color: HexColor('#E6E6E6'),
              thickness: 1.5.h,
              height: 1.5.h,
            )
          : const SizedBox.shrink(),
      index != selectAddressProvider.availableShippingMethods.length - 1
          ? 20.verticalSpace
          : 0.verticalSpace
    ]);
  }
}
