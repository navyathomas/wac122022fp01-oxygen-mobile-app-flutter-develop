import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/job_status_detail_model.dart';
import 'package:oxygen/providers/track_jobs_detail_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class CustomerDetailsWidget extends StatelessWidget {
  const CustomerDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TrackJobsDetailProvider, CustomerDetails?>(
        selector: (context, provider) =>
            provider.jobStatusData?.jobStatusDetails?.customerDetails,
        builder: (context, value, child) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuildRow(
                    title: Constants.id, value: value?.customerId?.toString()),
                _BuildRow(title: Constants.name, value: value?.customerName),
                _BuildRow(title: Constants.phone, value: value?.customerPhone),
                20.verticalSpace,
                Text(Constants.shippingAddress,
                    style: FontPalette.black16Regular),
                4.verticalSpace,
                Text(value?.shippingAddress ?? "",
                    style: FontPalette.f6C6C6C_16Regular),
                20.verticalSpace,
                Text(Constants.billingAddress,
                    style: FontPalette.black16Regular),
                4.verticalSpace,
                Text(value?.billingAddress ?? "",
                    style: FontPalette.f6C6C6C_16Regular),
              ],
            ),
          );
        });
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
