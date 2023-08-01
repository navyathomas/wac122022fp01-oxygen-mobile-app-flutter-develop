import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, this.height, this.color, this.thickness})
      : super(key: key);
  final double? height;
  final double? thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1.h,
      thickness: thickness ?? 1.h,
      color: color ?? HexColor('#F3F3F7'),
    );
  }
}
