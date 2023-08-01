import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/job_status_detail_model.dart';
import 'package:oxygen/providers/track_jobs_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class ItemDetailsWidget extends StatelessWidget {
  const ItemDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TrackJobsDetailProvider, List<ItemDetail?>?>(
        selector: (context, provider) =>
            provider.jobStatusData?.jobStatusDetails?.itemDetails,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Wrap(
                    runSpacing: 21.h,
                    spacing: 10,
                    children: List.generate(value?.length ?? 0, (index) {
                      final item = value?.elementAt(index);
                      return _BuildWrap(
                        constraints: constraints,
                        title: item?.title,
                        text: item?.value,
                        colorCode: item?.colorCode,
                      );
                    }),
                  );
                }),
              ),
            ],
          );
        });
  }
}

class _BuildWrap extends StatelessWidget {
  final BoxConstraints constraints;
  final String? title;
  final String? text;
  final String? colorCode;
  const _BuildWrap({
    Key? key,
    required this.constraints,
    this.title,
    this.text,
    this.colorCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (constraints.maxWidth / 2) - 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "", style: FontPalette.black16Regular),
          Text(text ?? "",
              style: (colorCode == null || (colorCode?.isEmpty ?? true))
                  ? FontPalette.f6C6C6C_16Regular
                  : FontPalette.black16Medium
                      .copyWith(color: HexColor(colorCode ?? "#000000"))),
        ],
      ),
    );
  }
}
