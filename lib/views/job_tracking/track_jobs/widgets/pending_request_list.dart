import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/service_listing_model.dart';
import 'package:oxygen/providers/track_jobs_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/no_data_screen.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/pending_list_card.dart';
import 'package:oxygen/widgets/custom_circular_progress_indicator.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:provider/provider.dart';

class PendingRequestList extends StatelessWidget {
  final TrackJobsProvider pendingJobsProvider;
  const PendingRequestList({Key? key, required this.pendingJobsProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pendingJobsProvider,
      child: Selector<TrackJobsProvider, LoaderState>(
          selector: (context, provider) => provider.loaderState,
          builder: (context, value, child) {
            return _SwitchView(
              loaderState: value,
              pendingJobsProvider: pendingJobsProvider,
              loadedView: Selector<TrackJobsProvider, List<ServiceList?>?>(
                  selector: (context, provider) => provider.serviceList,
                  builder: (context, value, child) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        pendingJobsProvider.enableLoaderState = true;
                        pendingJobsProvider.getServiceList();
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
                            return PendingListCard(item: item);
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
  final TrackJobsProvider? pendingJobsProvider;
  const _SwitchView(
      {Key? key,
      this.loaderState = LoaderState.loaded,
      this.loadedView,
      this.pendingJobsProvider})
      : super(key: key);

  void tryAgain() {
    pendingJobsProvider?.getServiceList();
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
            titleText: Constants.noPendingRequest,
            subText: Constants.noPendingRequestNote,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
