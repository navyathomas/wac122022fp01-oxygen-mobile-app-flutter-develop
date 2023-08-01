import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';

class CustomCheckBox extends StatelessWidget {
  final double? size;
  final void Function()? onTap;
  final bool isSelected;

  const CustomCheckBox({
    Key? key,
    this.size,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: size ?? 18.r,
        width: size ?? 18.r,
        curve: Curves.linear,
        decoration: BoxDecoration(
            border: isSelected
                ? null
                : Border.all(
                    color: HexColor("#7B7E8E"),
                  ),
            color: isSelected ? HexColor("#E50019") : null),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: isSelected ? size ?? 18.r : 0.0,
            width: isSelected ? size ?? 18.r : 0.0,
            curve: Curves.slowMiddle,
            color: HexColor("#E50019"),
            child: Padding(
              padding: EdgeInsets.all(2.r),
              child: SvgPicture.asset(
                Assets.iconsTick,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
