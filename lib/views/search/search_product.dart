import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/arguments/product_listing_arguments.dart';
import 'package:oxygen/providers/search_provider.dart';
import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/search/widgets/recently_searched_list_tile.dart';
import 'package:oxygen/views/search/widgets/recently_viewed_tile.dart';
import 'package:oxygen/views/search/widgets/trending_list_view.dart';
import 'package:oxygen/views/shimmers/search_tile_shimmer.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_divider.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/empty_app_bar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../error_screens/custom_error_screens.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({Key? key}) : super(key: key);

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen>
    with WidgetsBindingObserver {
  FocusNode focusNode = FocusNode();
  late SearchProvider searchProvider;
  Timer? _throttle;

  @override
  void initState() {
    searchProvider = SearchProvider();
    WidgetsBinding.instance.addObserver(this);

    CommonFunctions.afterInit(() {
      searchProvider
        ..pageInit()
        ..getTrendSearchList()
        ..getRecentlyViewedProducts();
      searchProvider.getRecentlySearchedKeys();
      searchProvider.searchController.clear();
      focusNode.requestFocus();
    });
    super.initState();
  }

  Widget _searchBar(SearchProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1.r,
            spreadRadius: 1.r,
            offset: const Offset(0.0, -0.5),
          ),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 15.h, bottom: 10.h, left: 12.w, right: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.center,
              height: 37.h,
              decoration: BoxDecoration(color: ColorPalette.shimmerBaseColor),
              child: TextFormField(
                focusNode: focusNode,
                controller: provider.searchController,
                onChanged: (value) {
                  onValueChanged(value);
                },
                onFieldSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  provider.updateSearchLoader(LoaderState.loaded);

                  provider.updateSearchProduct(value.trim());
                  provider.updateIsFromSearchProductListingScreen(false);
                  Navigator.pushNamed(
                          context, RouteGenerator.routeSearchProductListing,
                          arguments: ProductListingArguments(
                              isFromSearch: true,
                              searchProvider: searchProvider,
                              title: searchProvider.productItem))
                      .then((value) {
                    focusNode.requestFocus();
                  });
                },
                textInputAction: TextInputAction.search,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 37.34.w,
                          minHeight: 37.34.w,
                        ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            9.horizontalSpace,
                            SvgPicture.asset(
                              Assets.iconsSearch,
                              width: 15.34.w,
                              height: 16.h,
                            ),
                            12.horizontalSpace
                          ],
                        ),
                        suffixIcon: provider.searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  provider.searchController.clear();
                                  provider.updateSearchInput('');
                                  provider.getRecentlySearchedKeys();
                                },
                                icon: SvgPicture.asset(Assets.iconsClose),
                                splashColor: Colors.transparent,
                              )
                            : const SizedBox.shrink(),
                        hintText: Constants.searchForProducts,
                        hintStyle: FontPalette.black14Regular
                            .copyWith(color: HexColor('#7D808B')))
                    .copyWith(isDense: true),
              ),
            )),
            5.horizontalSpace,
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (searchProvider.isFromSearchProductListing) {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                }
                Navigator.of(context).maybePop();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 9.w),
                height: 45.h,
                child: Text(
                  Constants.cancel,
                  style: FontPalette.black16Regular,
                ),
              ),
            ).removeSplash()
          ],
        ),
      ),
    );
  }

  Widget _initialView(SearchProvider provider) {
    return (provider.productItem.notEmpty)
        ? _productListingView(provider)
        : provider.loaderState == LoaderState.loading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: const SearchTileShimmer(),
              )
            : _searchBanners(provider);
  }

  Widget _recentlySearched(SearchProvider provider) {
    return provider.searchController.text.isEmpty &&
            provider.recentlySearchedList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 11.h),
                  child: Text(
                    Constants.recentlySearched,
                    style: FontPalette.black14Medium,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        searchKeyOnTileTap(
                            provider.recentlySearchedList[index] ?? '');
                      },
                      child: RecentlySearchedListTile(
                        name: provider.recentlySearchedList[index],
                      ),
                    ).removeSplash();
                  },
                  itemCount: (provider.recentlySearchedList).notEmpty
                      ? provider.recentlySearchedList.length > 8
                          ? 8
                          : provider.recentlySearchedList.length
                      : 0,
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _searchBanners(SearchProvider provider) {
    return Column(children: [
      _recentlySearched(provider),
      CustomDivider(
        height: 5.h,
        thickness: 5.h,
      ),
      if (provider.trendingSearchList.notEmpty)
        TrendingListView(
          trendingSearchList: provider.trendingSearchList,
          searchProvider: searchProvider,
        ),
      if (provider.trendingSearchList.notEmpty)
        CustomDivider(
          height: 5.h,
          thickness: 5.h,
        ),
      if (provider.getRecentlyViewedProductsList.notEmpty)
        RecentlyViewedTile(
            getRecentlyViewedProductsList:
                provider.getRecentlyViewedProductsList ?? []),
      if (provider.getRecentlyViewedProductsList.notEmpty)
        CustomDivider(
          height: 5.h,
          thickness: 5.h,
        )
    ]);
  }

  Widget _productListingView(SearchProvider provider) {
    return Selector<SearchProvider, LoaderState>(
      selector: (context, provider) => provider.searchLoadState,
      builder: (context, value, child) {
        child = ListView.builder(
          padding: EdgeInsets.only(top: 9.h, left: 12.w, right: 12.w),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                provider
                    .updateSku(provider.searchProductItems[index].sku ?? '');
                provider.updateSearchProduct(
                    provider.searchProductItems[index].name?.trim() ?? '');
                provider.updateIsFromSearchProductListingScreen(false);
                Navigator.pushNamed(
                    context, RouteGenerator.routeProductDetailScreen,
                    arguments: ProductDetailsArguments(
                        sku: provider.searchProductItems[index].sku ?? '',
                        isFromSearch: true,
                        searchProvider: provider,
                        isFromInitialState: true));
              },
              child: RecentlySearchedListTile(
                  name: provider.searchProductItems[index].name ?? ''),
            ).removeSplash();
          },
          itemCount: provider.searchProductItems.isNotEmpty
              ? provider.searchProductItems.length
              : 0,
        );
        switch (value) {
          case LoaderState.loaded:
            return child;
          case LoaderState.loading:
            return Column(
              children: const [
                CommonLinearProgress(),
              ],
            );
          case LoaderState.noData:
            return const SingleChildScrollView(
              child: CustomSlidingFadeAnimation(
                fadeDuration: Duration(milliseconds: 300),
                slideDuration: Duration(milliseconds: 200),
                child:
                    CustomErrorScreen(errorType: CustomErrorType.searchNoData),
              ),
            );

          default:
            return child;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        floatingActionButton: const WhatsappChatWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: EmptyAppBar(
          backgroundColor: Colors.white,
          darkIcon: Platform.isIOS ? false : true,
        ),
        body: ChangeNotifierProvider.value(
          value: searchProvider,
          child: SafeArea(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    _searchBar(provider),
                    Expanded(
                        child: GestureDetector(
                            onVerticalDragCancel: () =>
                                FocusScope.of(context).unfocus(),
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: _initialView(provider)))
                  ],
                );
              },
            ),
          ),
        ));
  }

  void onValueChanged(String value) {
    final model = searchProvider;
    if (model.productItem == value.trim()) return;
    if (value.trim().isNotEmpty) {
      model.updateSearchProduct(value.trim());
      model.updateSearchLoader(LoaderState.loading);
      FirebaseAnalyticsService.instance.logSearchText(text: value.trim());
      if (_throttle?.isActive ?? false) _throttle?.cancel();
      _throttle = Timer(const Duration(milliseconds: 1000), () async {
        if (focusNode.hasFocus) model.updateSearchInput(value);
      });
    } else {
      model.updateSearchInput('');
    }
  }

  void searchKeyOnTileTap(String item) {
    searchProvider.updateSearchProduct(item.trim());
    searchProvider.searchController.text = item;
    searchProvider.searchProduct(item);
    searchProvider.getRecentlySearchedKeys();
    if (searchProvider.searchController.text.trim().isNotEmpty) {
      searchProvider.searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchProvider.searchController.text.length));
    }
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_throttle?.isActive ?? false) _throttle!.cancel();
    focusNode.dispose();
    searchProvider.dispose();
    super.dispose();
  }
}
