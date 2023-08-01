import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/extensions.dart';

import '../../../models/cart_data_model.dart';
import '../../../providers/payment_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_btn.dart';

class PaymentBottomWidget extends StatelessWidget {
  const PaymentBottomWidget(
      {Key? key,
      required this.paymentProvider,
      required this.isLoading,
      this.onTap,
      this.enableBtn = true,
      this.cartDataModel})
      : super(key: key);
  final PaymentProvider paymentProvider;
  final Function()? onTap;
  final bool isLoading;
  final bool enableBtn;
  final CartDataModel? cartDataModel;

  @override
  Widget build(BuildContext context) {
    CartPrices? cartPrices = cartDataModel?.cartPrices;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 73.h,
        decoration: CommonStyles.bottomDecoration,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        child: Row(
          children: [
            SizedBox(
              height: 45.h,
              width: context.sw(size: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cartPrices?.grandTotal?.value.toRupee}',
                    style: FontPalette.black16Medium,
                  ),
                  2.verticalSpace,
                  cartDataModel != null && cartDataModel!.cartItems.notEmpty
                      ? Text(
                          cartDataModel!.cartItems!.length > 1
                              ? 'Total ${cartDataModel!.cartItems!.length} items'
                              : 'Total ${cartDataModel!.cartItems!.length} item',
                          style: FontPalette.black14Regular
                              .copyWith(color: HexColor('#7B7E8E')),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
            Expanded(
              child: CustomButton(
                height: 45.h,
                onPressed: onTap,
                enabled: enableBtn,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
