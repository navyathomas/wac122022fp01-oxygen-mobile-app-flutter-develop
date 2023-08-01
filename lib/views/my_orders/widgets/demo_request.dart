import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/constants.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class DemoRequestBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  const DemoRequestBtn({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey,
            side: BorderSide(
              color: HexColor('#282C3F'),
            ),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: Text(
          Constants.demoRequest,
          style: FontPalette.black13Medium,
        ),
      ),
    );
  }
}
