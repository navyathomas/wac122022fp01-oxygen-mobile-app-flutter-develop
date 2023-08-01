import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/utils/font_palette.dart';

class CustomerDetailsTracking extends StatelessWidget {
  final CustomerDeliveryDetails? customerDeliveryDetails;
  const CustomerDetailsTracking({
    Key? key,
    this.customerDeliveryDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildRow(
              title: Constants.id,
              value: customerDeliveryDetails?.customerId?.toString()),
          _BuildRow(
              title: Constants.name,
              value: customerDeliveryDetails?.customerName),
          _BuildRow(
              title: Constants.phone,
              value: customerDeliveryDetails?.customerPhone),
          20.verticalSpace,
          Text(Constants.shippingAddress, style: FontPalette.black16Regular),
          4.verticalSpace,
          Text(customerDeliveryDetails?.shippingAddress ?? "",
              style: FontPalette.f6C6C6C_16Regular),
          20.verticalSpace,
          Text(Constants.billingAddress, style: FontPalette.black16Regular),
          4.verticalSpace,
          Text(customerDeliveryDetails?.billingAddress ?? "",
              style: FontPalette.f6C6C6C_16Regular),
        ],
      ),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final String? title;
  final String? value;
  const _BuildRow({
    Key? key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: title ?? "",
            style: FontPalette.black16Regular,
          ),
          WidgetSpan(child: 5.horizontalSpace),
          TextSpan(
            text: ":",
            style: FontPalette.black16Regular,
          ),
          WidgetSpan(child: 5.horizontalSpace),
          TextSpan(
            text: value ?? "",
            style: FontPalette.f6C6C6C_16Regular,
          ),
        ],
      ),
    );
  }
}
