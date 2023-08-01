import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';

class CustomRadioButton extends StatelessWidget {
  final double? outerSize;
  final double? innerSize;
  final void Function()? onTap;
  final bool isSelected;

  const CustomRadioButton({
    Key? key,
    this.outerSize,
    this.innerSize,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: outerSize ?? 18.r,
        width: outerSize ?? 18.r,
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? HexColor("#E50019") : HexColor("#282C3F"),
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: isSelected ? innerSize ?? 10.r : 0.0,
            width: isSelected ? innerSize ?? 10.r : 0.0,
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HexColor("#E50019"),
            ),
          ),
        ),
      ),
    );
  }
}
