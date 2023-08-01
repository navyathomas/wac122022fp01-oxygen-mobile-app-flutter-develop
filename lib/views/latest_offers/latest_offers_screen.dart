import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/latest_offers_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/shimmers/latest_offers_shimmer.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LatestOffersScreen extends StatefulWidget {
  const LatestOffersScreen({Key? key}) : super(key: key);

  @override
  State<LatestOffersScreen> createState() => _LatestOffersScreenState();
}

class _LatestOffersScreenState extends State<LatestOffersScreen> {
  LatestOffersProvider? latestOffersProvider;

  Widget _latestOffersView(List<Widget> list) {
    return RefreshIndicator(
      onRefresh: () async => _onPageRefresh(),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          ...list,
          10.verticalSpace.convertToSliver(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
          buildContext: context, pageTitle: Constants.latestOffers),
      body: SafeArea(
        child: Selector<LatestOffersProvider,
                Tuple3<LoaderState, List<Widget>, bool>>(
            selector: (_, provider) => Tuple3(provider.loaderState,
                provider.latestOfferWidgets, provider.btnLoaderState),
            builder: (_, data, __) {
              switch (data.item1) {
                case LoaderState.loaded:
                  return _latestOffersView(data.item2);
                case LoaderState.loading:
                  return const LatestOffersShimmer();
                case LoaderState.error:
                  return ApiErrorScreens(
                      loaderState: data.item1,
                      btnLoader: data.item3,
                      onTryAgain: () {
                        latestOffersProvider?.getLatestOffers(context,
                            tryAgain: true);
                      });
                case LoaderState.networkErr:
                  return ApiErrorScreens(
                      loaderState: data.item1,
                      btnLoader: data.item3,
                      onTryAgain: () {
                        latestOffersProvider?.getLatestOffers(context,
                            tryAgain: true);
                      });
                case LoaderState.noData:
                  return ApiErrorScreens(
                    loaderState: data.item1,
                    btnLoader: data.item3,
                    onTryAgain: () {
                      latestOffersProvider?.getLatestOffers(context,
                          tryAgain: true);
                    },
                  );
                case LoaderState.noProducts:
                  return const SizedBox.shrink();
                  break;
              }
            }),
      ),
    );
  }

  @override
  void initState() {
    latestOffersProvider = context.read<LatestOffersProvider>();
    super.initState();
    CommonFunctions.afterInit(() async {
      await latestOffersProvider?.getLatestOffers(context);
    });
  }

  @override
  void dispose() {
    latestOffersProvider?.pageDispose();
    super.dispose();
  }

  void _onPageRefresh() async {
    await latestOffersProvider?.getLatestOffers(context, tryAgain: true);
  }
}
