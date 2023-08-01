import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../../models/cart_data_model.dart';

class CartRewardPoints extends StatelessWidget {
  const CartRewardPoints({
    Key? key,
    required this.cartDataModel,
  }) : super(key: key);

  final CartDataModel? cartDataModel;

  @override
  Widget build(BuildContext context) {
    return ((cartDataModel?.rewardPoints ?? 0) <= 0)
        ? const SizedBox.shrink()
        : Container(
            alignment: Alignment.center,
            color: HexColor("#F4F4F4"),
            padding: EdgeInsets.symmetric(vertical: 9.h),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Constants.youWillEarn,
                    style: FontPalette.black14Regular,
                  ),
                  WidgetSpan(child: 6.horizontalSpace),
                  WidgetSpan(
                    child: SizedBox.square(
                            dimension: 15.27.r,
                            child: SvgPicture.asset(Assets.iconsEarnPoints))
                        .translateWidgetVertically(value: -1.2),
                  ),
                  WidgetSpan(child: 6.horizontalSpace),
                  TextSpan(
                    text: '${cartDataModel?.rewardPoints ?? ""}',
                    style: FontPalette.black14Medium,
                  ),
                  WidgetSpan(child: 6.horizontalSpace),
                  TextSpan(
                    text: Constants.onThisOrder,
                    style: FontPalette.black14Regular,
                  ),
                ],
              ),
            ),
          );
  }
}
