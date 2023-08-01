import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/job_status_detail_model.dart';
import 'package:oxygen/providers/track_jobs_detail_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class JobTopWidget extends StatelessWidget {
  const JobTopWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<TrackJobsDetailProvider, JobCategory?>(
            selector: (context, provider) =>
                provider.jobStatusData?.jobStatusDetails?.jobCategory,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constants.jobCategory,
                            style: FontPalette.black14Regular),
                        2.verticalSpace,
                        Text(value?.jobCategory ?? "",
                            style: FontPalette.black14Regular),
                      ],
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constants.jobNo,
                            style: FontPalette.black14Regular),
                        2.verticalSpace,
                        Text(value?.jobId ?? "",
                            style: FontPalette.black14Regular),
                      ],
                    ),
                  )
                ],
              );
            }),
        28.verticalSpace,
        Selector<TrackJobsDetailProvider, LastStatusUpdate?>(
            selector: (context, provider) =>
                provider.jobStatusData?.jobStatusDetails?.lastStatusUpdate,
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constants.lastStatusUpdated,
                            style: FontPalette.black14Regular),
                        2.verticalSpace,
                        Text(value?.lastUpdatedDate ?? "",
                            style: FontPalette.f6C6C6C_14Regular),
                      ],
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constants.updatedBy,
                            style: FontPalette.black14Regular),
                        2.verticalSpace,
                        Text(value?.updatedBy ?? "",
                            style: FontPalette.f6C6C6C_14Regular),
                      ],
                    ),
                  )
                ],
              );
            }),
      ],
    );
  }
}
