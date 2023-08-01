import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/stores_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/store/widgets/store_details_tile.dart';
import 'package:oxygen/views/store/widgets/store_drop_down.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  StoresProvider? storesProvider;
  late GlobalKey dropdownKey;
  ValueNotifier<double> scrollOffset = ValueNotifier<double>(0.0);

  Widget _storeList() {
    return Consumer<StoresProvider>(
        builder: (_, provider, __) => provider.loaderState ==
                LoaderState.loading
            ? const CommonLinearProgress()
            : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const _LinearIndicator(),
                    StoreDropDown(
                      districtList: provider.districtList,
                      isScrolled: provider.parrentSrolled,
                      onChanged: (v) => onFilterValueChanged(v),
                      offeset: scrollOffset,
                    ),
                    provider.filterIsLoading
                        ? const SizedBox()
                        : Expanded(
                            child: CustomSlidingFadeAnimation(
                              slideDuration: const Duration(milliseconds: 250),
                              child: CustomScrollView(
                                controller: provider.scrollController,
                                slivers: [
                                  provider.filteredList.isEmpty
                                      ? SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (ctx, index) {
                                              return StoreDetailsTile(
                                                index: index,
                                                storeModel:
                                                    provider.storesList[index],
                                                onDirectionClick: (
                                                        {lat, long}) =>
                                                    openDirection(lat, long),
                                              );
                                            },
                                            childCount: storesProvider
                                                    ?.storesList.length ??
                                                0,
                                          ),
                                        )
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (ctx, index) {
                                              return StoreDetailsTile(
                                                index: index,
                                                storeModel: provider
                                                    .filteredList[index],
                                                onDirectionClick: (
                                                        {lat, long}) =>
                                                    openDirection(lat, long),
                                              );
                                            },
                                            childCount: storesProvider
                                                    ?.filteredList.length ??
                                                0,
                                          ),
                                        ),
                                  provider.paginationLoading
                                      ? SizedBox(
                                          width: context.sw(),
                                          height: 50.h,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ).convertToSliver()
                                      : const SizedBox.shrink()
                                          .convertToSliver()
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.stores,
        actionList: const [],
      ),
      body: Selector<StoresProvider, Tuple2<LoaderState, bool>>(
        selector: (_, provider) =>
            Tuple2(provider.loaderState, provider.btnLoaderState),
        builder: (_, data, __) {
          switch (data.item1) {
            case LoaderState.loaded:
              return _storeList();
            case LoaderState.loading:
              return _storeList();
            case LoaderState.error:
              return ApiErrorScreens(
                loaderState: data.item1,
                btnLoader: data.item2,
                onTryAgain: () {
                  storesProvider?.pageInit();
                  storesProvider?.getStoresList(
                    context,
                    tryAgainFromFailed: true,
                  );
                },
              );
            case LoaderState.networkErr:
              return ApiErrorScreens(
                loaderState: data.item1,
                btnLoader: data.item2,
                onTryAgain: () {
                  storesProvider?.pageInit();
                  storesProvider?.getStoresList(
                    context,
                    tryAgainFromFailed: true,
                  );
                },
              );
            case LoaderState.noData:
              return ApiErrorScreens(loaderState: data.item1);
            case LoaderState.noProducts:
              return const SizedBox.shrink();
              break;
          }
        },
      ),
    );
  }

  void onFilterValueChanged(String? location) async {
    if (location?.toLowerCase() == 'all locations') {
      storesProvider?.currentPage = 1;
      storesProvider?.updateFilterLoading(true);
      await storesProvider
          ?.getStoresList(context, allLocations: true)
          .then((value) => storesProvider?.updateFilterLoading(false));
    } else {
      storesProvider?.updateFilterLoading(true);
      await storesProvider
          ?.getStoresList(context, location: location)
          .then((_) => storesProvider?.updateFilterLoading(false));
    }
  }

  Future<void> openDirection(double? lat, long) async {
    var fallbackUrl = 'geo:$lat,$long';
    var url = Platform.isAndroid
        ? 'google.navigation:q=$lat,$long&mode=d'
        : 'https://maps.apple.com/?q=$lat,$long';
    try {
      bool launched = await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    storesProvider = context.read<StoresProvider>();
    storesProvider?.pageInit();
    storesProvider!.scrollController.addListener(() {
      storesProvider!.pagination(context, storesProvider!.scrollController);
      storesProvider?.updateScroll(true);
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        storesProvider?.getStoresList(context);
      },
    );
    storesProvider?.scrollController.addListener(() {
      scrollOffset.value = storesProvider?.scrollController.offset ?? 0.0;
    });
  }

  @override
  void dispose() {
    storesProvider?.scrollController.dispose();
    super.dispose();
  }
}

class _LinearIndicator extends StatelessWidget {
  const _LinearIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<StoresProvider, bool>(
      selector: (_, s) => s.filterIsLoading,
      builder: (_, isLoading, __) {
        return isLoading
            ? const CommonLinearProgress()
            : SizedBox(
                height: 2.h,
              );
      },
    );
  }
}
