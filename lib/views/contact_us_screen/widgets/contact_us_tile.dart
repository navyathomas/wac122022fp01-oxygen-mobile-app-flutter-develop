import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class ContactUsTileWidget extends StatelessWidget {
  const ContactUsTileWidget(
      {super.key,
      this.text,
      required this.heading,
      this.onTap,
      this.hasPhoneNumber = false,
      this.phoneNumber,
      this.textWidget});

  final String heading;
  final String? text;
  final Widget? textWidget;
  final Function()? onTap;
  final bool? hasPhoneNumber;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: context.sw(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            18.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Text(
                heading,
                style: FontPalette.black16Medium,
              ),
            ),
            5.73.verticalSpace,
            hasPhoneNumber!
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: Constants.call,
                            style: FontPalette.f282C3F_14Regular
                                .copyWith(height: 1.5),
                          ),
                          TextSpan(
                              text: phoneNumber,
                              style: FontPalette.f282C3F_14Medium)
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: textWidget ??
                  (text != null
                      ? Text(
                          text ?? '',
                          style: FontPalette.f282C3F_14Regular
                              .copyWith(height: 1.5),
                        )
                      : const SizedBox.shrink()),
            ),
            18.27.verticalSpace,
            Divider(
              height: 5.h,
              thickness: 5.h,
              color: HexColor('#F3F3F7'),
            )
          ],
        ),
      ),
    );
  }
}
