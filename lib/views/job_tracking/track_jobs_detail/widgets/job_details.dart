import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/job_status_detail_model.dart';
import 'package:oxygen/providers/track_jobs_detail_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class JobDetailsWidget extends StatelessWidget {
  const JobDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TrackJobsDetailProvider, JobDetails?>(
        selector: (context, provider) =>
            provider.jobStatusData?.jobStatusDetails?.jobDetails,
        builder: (context, value, child) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuildRow(title: Constants.assignedTo, text: value?.assignedTo),
                15.verticalSpace,
                _BuildRow(title: Constants.complaint, text: value?.complaint),
                15.verticalSpace,
                _BuildRow(title: Constants.jobAddedOn, text: value?.jobAddedOn),
                15.verticalSpace,
                _BuildRow(title: Constants.jobAddedBy, text: value?.jobAddedBy),
                15.verticalSpace,
                _BuildRow(
                    title: Constants.currentCondition,
                    text: value?.currentCondition),
                15.verticalSpace,
                _BuildRow(
                    title: Constants.expectedDeliveryDate,
                    text: value?.expectedDelivery),
                15.verticalSpace,
                _BuildRow(
                    title: Constants.accessoriesReceived,
                    text: value?.accessoriesReceived),
                15.verticalSpace,
                _BuildRow(
                    title: Constants.accountClosed,
                    text: value?.accountClosed,
                    textStyle: FontPalette.f039614_16Medium),
                15.verticalSpace,
                _BuildRow(
                    title: Constants.contactDetails,
                    text: value?.contactDetails),
                15.verticalSpace,
              ],
            ),
          );
        });
  }
}

class _BuildRow extends StatelessWidget {
  final String? title;
  final String? text;
  final TextStyle? textStyle;
  const _BuildRow({
    Key? key,
    this.title,
    this.text,
    this.textStyle,
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
            text: text ?? "",
            style: textStyle ?? FontPalette.f6C6C6C_16Regular,
          ),
        ],
      ),
    );
  }
}
