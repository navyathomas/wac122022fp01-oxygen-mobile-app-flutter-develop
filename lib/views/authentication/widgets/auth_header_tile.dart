import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants.dart';
import '../../../utils/font_palette.dart';

class AuthHeaderTile extends StatelessWidget {
  final VoidCallback? onSkip;
  final bool fromGuestUser;

  const AuthHeaderTile({Key? key, this.onSkip, this.fromGuestUser = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, left: 13.w),
            child: Text(
              Constants.authScreenTitle,
              style: FontPalette.black26Medium,
            ),
          ),
        ),
        fromGuestUser
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(Icons.close))
            : InkWell(
                onTap: onSkip,
                borderRadius: BorderRadius.circular(5.r),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Text(
                    Constants.skip,
                    style: FontPalette.fE50019_16Medium,
                  ),
                ),
              ),
        3.horizontalSpace
      ],
    );
  }
}
