import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/track_jobs_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/important_terms.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/job_status.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/o2_care.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/customer_details.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/item_details.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/job_details.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/job_top_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_circular_progress_indicator.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

class TrackJobsDetailScreen extends StatefulWidget {
  final String? jobId;
  const TrackJobsDetailScreen({Key? key, this.jobId}) : super(key: key);

  @override
  State<TrackJobsDetailScreen> createState() => _TrackJobsDetailScreenState();
}

class _TrackJobsDetailScreenState extends State<TrackJobsDetailScreen> {
  TrackJobsDetailProvider? trackJobsDetailProvider;
  @override
  void initState() {
    trackJobsDetailProvider = TrackJobsDetailProvider();
    trackJobsDetailProvider?.enableLoaderState = true;
    trackJobsDetailProvider?.getJobStatusDetails(jobId: widget.jobId);
    super.initState();
  }

  @override
  void dispose() {
    trackJobsDetailProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.serviceTrackingDetail,
        actionList: const [],
      ),
      body: ChangeNotifierProvider.value(
        value: trackJobsDetailProvider,
        child: Selector<TrackJobsDetailProvider, LoaderState>(
            selector: (context, provider) => provider.loaderState,
            builder: (context, value, child) {
              return _SwitchView(
                loaderState: value,
                onTryAgain: () {
                  trackJobsDetailProvider?.getJobStatusDetails(
                      jobId: widget.jobId);
                },
                loadedView: CustomSlidingFadeAnimation(
                  fadeDuration: Duration.zero,
                  slideDuration: const Duration(milliseconds: 250),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const O2Care(),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: JobTopWidget(),
                        ),
                        const _BuildDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 20.h),
                          child: CustomExpandedWidget(
                            backgroundColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            trailColor: Colors.grey,
                            initiallyExpanded: true,
                            expandedWidget: Padding(
                              padding: EdgeInsets.only(top: 25.h),
                              child: const JobStatusWidget(),
                            ),
                            child: Text(Constants.jobStatus,
                                style: FontPalette.black18Medium),
                          ),
                        ),
                        const _BuildDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 20.h),
                          child: CustomExpandedWidget(
                            backgroundColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            trailColor: Colors.grey,
                            expandedWidget: Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: const CustomerDetailsWidget(),
                            ),
                            child: Text(Constants.customerDetails,
                                style: FontPalette.black18Medium),
                          ),
                        ),
                        const _BuildDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 20.h),
                          child: CustomExpandedWidget(
                            backgroundColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            trailColor: Colors.grey,
                            expandedWidget: Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: const ItemDetailsWidget(),
                            ),
                            child: Text(Constants.itemDetails,
                                style: FontPalette.black18Medium),
                          ),
                        ),
                        const _BuildDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 20.h),
                          child: CustomExpandedWidget(
                            backgroundColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            trailColor: Colors.grey,
                            expandedWidget: Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: const JobDetailsWidget(),
                            ),
                            child: Text(Constants.jobDetails,
                                style: FontPalette.black18Medium),
                          ),
                        ),
                        const _BuildDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 20.h),
                          child: const ImportantTerms(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
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

class _SwitchView extends StatelessWidget {
  final LoaderState loaderState;
  final Widget? loadedView;
  final dynamic Function()? onTryAgain;
  const _SwitchView(
      {Key? key,
      this.loaderState = LoaderState.loaded,
      this.loadedView,
      this.onTryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (loaderState) {
      case LoaderState.loading:
        return const CustomCircularProgressIndicator();
      case LoaderState.loaded:
        return loadedView ?? const SizedBox.shrink();
      case LoaderState.error:
        return ApiErrorScreens(
            loaderState: LoaderState.error, onTryAgain: onTryAgain);
      case LoaderState.networkErr:
        return ApiErrorScreens(
            loaderState: LoaderState.networkErr, onTryAgain: onTryAgain);
      case LoaderState.noData:
        return ApiErrorScreens(
            loaderState: LoaderState.noData, onTryAgain: onTryAgain);
      default:
        return const SizedBox.shrink();
    }
  }
}
