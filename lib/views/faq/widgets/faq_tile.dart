import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class FaqTileWidget extends StatelessWidget {
  const FaqTileWidget({super.key, this.title, required this.index});

  final String? title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 57.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: HexColor('#E6E6E6'),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0.h : 10.h, bottom: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title ?? '',
                  style: FontPalette.black16Regular.copyWith(height: 1.5),
                ),
              ),
              SizedBox(
                width: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: HexColor('#7B7E8E'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
