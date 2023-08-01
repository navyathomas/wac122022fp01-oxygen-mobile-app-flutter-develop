import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/providers/search_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_compare_bottom_widget.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_grid_card_widget.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_row_card_widget.dart';
import 'package:oxygen/views/product_listing/widgets/search_product_listing_top_bar.dart';
import 'package:oxygen/views/shimmers/product_listing_grid_view_shimmer.dart';
import 'package:oxygen/views/shimmers/product_listing_list_view_shimmer.dart';
import 'package:oxygen/widgets/sliver_pagination_loader.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../models/compare_products_model.dart';
import '../../models/product_detail_model.dart';
import '../../providers/search_product_listing_provider.dart';
import '../../repositories/compare_repo.dart';
import '../../services/helpers.dart';
import '../../services/hive_services.dart';
import '../../widgets/common_appbar.dart';
import '../error_screens/api_error_screens.dart';

class SearchProductListingScreen extends StatefulWidget {
  const SearchProductListingScreen(
      {Key? key, this.isFromSearch, this.title, this.searchProvider})
      : super(key: key);
  final bool? isFromSearch;
  final String? title;
  final SearchProvider? searchProvider;

  @override
  State<SearchProductListingScreen> createState() =>
      _SearchProductListingScreenState();
}

class _SearchProductListingScreenState
    extends State<SearchProductListingScreen> {
  bool isListingView = true;
  late ScrollController controller;
  late SearchProductListingProvider searchProductListingProvider;

  @override
  void initState() {
    searchProductListingProvider = SearchProductListingProvider();
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    searchProductListingProvider.dispose();
    super.dispose();
  }

  initFunction() {
    controller = ScrollController()
      ..addListener(() {
        if (controller.offset >= (controller.position.maxScrollExtent)) {
          searchProductListingProvider.loadMoreSearchProductDetails(
            widget.searchProvider?.productItem ?? '',
          );
        }
      });
    CommonFunctions.afterInit(() {
      searchProductListingProvider.clearPageLoader();
      searchProductListingProvider
          .getAggregationsList(widget.searchProvider?.productItem ?? '')
          .then((value) => searchProductListingProvider.getSearchProductDetails(
                  widget.searchProvider?.productItem ?? '', onSuccess: () {
                if (widget.isFromSearch ?? false) {
                  if (searchProductListingProvider.productItems.notEmpty) {
                    widget.searchProvider?.addRecentlySearchedKeys(
                        widget.searchProvider?.productItem ?? '',
                        widget.searchProvider?.sku ?? '');
                  }
                }
              }));
      searchProductListingProvider.updateIsCompareTapped(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        onActionButtonSearchOnPressed: () {
          widget.searchProvider?.updateIsFromSearchProductListingScreen(true);
          context.rootPop;
        },
        titleWidget: GestureDetector(
          onTap: () {
            widget.searchProvider?.updateIsFromSearchProductListingScreen(true);
            context.rootPop;
          },
          child: Text(
            widget.title ?? '',
            style:
                FontPalette.black18Medium.copyWith(color: HexColor('#282C3F')),
          ),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: searchProductListingProvider,
        child: SafeArea(
          child: Consumer<SearchProductListingProvider>(
            builder: (context, value, child) {
              return _switchView(value.loaderState, value.isListView);
            },
          ),
        ),
      ),
    );
  }

  _switchView(LoaderState loaderState, bool isListingView) {
    Widget child = const SizedBox.shrink().convertToSliver();
    switch (loaderState) {
      case LoaderState.loaded:
        child = Stack(children: [
          CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SearchProductListingTopBar(
                searchProductListingProvider: searchProductListingProvider,
                scrollController: controller,
                searchProvider: widget.searchProvider,
              ),
              isListingView
                  ? searchProductListingListView(searchProductListingProvider)
                  : searchProductListingGridView(searchProductListingProvider),
              if (searchProductListingProvider.paginationLoader)
                SliverPaginationLoader(
                    async: searchProductListingProvider.paginationLoader)
            ],
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box<CompareProducts>(
                    HiveServices.instance.compareProductBoxName)
                .listenable(),
            builder: (context, box, child) {
              return ((searchProductListingProvider.isCompareTapped &&
                          box.values.isNotEmpty)
                      ? const ProductListingCompareBottomWidget()
                      : const SizedBox.shrink())
                  .animatedSwitch();
            },
          )
        ]);
        break;
      case LoaderState.loading:
        child = CustomScrollView(
          controller: controller,
          slivers: [
            SearchProductListingTopBar(
              searchProductListingProvider: searchProductListingProvider,
              scrollController: controller,
              searchProvider: widget.searchProvider,
            ),
            isListingView
                ? const ProductListingListViewShimmer().convertToSliver()
                : const ProductListingGridViewShimmer().convertToSliver()
          ],
        );
        break;
      case LoaderState.error:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              SearchProductListingTopBar(
                searchProductListingProvider: searchProductListingProvider,
                scrollController: controller,
                searchProvider: widget.searchProvider,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.error,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver(),
            ],
          );
        });
        break;
      case LoaderState.networkErr:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              SearchProductListingTopBar(
                searchProductListingProvider: searchProductListingProvider,
                scrollController: controller,
                searchProvider: widget.searchProvider,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.networkErr,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver(),
            ],
          );
        });
        break;
      case LoaderState.noData:
        break;
      case LoaderState.noProducts:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              SearchProductListingTopBar(
                searchProductListingProvider: searchProductListingProvider,
                scrollController: controller,
                searchProvider: widget.searchProvider,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.noProducts,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver(),
            ],
          );
        });
        break;
    }

    return child;
  }

  searchProductListingListView(
      SearchProductListingProvider searchProductListingProvider) {
    return SliverPadding(
      padding: EdgeInsets.only(
          bottom: searchProductListingProvider.isCompareTapped ? 168.h : 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: (searchProductListingProvider.productItems).isNotEmpty
                ? searchProductListingProvider.productItems.length
                : 0, (context, index) {
          Item item = searchProductListingProvider.productItems[index];
          return GestureDetector(
            onTap: () {
              NavRoutes.instance
                  .navToProductDetailScreen(context, sku: item.sku, item: item);
            },
            child: ProductListingRowCardWidget(
              productId: item.id.toString(),
              isShowAddToCompare: searchProductListingProvider.isCompareTapped,
              isAddedToCompare: item.isAddedToCompare ?? false,
              onAddToCompareTap: () async => addToCompareFunction(item),
              index: index,
              length: searchProductListingProvider.productItems.length,
              image: item.smallImage?.url ?? '',
              sku: item.sku ?? '',
              offerImage: item.productSticker?.imageUrl ?? '',
              productName: item.name ?? '',
              discountPrice:
                  item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                      ? item.priceRange?.maximumPrice?.finalPrice?.value ?? 0
                      : item.priceRange?.maximumPrice?.regularPrice?.value,
              actualPrice:
                  item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                      ? item.priceRange?.maximumPrice?.regularPrice?.value
                      : 0,
              status: item.qtyLeftInStock,
              discount: item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                  ? (item.priceRange?.maximumPrice?.discount?.percentOff
                          ?.round())
                      .toString()
                  : '',
              attributes: item.highlight?.split(','),
              isNew: item.isNew,
              notInStock: item.stockStatus == 'IN_STOCK' ? false : true,
              isFromProductListing: false,
            ),
          );
        }),
      ),
    );
  }

  searchProductListingGridView(
      SearchProductListingProvider searchProductListingProvider) {
    return SliverPadding(
      padding: searchProductListingProvider.isCompareTapped
          ? EdgeInsets.only(bottom: 168.h)
          : EdgeInsets.zero,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // mainAxisSpacing: 1.0,
          //crossAxisSpacing: 1.0.w,
          crossAxisCount: 2,
          mainAxisExtent:
              searchProductListingProvider.isCompareTapped ? 325.h : 300.h,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            Item item = searchProductListingProvider.productItems[index];
            return GestureDetector(
              onTap: () {
                NavRoutes.instance.navToProductDetailScreen(context,
                    sku: item.sku, item: item);
              },
              child: ProductListingGridCardWidget(
                showTopMargin: index < 2,
                productId: item.id.toString(),
                isShowAddToCompare:
                    searchProductListingProvider.isCompareTapped,
                isAddedToCompare: item.isAddedToCompare ?? false,
                onAddToCompareTap: () async => addToCompareFunction(item),
                productName: item.name ?? '',
                category: item.highlight ?? '',
                sku: item.sku ?? '',
                discountPrice:
                    item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                        ? item.priceRange?.maximumPrice?.finalPrice?.value ?? 0
                        : item.priceRange?.maximumPrice?.regularPrice?.value,
                actualPrice:
                    item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                        ? item.priceRange?.maximumPrice?.regularPrice?.value
                        : 0,
                image: item.smallImage?.url ?? '',
                offerImage: item.productSticker?.imageUrl ?? '',
                discount:
                    item.priceRange!.maximumPrice!.discount!.percentOff! > 0
                        ? (item.priceRange?.maximumPrice?.discount?.percentOff
                                ?.round())
                            .toString()
                        : '',
                isNew: item.isNew,
                status: item.qtyLeftInStock ?? '',
                notInStock: item.stockStatus == 'IN_STOCK' ? false : true,
                isEven:
                    (searchProductListingProvider.productItems.length) % 2 == 0,
                isFromProductListing: false,
              ),
            );
          },
          childCount: (searchProductListingProvider.productItems).isNotEmpty
              ? searchProductListingProvider.productItems.length
              : 0,
        ),
      ),
    );
  }

  addToCompareFunction(Item item) async {
    List<CompareProducts> localCompareValues =
        await HiveServices.instance.getComparedProductsLocalValues();
    if (localCompareValues.length > 2) {
      CommonFunctions.afterInit(() => Helpers.flushToast(context,
          msg: 'Please remove one product to compare'));
      return;
    }
    if (localCompareValues.notEmpty) {
      if (localCompareValues[0].productTypeSet != item.productTypeSet) {
        await CompareRepo.removeAllProductsFromCompare(
            onSuccess: () async => await CompareRepo.addProductToCompare(item,
                onFailure: () =>
                    Helpers.flushToast(context, msg: CompareRepo.errorMessage)),
            onFailure: () =>
                Helpers.flushToast(context, msg: CompareRepo.errorMessage));
      } else {
        await CompareRepo.addProductToCompare(item,
            onFailure: () =>
                Helpers.flushToast(context, msg: CompareRepo.errorMessage));
      }
    } else {
      await CompareRepo.addProductToCompare(item,
          onFailure: () =>
              Helpers.flushToast(context, msg: CompareRepo.errorMessage));
    }
  }

  onRetryTap() {
    CommonFunctions.afterInit(() {
      context
          .read<SearchProductListingProvider>()
          .getAggregationsList(widget.searchProvider?.productItem ?? '')
          .then((value) => context
                  .read<SearchProductListingProvider>()
                  .getSearchProductDetails(
                      widget.searchProvider?.productItem ?? '', onSuccess: () {
                if (widget.isFromSearch ?? false) {
                  widget.searchProvider?.addRecentlySearchedKeys(
                      widget.searchProvider?.productItem ?? '',
                      widget.searchProvider?.sku ?? '');
                }
              }));
    });
  }
}
