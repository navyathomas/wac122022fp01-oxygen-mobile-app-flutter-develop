import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/track_jobs_listing_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../../generated/assets.dart';

class TrackJobsCard extends StatelessWidget {
  final TrackJobsList? item;
  const TrackJobsCard({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> scale = ValueNotifier(1.0);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
            RouteGenerator.routeTrackJobsDetailScreen,
            arguments: item?.jobId);
      },
      onTapDown: (details) {
        scale.value = .985;
      },
      onTapUp: (details) {
        scale.value = 1.0;
      },
      onTapCancel: () {
        scale.value = 1.0;
      },
      child: ValueListenableBuilder<double>(
          valueListenable: scale,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item?.itemName ?? "",
                        style: FontPalette.black17Medium,
                      ),
                    ),
                    5.horizontalSpace,
                    _BuildStatus(
                        status: item?.status,
                        color: HexColor(item?.colorCode ?? "#000000")),
                  ],
                ),
                Divider(
                  height: 30.h,
                  thickness: 1.h,
                  color: HexColor("#EAEAEA"),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildRow(
                            text: Constants.jobId,
                            subText: item?.jobId,
                            isID: true),
                        5.verticalSpace,
                        BuildRow(
                            text: Constants.complaint,
                            subText: item?.complaint),
                        5.verticalSpace,
                        BuildRow(
                            text: Constants.estimatedDelivery,
                            subText: item?.estimatedDelivery),
                      ],
                    )),
                    SizedBox(
                      height: 12.r,
                      width: 12.r,
                      child: SvgPicture.asset(
                        Assets.iconsRightArrow,
                        color: HexColor("#7B7E8E"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          }),
    );
  }
}

class _BuildStatus extends StatelessWidget {
  final String? status;
  final Color? color;
  const _BuildStatus({Key? key, this.status, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
        decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            borderRadius: BorderRadius.circular(100.r)),
        child: Text(
          status ?? "",
          style: FontPalette.white13Medium,
        ));
  }
}

class BuildRow extends StatelessWidget {
  final String? text;
  final String? subText;
  final bool isID;
  const BuildRow({
    Key? key,
    this.text,
    this.subText,
    this.isID = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: text ?? "",
            style: FontPalette.f282C3F_14Regular,
          ),
          WidgetSpan(child: 5.horizontalSpace),
          TextSpan(
            text: ":",
            style: FontPalette.f282C3F_14Regular,
          ),
          WidgetSpan(child: 5.horizontalSpace),
          TextSpan(
            text: subText ?? "",
            style: isID
                ? FontPalette.fC13D33_14Regular
                : FontPalette.f6C6C6C_14Regular,
          ),
        ],
      ),
    );
  }
}
