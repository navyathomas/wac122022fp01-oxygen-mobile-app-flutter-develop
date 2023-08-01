import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonLinearProgress extends StatelessWidget {
  const CommonLinearProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 2.h, child: const LinearProgressIndicator());
  }
}
