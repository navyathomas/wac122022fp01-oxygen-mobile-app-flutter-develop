import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonStyles {
  static final bottomDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 1.r,
        spreadRadius: 1.r,
        offset: const Offset(0.0, -0.5),
      ),
    ],
  );
}
