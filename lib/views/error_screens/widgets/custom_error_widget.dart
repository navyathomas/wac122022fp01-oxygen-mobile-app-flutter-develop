import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';

class ErrorScreenWidget extends StatefulWidget {
  const ErrorScreenWidget(
      {super.key, required this.type, this.onButtonPressed});

  final CustomErrorType type;
  final Function()? onButtonPressed;

  @override
  State<ErrorScreenWidget> createState() => _ErrorScreenWidgetState();
}

class _ErrorScreenWidgetState extends State<ErrorScreenWidget> {
  late String iconData;
  late String title;
  late Widget subTitle;

  @override
  Widget build(BuildContext context) {
    return widget.type != CustomErrorType.paymentFailed
        ? Column(
            children: [
              197.verticalSpace,
              SvgPicture.asset(iconData),
              40.89.verticalSpace,
              Text(
                title,
                textAlign: TextAlign.center,
                style: FontPalette.black18Medium,
              ),
              6.verticalSpace,
              subTitle,
              if (widget.onButtonPressed != null) ...[
                30.75.verticalSpace,
                CustomButton(
                  width: 188.w,
                  height: 45.h,
                  title: Constants.continueShopping,
                  onPressed: widget.onButtonPressed,
                )
              ]
            ],
          )
        : Column(
            children: [
              244.verticalSpace,
              SizedBox(
                width: 58,
                height: 58,
                child: SvgPicture.asset(iconData),
              ),
              15.5.verticalSpace,
              Text(
                title,
                textAlign: TextAlign.center,
                style: FontPalette.black20Medium,
              ),
              8.36.verticalSpace,
              subTitle,
              const Expanded(
                child: SizedBox.shrink(),
              ),
              if (widget.onButtonPressed != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: CustomButton(
                    height: 45.h,
                    title: Constants.tryAgain,
                    onPressed: widget.onButtonPressed,
                  ),
                ),
              30.5.verticalSpace
            ],
          );
  }

  @override
  void initState() {
    _setScreenValues();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ErrorScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.type != oldWidget.type) {
      _setScreenValues();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setScreenValues() {
    switch (widget.type) {
      case CustomErrorType.myItemsEmpty:
        iconData = Assets.iconsErrorMyItems;
        title = Constants.youHaventAddedProducts;
        subTitle = SizedBox(
          height: 19.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Constants.click,
                textAlign: TextAlign.center,
                style: FontPalette.f282C3F_14Regular,
              ),
              SvgPicture.asset(
                Assets.iconsHeartOutline,
                height: 16.84.h,
                width: 14.68.w,
              ),
              Text(
                Constants.toAddProductToThisList,
                style: FontPalette.f282C3F_14Regular,
              )
            ],
          ),
        );
        break;
      case CustomErrorType.myCartEmpty:
        iconData = Assets.iconsErrorMyCart;
        title = Constants.yourCartIsEmpty;
        subTitle = Text(
          Constants.cartEmptyMessage,
          textAlign: TextAlign.center,
          style: FontPalette.f282C3F_14Regular,
        );
        break;
      case CustomErrorType.paymentFailed:
        iconData = Assets.iconsErrorPaymentFailed;
        title = Constants.paymentFailed;
        subTitle = Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Text(
            Constants.paymentFailedText,
            textAlign: TextAlign.center,
            style: FontPalette.f282C3F_14Regular,
          ),
        );
        break;
      case CustomErrorType.noOrders:
        iconData = Assets.iconsErrorMyOrders;
        title = Constants.youDontHaveOrders;
        subTitle = Text(
          Constants.theOrdersAppearHere,
          textAlign: TextAlign.center,
          style: FontPalette.f282C3F_14Regular,
        );
        break;
      case CustomErrorType.searchNoData:
        iconData = Assets.iconsSearchNoData;
        title = Constants.weCouldNtFindAnyMatches;
        subTitle = Text(
          Constants.pleaseCheckSpelling,
          textAlign: TextAlign.center,
          style: FontPalette.f282C3F_14Regular,
        );
        break;
    }
  }
}
