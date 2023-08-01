import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';

class CustomSwitch extends StatelessWidget {
  final void Function()? onTap;
  final bool isSelected;

  const CustomSwitch({
    Key? key,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 24.51.h,
        width: 42.33.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: 24.51.h,
                width: 42.33.w,
                decoration: BoxDecoration(
                    color: isSelected ? HexColor("#179614") : Colors.grey,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              alignment:
                  isSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                height: 24.51.h - 3,
                width: 24.51.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
