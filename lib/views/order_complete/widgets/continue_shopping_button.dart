import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants.dart';
import '../../../utils/color_palette.dart';
import '../../../widgets/custom_btn.dart';

class ContinueShoppingButton extends StatelessWidget {
  const ContinueShoppingButton({Key? key, this.buttonText, this.onTap})
      : super(key: key);
  final String? buttonText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (p0, p1) {
          return Container(
              height: 73.h,
              color: HexColor('#FFFFFF'),
              padding: EdgeInsets.symmetric(
                  horizontal: p1.maxWidth * .0347, vertical: 14.h),
              child: CustomButton(
                onPressed: onTap,
                title: buttonText ?? Constants.continueShopping,
              ));
        },
      ),
    );
  }
}
