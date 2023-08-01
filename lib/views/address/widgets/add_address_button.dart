import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';

class AddAddressButton extends StatelessWidget {
  final void Function()? onTap;

  const AddAddressButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 12.35.r,
                  child: SvgPicture.asset(
                    Assets.iconsIncrement,
                    color: Colors.black,
                  ),
                ),
                8.horizontalSpace,
                Flexible(
                  child: Text(
                    Constants.addNewAddress.toUpperCase(),
                    maxLines: 1,
                    style: FontPalette.black15Bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
