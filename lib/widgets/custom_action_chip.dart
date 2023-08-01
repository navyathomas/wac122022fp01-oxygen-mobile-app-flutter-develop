import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class CustomActionChip extends StatelessWidget {
  final String? text;
  final void Function()? onTap;
  final bool isSelected;

  const CustomActionChip({
    Key? key,
    this.text,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
            color: isSelected
                ? HexColor("#E50019").withOpacity(.10)
                : Colors.transparent,
            border: Border.all(
                color: isSelected ? HexColor("#E50019") : Colors.black),
            borderRadius: BorderRadius.circular(15.r)),
        child: Center(
            child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          style: isSelected
              ? FontPalette.fE50019_13Medium
              : FontPalette.black13Medium,
          child: Text(text?.toUpperCase() ?? ""),
        )),
      ),
    );
  }
}
