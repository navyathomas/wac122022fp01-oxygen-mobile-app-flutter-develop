import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/track_jobs_listing_model.dart';
import 'package:oxygen/providers/track_jobs_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/no_data_screen.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/track_jobs_card.dart';
import 'package:oxygen/widgets/custom_circular_progress_indicator.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:provider/provider.dart';

class TrackJobList extends StatelessWidget {
  final TrackJobsProvider trackJobsProvider;
  const TrackJobList({
    Key? key,
    required this.trackJobsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: trackJobsProvider,
      child: Selector<TrackJobsProvider, LoaderState>(
          selector: (context, provider) => provider.loaderState,
          builder: (context, value, child) {
            return _SwitchView(
              loaderState: value,
              trackJobsProvider: trackJobsProvider,
              loadedView: Selector<TrackJobsProvider, List<TrackJobsList?>?>(
                  selector: (context, provider) => provider.trackJobsList,
                  builder: (context, value, child) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        trackJobsProvider.enableLoaderState = true;
                        trackJobsProvider.getTrackJobList();
                      },
                      child: CustomSlidingFadeAnimation(
                        fadeDuration: Duration.zero,
                        slideDuration: const Duration(milliseconds: 250),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          itemCount: value?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = value?.elementAt(index);
                            return TrackJobsCard(item: item);
                          },
                          separatorBuilder: (context, index) => 8.verticalSpace,
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}

class _SwitchView extends StatelessWidget {
  final LoaderState loaderState;
  final Widget? loadedView;
  final TrackJobsProvider? trackJobsProvider;
  const _SwitchView(
      {Key? key,
      this.loaderState = LoaderState.loaded,
      this.loadedView,
      this.trackJobsProvider})
      : super(key: key);

  void tryAgain() {
    trackJobsProvider?.getTrackJobList();
  }

  @override
  Widget build(BuildContext context) {
    switch (loaderState) {
      case LoaderState.loading:
        return const CustomCircularProgressIndicator();
      case LoaderState.loaded:
        return loadedView ?? const SizedBox.shrink();
      case LoaderState.error:
        return CustomSlidingFadeAnimation(
          fadeDuration: Duration.zero,
          slideDuration: const Duration(milliseconds: 250),
          child: ApiErrorScreens(
              loaderState: LoaderState.error, onTryAgain: tryAgain),
        );
      case LoaderState.networkErr:
        return CustomSlidingFadeAnimation(
          fadeDuration: Duration.zero,
          slideDuration: const Duration(milliseconds: 250),
          child: ApiErrorScreens(
              loaderState: LoaderState.networkErr, onTryAgain: tryAgain),
        );
      case LoaderState.noData:
        return CustomSlidingFadeAnimation(
          fadeDuration: Duration.zero,
          slideDuration: const Duration(milliseconds: 250),
          child: NoDataScreen(
            onTryAgain: tryAgain,
            titleText: Constants.noJobsAssigned,
            subText: Constants.noJobsAssignedNote,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
