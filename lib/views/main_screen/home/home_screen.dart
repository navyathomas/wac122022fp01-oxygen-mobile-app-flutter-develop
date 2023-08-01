import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/home_provider.dart';
import 'package:oxygen/services/one_signal_message_service.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_error_screen.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_header.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_search_bar.dart';
import 'package:oxygen/views/shimmers/home_screen_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/common_function.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> isAppBarScrolled;

  const HomeScreen(
      {Key? key,
      required this.scrollController,
      required this.isAppBarScrolled})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(() {
      NotificationServices.instance.oneSignalInitialization(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
        floatHeaderSlivers: true,
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor: ColorPalette.primaryColor,
              flexibleSpace: HomeHeader(
                valueNotifier: widget.isAppBarScrolled,
              ),
              floating: true,
              toolbarHeight: 55.h,
            ),
          ];
        },
        body: Transform.translate(
          offset: Offset(0, -2.h),
          child: RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<HomeProvider>()
                    .getHomeData(context, enableLoader: false);
              },
              child: const _HomeViewHandler()),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _HomeViewHandler extends StatelessWidget {
  const _HomeViewHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<HomeProvider, Tuple2<LoaderState, List<Widget>>>(
      selector: (context, provider) =>
          Tuple2(provider.loaderState, provider.homeWidgets),
      builder: (context, homeModel, _) {
        switch (homeModel.item1) {
          case LoaderState.loaded:
            return _CustomScrollView(children: [
              ...homeModel.item2,
              20.verticalSpace.convertToSliver()
            ]);
          case LoaderState.loading:
            return _CustomScrollView(
                children: [const HomeScreenShimmer().convertToSliver()]);
          case LoaderState.error:
            return _CustomScrollView(children: [
              HomeErrorScreen(
                loaderState: LoaderState.error,
                onTap: () {
                  CommonFunctions.afterInit(
                      () => context.read<HomeProvider>().getHomeData(context));
                },
              ).convertToSliver()
            ]);
          case LoaderState.networkErr:
            return _CustomScrollView(children: [
              HomeErrorScreen(
                  loaderState: LoaderState.networkErr,
                  onTap: () {
                    CommonFunctions.afterInit(() =>
                        context.read<HomeProvider>().getHomeData(context));
                  }).convertToSliver()
            ]);
          case LoaderState.noData:
            return _CustomScrollView(children: [
              const HomeErrorScreen(loaderState: LoaderState.noData)
                  .convertToSliver()
            ]);
          case LoaderState.noProducts:
            return const SizedBox.shrink();
            break;
        }
      },
    );
  }
}

class _CustomScrollView extends StatelessWidget {
  final List<Widget> children;

  const _CustomScrollView({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: ColorPalette.primaryColor,
          automaticallyImplyLeading: false,
          flexibleSpace: const HomeSearchBar(),
          floating: true,
          pinned: true,
          toolbarHeight: 50.h,
        ),
        ...children,
        20.verticalSpace.convertToSliver()
      ],
    );
  }
}
