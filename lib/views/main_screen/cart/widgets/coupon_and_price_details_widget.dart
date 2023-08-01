import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/main_screen/cart/widgets/cart_reward_points.dart';
import 'package:oxygen/widgets/cent_percent_safe_and_secure_payment.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';
import 'package:oxygen/widgets/custom_text_form_field.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../models/cart_data_model.dart';

class CouponAndPriceDetailsWidget extends StatelessWidget {
  final CartDataModel? cartDataModel;
  final ValueNotifier<String> couponValue;
  final TextEditingController couponController;
  final Function(bool) onCouponTap;

  const CouponAndPriceDetailsWidget(
      {Key? key,
      this.cartDataModel,
      required this.couponValue,
      required this.couponController,
      required this.onCouponTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartPrices? cartPrices = cartDataModel?.cartPrices;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Constants.applyCoupon,
            style: FontPalette.black16Medium,
          ),
          10.verticalSpace,
          Selector<CartProvider, Tuple2<bool, bool>>(
            selector: (context, provider) =>
                Tuple2(provider.isCouponApplied, provider.couponLoader),
            builder: (context, value, child) {
              return CustomTextFormField(
                controller: couponController,
                enabled: !value.item1,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor("#DBDBDB"),
                    width: 1.r,
                  ),
                ),
                style: value.item1
                    ? FontPalette.f7B7E8E_15Medium
                    : FontPalette.black15Regular,
                hintText: Constants.enterPromoCode,
                hintStyle: FontPalette.f7B7E8E_16Regular,
                onChanged: (val) => couponValue.value = val,
                suffixWidget: value.item2
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: ThreeBounce(
                          size: 25.0,
                          color: ColorPalette.primaryColor,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ValueListenableBuilder<String>(
                            valueListenable: couponValue,
                            builder: (context, coupon, _) {
                              return TextButton(
                                onPressed: coupon.isEmpty
                                    ? null
                                    : () => onCouponTap(value.item1),
                                child: value.item1
                                    ? Text(
                                        Constants.remove.toUpperCase(),
                                        style: FontPalette.black14Bold,
                                      )
                                    : Text(
                                        Constants.apply.toUpperCase(),
                                        style: coupon.isNotEmpty
                                            ? FontPalette.fE50019_15Bold
                                            : FontPalette.f7B7E8E_15Bold,
                                      ),
                              );
                            }),
                      ),
              );
            },
          ),
          18.verticalSpace,
          Text(
            Constants.priceDetails,
            style: FontPalette.black16Medium,
          ),
          14.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Constants.totalPrice,
                  style: FontPalette.black16Regular,
                ).avoidOverFlow(),
              ),
              Expanded(
                child: Text(
                  (cartPrices?.subtotalExcludingTax?.value ?? 0.0).toRupee,
                  textAlign: TextAlign.end,
                  style: FontPalette.black16Regular,
                ).avoidOverFlow(),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Constants.delivery,
                  style: FontPalette.black16Regular,
                ).avoidOverFlow(),
              ),
              Expanded(
                child: Text(
                  (cartDataModel?.shippingAmount ?? 0.0) > 0.0
                      ? (cartDataModel?.shippingAmount ?? 0.0).toRupee
                      : Constants.free,
                  textAlign: TextAlign.end,
                  style: FontPalette.f039614_16Regular,
                ).avoidOverFlow(),
              ),
            ],
          ),
          12.verticalSpace,
          if (cartDataModel?.cartPrices?.discountAmount != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    Constants.discount,
                    style: FontPalette.black16Regular,
                  ).avoidOverFlow(),
                ),
                Expanded(
                  child: Text(
                    "-${(cartDataModel?.cartPrices?.discountAmount?.amount?.value ?? 0.0).toRupee}",
                    textAlign: TextAlign.end,
                    style: FontPalette.black16Regular,
                  ).avoidOverFlow(),
                ),
              ],
            ),
            12.verticalSpace,
          ],
          CustomExpandedWidget(
            backgroundColor: Colors.white,
            dividerColor: Colors.transparent,
            expandedWidget: Column(
              children: [
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        Constants.cgst,
                        style: FontPalette.f7B7E8E_16Regular,
                      ).avoidOverFlow(),
                    ),
                    Expanded(
                      child: Text(
                        (cartPrices?.gst?.cgst ?? 0.0).toRupee,
                        textAlign: TextAlign.end,
                        style: FontPalette.f7B7E8E_16Regular,
                      ).avoidOverFlow(),
                    ),
                  ],
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        Constants.sgst,
                        style: FontPalette.f7B7E8E_16Regular,
                      ).avoidOverFlow(),
                    ),
                    Expanded(
                      child: Text(
                        (cartPrices?.gst?.sgst ?? 0.0).toRupee,
                        textAlign: TextAlign.end,
                        style: FontPalette.f7B7E8E_16Regular,
                      ).avoidOverFlow(),
                    ),
                  ],
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    Constants.estimatedTax,
                    style: FontPalette.black16Regular,
                  ).avoidOverFlow(),
                ),
                Expanded(
                  child: Text(
                    (cartPrices?.gst?.totalGst ?? 0.0).toRupee,
                    textAlign: TextAlign.end,
                    style: FontPalette.black16Regular,
                  ).avoidOverFlow(),
                ),
              ],
            ),
          ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Constants.orderTotal,
                  style: FontPalette.black18Medium,
                ).avoidOverFlow(),
              ),
              Expanded(
                child: Text(
                  (cartPrices?.grandTotal?.value ?? 0.0).toRupee,
                  textAlign: TextAlign.end,
                  style: FontPalette.black18Medium,
                ).avoidOverFlow(),
              ),
            ],
          ),
          20.verticalSpace,
          CartRewardPoints(cartDataModel: cartDataModel),
          7.5.verticalSpace,
          const CentPercentSafeAndSecurePayment(),
        ],
      ),
    );
  }
}
