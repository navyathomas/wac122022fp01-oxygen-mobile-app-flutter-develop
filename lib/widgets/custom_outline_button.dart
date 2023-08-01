import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/widgets/three_bounce.dart';

import '../utils/font_palette.dart';

class CustomOutlineButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final bool isLoading;
  final VoidCallback? onPressed;
  final TextStyle? fontStyle;
  final EdgeInsetsGeometry? padding;

  const CustomOutlineButton(
      {Key? key,
      this.height,
      this.width,
      this.title,
      this.isLoading = false,
      this.onPressed,
      this.fontStyle,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45.h,
      width: width ?? double.maxFinite,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 45.h,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
                border: Border.all(
                    color: onPressed == null
                        ? HexColor("#7B7E8E")
                        : Colors.black)),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? ThreeBounce(
                      size: 25.r,
                      color: Colors.black,
                    )
                  : Text(
                      (title ?? Constants.continueTxt).toUpperCase(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: fontStyle ?? FontPalette.black16Bold,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlineButtonFitted extends StatelessWidget {
  final double? height;
  final double? width;
  final String? title;
  final bool isLoading;
  final VoidCallback? onPressed;
  final TextStyle? fontStyle;
  final EdgeInsetsGeometry? padding;

  const CustomOutlineButtonFitted(
      {Key? key,
      this.height,
      this.width,
      this.title,
      this.isLoading = false,
      this.onPressed,
      this.fontStyle,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45.h,
      width: width ?? double.maxFinite,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 45.h,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
                border: Border.all(
                    color: onPressed == null
                        ? HexColor("#7B7E8E")
                        : Colors.black)),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? ThreeBounce(
                      size: 25.r,
                      color: Colors.black,
                    )
                  : FittedBox(
                      child: Text(
                        (title ?? Constants.continueTxt).toUpperCase(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: fontStyle ?? FontPalette.black16Bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
