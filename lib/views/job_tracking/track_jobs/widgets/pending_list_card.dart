import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/service_listing_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class PendingListCard extends StatelessWidget {
  final ServiceList? item;
  const PendingListCard({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.model ?? "",
            style: FontPalette.black17Medium,
          ),
          Divider(
            height: 30.h,
            thickness: 1.h,
            color: HexColor("#EAEAEA"),
          ),
          BuildRow(
              text: Constants.issueDescription,
              subText: item?.issueDescription),
          5.verticalSpace,
          BuildRow(text: Constants.createdAt, subText: item?.createdAt),
        ],
      ),
    );
  }
}

class BuildRow extends StatelessWidget {
  final String? text;
  final String? subText;

  const BuildRow({
    Key? key,
    this.text,
    this.subText,
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
            style: FontPalette.f6C6C6C_14Regular,
          ),
        ],
      ),
    );
  }
}
