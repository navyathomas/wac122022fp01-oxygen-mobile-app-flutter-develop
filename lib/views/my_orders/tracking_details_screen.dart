import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/my_orders/widgets/customer_details_tracking.dart';
import 'package:oxygen/views/my_orders/widgets/tracking_details_stepper.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';

class TrackingDetailScreen extends StatelessWidget {
  final TrackDeliveryStatus? trackDeliveryStatus;
  final CustomerDeliveryDetails? customerDeliveryDetails;

  const TrackingDetailScreen(
      {Key? key, this.customerDeliveryDetails, this.trackDeliveryStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.trackingDetails,
        actionList: const [],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: CustomExpandedWidget(
                backgroundColor: Colors.transparent,
                dividerColor: Colors.transparent,
                trailColor: Colors.grey,
                initiallyExpanded: true,
                expandedWidget: Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: TrackingDetailsStepper(
                      steps: trackDeliveryStatus?.status),
                ),
                child: Text(Constants.trackingStatus,
                    style: FontPalette.black18Medium),
              ),
            ),
            10.verticalSpace,
            if (trackDeliveryStatus?.expectedDelivery != null)
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                color: HexColor("#F4F4F4"),
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            trackDeliveryStatus?.expectedDelivery?.title ?? "",
                        style: FontPalette.black14Medium,
                      ),
                      TextSpan(
                        text: " : ",
                        style: FontPalette.black14Medium,
                      ),
                      TextSpan(
                        text: trackDeliveryStatus?.expectedDelivery?.date ?? "",
                        style: FontPalette.black14Regular,
                      ),
                    ],
                  ),
                ),
              ),
            10.verticalSpace,
            const _BuildDivider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: CustomExpandedWidget(
                backgroundColor: Colors.transparent,
                dividerColor: Colors.transparent,
                trailColor: Colors.grey,
                initiallyExpanded: true,
                expandedWidget: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: CustomerDetailsTracking(
                      customerDeliveryDetails: customerDeliveryDetails),
                ),
                child: Text(Constants.customerDetails,
                    style: FontPalette.black18Medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildDivider extends StatelessWidget {
  const _BuildDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 20.h,
      thickness: 5.h,
      color: HexColor("#F3F3F7"),
    );
  }
}
