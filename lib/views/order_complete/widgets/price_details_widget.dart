import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/order_details_response_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/widgets/cent_percent_safe_and_secure_payment.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_expanded_widget.dart';

class PriceDetailsWidget extends StatelessWidget {
  const PriceDetailsWidget(
      {Key? key, this.orderDetailsPrices, this.orderDetailsItems})
      : super(key: key);
  final OrderDetailsPrices? orderDetailsPrices;
  final OrderDetailsItems? orderDetailsItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#FFFFFF'),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
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
                  "Total Price",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
              Expanded(
                child: Text(
                  Helpers.convertToDouble(orderDetailsPrices?.grandTotal?.value)
                      .toRupee
                      .toString(),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Delivery",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
              Expanded(
                child: Text(
                  (orderDetailsItems?.orderShippingMethod?.amount?.value ??
                              0.0) >
                          0.0
                      ? (Helpers.convertToDouble(orderDetailsItems
                              ?.orderShippingMethod?.amount?.value)
                          .toRupee)
                      : Constants.free,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.f039614_16Regular,
                ),
              ),
            ],
          ),
          12.verticalSpace,
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
                        "CGST",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.f7B7E8E_16Regular,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Helpers.convertToDouble(orderDetailsPrices?.gst?.cgst)
                            .toRupee,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.f7B7E8E_16Regular,
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "SGST",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.f7B7E8E_16Regular,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Helpers.convertToDouble(orderDetailsPrices?.gst?.sgst)
                            .toRupee,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.f7B7E8E_16Regular,
                      ),
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
                    "Estimated Tax",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontPalette.black16Regular,
                  ),
                ),
                Expanded(
                  child: Text(
                    Helpers.convertToDouble(orderDetailsPrices?.gst?.totalGst)
                        .toRupee,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontPalette.black16Regular,
                  ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black18Medium,
                ),
              ),
              Expanded(
                child: Text(
                  Helpers.convertToDouble(orderDetailsPrices?.grandTotal?.value)
                      .toRupee,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black18Medium,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          const CentPercentSafeAndSecurePayment(),
          210.verticalSpace
        ],
      ),
    );
  }
}
