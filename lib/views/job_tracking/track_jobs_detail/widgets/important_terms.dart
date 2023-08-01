import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/font_palette.dart';

class ImportantTerms extends StatelessWidget {
  const ImportantTerms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Constants.importantTerms, style: FontPalette.black16Regular),
        11.verticalSpace,
        Text(Constants.importantTermsNoteOne,
            style: FontPalette.f6C6C6C_14Regular),
        20.verticalSpace,
        Text(Constants.importantTermsNoteTwo,
            style: FontPalette.f6C6C6C_14Regular),
      ],
    );
  }
}
