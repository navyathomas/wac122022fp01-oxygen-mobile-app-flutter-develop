import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/order_tracking_indicator.dart';
import 'package:provider/provider.dart';

class OrderDetailTrackingWidget extends StatelessWidget {
  const OrderDetailTrackingWidget(
      {Key? key,
      this.product,
      this.currentStatus,
      this.orderProcess,
      this.createdAt,
      this.orderNumber,
      this.status,
      this.paymentMethod})
      : super(key: key);

  final Products? product;
  final CurrentStatus? currentStatus;
  final Map<String, dynamic>? orderProcess;
  final String? createdAt;
  final String? orderNumber;
  final String? status;
  final OrderPaymentMethod? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constants.orderTracking,
                style: FontPalette.black18Medium,
              ),
              16.verticalSpace,
              Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        child: OrderTracker(
                          status: status?.toLowerCase() ==
                                  Constants.canceled.toLowerCase()
                              ? MyOrderStatus.canceled
                              : status == Constants.paymentFailed
                                  ? MyOrderStatus.paymentFailed
                                  : getDeliveryStatus(currentStatus),
                          // status: MyOrderStatus.ordered,
                        ),
                      ),
                    ],
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: Constants.orderConfirmed,
                                style: FontPalette.black16Regular,
                              ),
                              WidgetSpan(child: 10.horizontalSpace),
                              TextSpan(
                                text: orderProcess?['Order Placed'],
                                style: FontPalette.f7E818C_14Regular,
                              ),
                            ],
                          ),
                        ),
                        status?.toLowerCase() !=
                                    Constants.canceled.toLowerCase() &&
                                status != Constants.paymentFailed
                            ? Column(
                                children: [
                                  18.verticalSpace,
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: Constants.shipped,
                                          style: FontPalette.black16Regular,
                                        ),
                                        WidgetSpan(child: 10.horizontalSpace),
                                        TextSpan(
                                          text: orderProcess?['Shipped'],
                                          style:
                                              FontPalette.f7E818C_14Regular,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        18.verticalSpace,
                        RichText(
                          maxLines: 1,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: status?.toLowerCase() ==
                                        Constants.canceled.toLowerCase()
                                    ? 'Order Canceled'
                                    : status == Constants.paymentFailed
                                        ? Constants.paymentFailed
                                        : status?.toLowerCase() ==
                                                Constants.delivered
                                                    .toLowerCase()
                                            ? Constants.delivered
                                            : Constants.outForDelivery,
                                style: FontPalette.black16Regular,
                              ),
                              WidgetSpan(child: 10.horizontalSpace),
                              status?.toLowerCase() !=
                                          Constants.canceled.toLowerCase() &&
                                      status != Constants.paymentFailed
                                  ? TextSpan(
                                      text: orderProcess?['Delivery'],
                                      style: FontPalette.f7E818C_14Regular,
                                    )
                                  : const WidgetSpan(
                                      child: SizedBox.shrink()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 5.h,
          thickness: 5.h,
          color: HexColor("#F3F3F7"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: Constants.orderPlaced,
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        text: ":",
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        // text: "07 Jun 2020",
                        text: DateFormat('dd MMM yyyy').format(DateTime.parse(
                            createdAt ?? '0000-00-00 00:00:00')),
                        style: FontPalette.black16Medium,
                      ),
                    ],
                  ),
                ),
              ),
              12.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: Constants.orderNo,
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        text: ":",
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        text: orderNumber,
                        style: FontPalette.black16Medium,
                      ),
                    ],
                  ),
                ),
              ),
              12.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: Constants.paymentMode,
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        text: ":",
                        style: FontPalette.black16Regular,
                      ),
                      WidgetSpan(child: 5.horizontalSpace),
                      TextSpan(
                        text: paymentMethod?.methodTitle,
                        style: FontPalette.black16Medium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider(
        //   height: 5.h,
        //   thickness: 5.h,
        //   color: HexColor("#F3F3F7"),
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Flexible(
        //           child: Text(Constants.cancelOrder,
        //               style: FontPalette.black16Medium)),
        //       Padding(
        //         padding: EdgeInsets.only(right: 9.w),
        //         child: SizedBox(
        //           height: 12.r,
        //           width: 12.r,
        //           child: SvgPicture.asset(
        //             Assets.iconsRightArrow,
        //             color: HexColor("#7B7E8E"),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  MyOrderStatus getDeliveryStatus(CurrentStatus? status) {
    MyOrderStatus orderStatus = MyOrderStatus.ordered;
    if (status != null) {
      switch (status.value) {
        case 2:
          orderStatus = MyOrderStatus.shipped;
          break;
        case 3:
          orderStatus = MyOrderStatus.outForDelivery;
          break;
      }
    }
    return orderStatus;
  }
}
