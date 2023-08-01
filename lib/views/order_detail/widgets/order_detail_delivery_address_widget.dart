import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class OrderDetailDeliveryAddressWidget extends StatelessWidget {
  const OrderDetailDeliveryAddressWidget({Key? key, this.address})
      : super(key: key);

  final ShippingAddresses? address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Constants.deliveryAddress,
            style: FontPalette.black18Medium,
          ),
          11.verticalSpace,
          Row(
            children: [
              Flexible(
                child: Text(
                  '${address?.firstname} ${address?.lastname}',
                  style: FontPalette.black16Medium,
                ),
              ),
              11.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: HexColor("#E6E6E6"),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (address?.addresstype ?? '-1') == '0'
                      ? Constants.home
                      : Constants.work,
                  style: FontPalette.black12Medium,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            '${address?.address}\nEmail:${context.read<MyOrdersProvider>().emailAddress}',
            style: FontPalette.f757575_12Regular.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
