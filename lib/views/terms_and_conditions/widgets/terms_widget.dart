import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.73),
      child: SizedBox(
        width: context.sw(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 11.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 13.h),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HexColor('#7B7E8E'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Text(
              text,
              style: FontPalette.f282C3F_14Regular.copyWith(height: 1.8),
            ))
          ],
        ),
      ),
    );
  }
}
