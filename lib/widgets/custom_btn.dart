import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/color_palette.dart';

import '../utils/font_palette.dart';
import 'three_bounce.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? shadowColor;
  final bool? enabled;
  final TextStyle? fontStyle;
  final EdgeInsetsGeometry? padding;

  const CustomButton(
      {Key? key,
      this.height,
      this.width,
      this.title,
      this.isLoading = false,
      this.onPressed,
      this.shadowColor,
      this.enabled = true,
      this.fontStyle,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45.h,
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        onPressed: isLoading || !enabled! ? null : onPressed,
        style: ButtonStyle(
            enableFeedback: enabled,
            backgroundColor: !enabled!
                ? MaterialStateProperty.all(HexColor('#CACBD0'))
                : null),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? ThreeBounce(
                  size: 25.r,
                )
              : Text(
                  (title ?? Constants.continueTxt).toUpperCase(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: fontStyle ?? FontPalette.white16Bold,
                ),
        ),
      ),
    );
  }
}
