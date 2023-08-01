import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/cart_data_model.dart';

class BajajEmiPriceDetailsWidget extends StatelessWidget {
  final CartDataModel? cartDataModel;

  const BajajEmiPriceDetailsWidget({
    Key? key,
    this.cartDataModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, CartPrices?>(
        selector: (context, provider) => provider.cartDataModel?.cartPrices,
        builder: (context, cartPrices, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        (cartPrices?.subtotalExcludingTax?.value ?? 0.0)
                            .toRupee,
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
              ],
            ),
          );
        });
  }
}
