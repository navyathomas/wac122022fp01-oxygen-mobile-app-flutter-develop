import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class CancelOrderTopWidget extends StatelessWidget {
  const CancelOrderTopWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: constraints.maxWidth * .2627,
              height: constraints.maxWidth * .18,
              child: const CommonFadeInImage(
                image:
                    "https://www.myg.in/images/thumbnails/416/307/detailed/11/oneplus-43fa0a00-1.jpeg",
              ),
            ),
            16.5.horizontalSpace,
            Expanded(
              child: Text(
                "OnePlus Y Series TV, 80 cm-32 inch, Android TV",
                style: FontPalette.black14Regular,
              ),
            ),
          ],
        ),
      );
    });
  }
}
