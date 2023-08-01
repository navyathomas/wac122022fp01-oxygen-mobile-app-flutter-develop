import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/three_bounce.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      this.width,
      this.height,
      this.title,
      this.message,
      this.actionButtonText,
      this.cancelButtonText,
      this.insetPadding,
      this.disableCancelBtn = false,
      this.enableCloseBtn = true,
      this.onActionButtonPressed,
      this.onCancelButtonPressed,
      this.cancelIsLoading = false,
      this.isLoading});

  final double? width;
  final double? height;
  final EdgeInsets? insetPadding;
  final String? title;
  final String? message;
  final String? actionButtonText;
  final String? cancelButtonText;
  final bool disableCancelBtn;
  final bool enableCloseBtn;
  final Function()? onActionButtonPressed;
  final VoidCallback? onCancelButtonPressed;
  final bool? isLoading;
  final bool cancelIsLoading;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40.w),
      titlePadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      content: SizedBox(
        width: width ?? context.sw(),
        height: height ?? 275.h,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.57.verticalSpace,
                Text(
                  title ?? '',
                  style: FontPalette.black18Medium,
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 19.w),
                  child: Text(
                    message ?? '',
                    textAlign: TextAlign.center,
                    style: FontPalette.f282C3F_14Regular,
                  ),
                ),
                30.43.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 29.w),
                  child: CustomButton(
                    isLoading: isLoading ?? false,
                    onPressed: onActionButtonPressed,
                    title: actionButtonText,
                  ),
                ),
                if (!disableCancelBtn) ...[
                  10.verticalSpace,
                  Container(
                    height: 45.h,
                    margin: EdgeInsets.symmetric(horizontal: 29.w),
                    width: width ?? double.maxFinite,
                    child: TextButton(
                      onPressed: onCancelButtonPressed,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: cancelIsLoading
                            ? ThreeBounce(
                                size: 25.r,
                                color: HexColor('E50019'),
                              )
                            : Text(
                                cancelButtonText ?? '',
                                style: FontPalette.fE50019_14Bold,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  )
                ]
              ],
            ),
            if (enableCloseBtn)
              Positioned(
                right: 3.w,
                top: 3.h,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      height: 24.4,
                      width: 24.4,
                      padding: const EdgeInsets.all(6.0),
                      child: SvgPicture.asset(
                        Assets.iconsCloseGrey,
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
