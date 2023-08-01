import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/cart_data_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../../../../services/app_config.dart';

class CartBottomSheet extends StatelessWidget {
  final VoidCallback onTap;

  const CartBottomSheet({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, CartDataModel?>(
      selector: (context, provider) => provider.cartDataModel,
      builder: (_, value, child) {
        if (value == null || value.cartPrices?.grandTotal == null) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 73.h,
          decoration: CommonStyles.bottomDecoration,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (value.cartPrices?.grandTotal?.value ?? 0.0).toRupee,
                        strutStyle: StrutStyle(height: 1.4.h),
                        maxLines: 1,
                        style: FontPalette.black18Bold,
                      ),
                      Text(
                        "Total ${value.cartItems?.length ?? 0} items",
                        maxLines: 1,
                        style: FontPalette.f7B7E8E_14Regular,
                      ),
                    ],
                  ),
                ),
                10.horizontalSpace,
                CustomButton(
                  title: Constants.placeOrder,
                  height: 45.h,
                  width: 170,
                  enabled: !(value.allNotInStock ?? false),
                  onPressed: !(value.allNotInStock ?? false)
                      ? () {
                          if (AppConfig.isAuthorized) {
                            FirebaseAnalyticsService.instance.logBeginCheckOut(
                                value:
                                    value.cartPrices?.grandTotal?.value ?? 0.0,
                                coupon: (value.appliedCoupons ?? []).isNotEmpty
                                    ? value.appliedCoupons?.first.code
                                    : '');
                          }
                          onTap();
                        }
                      : null,
                )
              ],
            ),
          ),
        ).translateWidgetVertically(value: 1);
      },
    );
  }
}
