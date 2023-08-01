import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/cent_percent_safe_and_secure_payment.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';
import 'package:provider/provider.dart';

import '../../../providers/my_orders_provider.dart';

class OrderDetailPriceDetailsWidget extends StatelessWidget {
  const OrderDetailPriceDetailsWidget({
    Key? key,
    this.grandTotal,
    this.includingTax,
    this.excludingTax,
    this.gst,
    this.discount,
    this.shippingFee,
  }) : super(key: key);

  final GrandTotal? grandTotal;
  final Gst? gst;
  final SubtotalExcludingTax? excludingTax;
  final SubtotalIncludingTax? includingTax;
  final Discount? discount;
  final SelectedShippingMethod? shippingFee;

  @override
  Widget build(BuildContext context) {
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
              Expanded(
                child: Text(
                  double.tryParse('${excludingTax?.value}')
                          ?.toRupee
                          .toString() ??
                      '₹${excludingTax?.value}',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
            ],
          ),
          discount?.amount?.value != null && discount?.amount?.value != 0
              ? 12.verticalSpace
              : const SizedBox.shrink(),
          discount?.amount?.value != null && discount?.amount?.value != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        Constants.discount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.black16Regular,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '₹${discount?.amount?.value}',
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.black16Regular,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Constants.delivery,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontPalette.black16Regular,
                ),
              ),
              Expanded(
                child: Text(
                  (shippingFee?.amount?.value ?? 0.0) > 0.0
                      ? '₹${shippingFee?.amount?.value}'
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
                        double.tryParse('${gst?.cgst}')?.toRupee.toString() ??
                            "₹${gst?.cgst}",
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
                        double.tryParse('${gst?.sgst}')?.toRupee.toString() ??
                            "₹${gst?.sgst}",
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
                    Constants.estimatedTax,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontPalette.black16Regular,
                  ),
                ),
                Expanded(
                  child: Text(
                    double.tryParse('${gst?.totalGst}')?.toRupee.toString() ??
                        "₹${gst?.totalGst}",
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
                  double.tryParse('${grandTotal?.value}')?.toRupee.toString() ??
                      "₹${grandTotal?.value?.toDouble()}",
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
        ],
      ),
    );
  }
}
