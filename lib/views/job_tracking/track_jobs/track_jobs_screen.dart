import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/track_jobs_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/pending_request_list.dart';
import 'package:oxygen/views/job_tracking/track_jobs/widgets/track_job_list.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';

class TrackJobScreen extends StatefulWidget {
  final int? initialIndex;
  const TrackJobScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<TrackJobScreen> createState() => _TrackJobScreenState();
}

class _TrackJobScreenState extends State<TrackJobScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  late TrackJobsProvider trackJobsProvider;
  late TrackJobsProvider pendingJobsProvider;

  @override
  void initState() {
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex ?? 0);
    trackJobsProvider = TrackJobsProvider();
    pendingJobsProvider = TrackJobsProvider();
    trackJobsProvider.enableLoaderState = true;
    pendingJobsProvider.enableLoaderState = true;
    trackJobsProvider.getTrackJobList();
    pendingJobsProvider.getServiceList();
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    trackJobsProvider.dispose();
    pendingJobsProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: HexColor("#F3F3F7"),
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.serviceTracking,
        actionList: const [],
      ),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            elevation: 1,
            shadowColor: HexColor('#E6E6E6'),
            child: TabBar(
                controller: tabController,
                unselectedLabelStyle: FontPalette.black16Medium,
                labelStyle: FontPalette.black16Medium,
                labelColor: Colors.black,
                indicatorColor: ColorPalette.primaryColor,
                unselectedLabelColor: Colors.black,
                labelPadding: EdgeInsets.only(top: 6.h),
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
                      ? null
                      : ColorPalette.primaryColor.withOpacity(.10);
                }),
                tabs: const [
                  Tab(
                    text: Constants.trackJobs,
                  ),
                  Tab(text: Constants.pendingRequest)
                ]),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              TrackJobList(trackJobsProvider: trackJobsProvider),
              PendingRequestList(pendingJobsProvider: pendingJobsProvider),
            ],
          ))
        ],
      ),
    );
  }
}
