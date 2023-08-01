import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class OrderCompleteSuccessWidget extends StatefulWidget {
  const OrderCompleteSuccessWidget({Key? key, this.orderNumber})
      : super(key: key);
  final String? orderNumber;

  @override
  State<OrderCompleteSuccessWidget> createState() =>
      _OrderCompleteSuccessWidgetState();
}

class _OrderCompleteSuccessWidgetState
    extends State<OrderCompleteSuccessWidget> {
  late ValueNotifier<double> _scaleValue;

  @override
  void initState() {
    _scaleValue = ValueNotifier(0.4);
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _scaleValue.value = 1.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 29.5.w),
      color: HexColor('#FFFFFF'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          18.verticalSpace,
          ValueListenableBuilder<double>(
              valueListenable: _scaleValue,
              builder: (context, value, child) {
                child = SvgPicture.asset(
                  Assets.iconsSuccess,
                  height: 58.h,
                  width: 58.w,
                );
                return AnimatedScale(
                  scale: value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: child,
                );
              }),
          16.5.verticalSpace,
          Text(
            Constants.youAreAllSet,
            style: FontPalette.black18Medium.copyWith(fontSize: 20.sp),
          ),
          9.verticalSpace,
          Text(
            Constants.thanksForSubmittingOrder,
            textAlign: TextAlign.center,
            style: FontPalette.black14Regular,
          ),
          16.verticalSpace,
          Text(
            'Order No: ${widget.orderNumber ?? ''} ',
            style: FontPalette.black14Medium.copyWith(fontSize: 15.sp),
          ),
          16.verticalSpace
        ],
      ),
    );
  }
}
