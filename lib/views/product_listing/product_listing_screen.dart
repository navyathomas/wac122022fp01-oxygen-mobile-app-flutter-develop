import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/search_provider.dart';
import 'package:oxygen/repositories/compare_repo.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_compare_bottom_widget.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_grid_card_widget.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_row_card_widget.dart';
import 'package:oxygen/views/product_listing/widgets/product_listing_top_tab.dart';
import 'package:oxygen/views/shimmers/product_listing_grid_view_shimmer.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../models/category_detailed_model.dart';
import '../../providers/product_listing_provider.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/custom_sliding_fade_animation.dart';
import '../../widgets/sliver_pagination_loader.dart';
import '../shimmers/product_listing_list_view_shimmer.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen(
      {Key? key,
      this.isFromSearch,
      this.categoryId,
      this.title,
      this.filterPrice,
      this.searchProvider,
      this.attributeType,
      this.attribute,
      this.filterType})
      : super(key: key);
  final bool? isFromSearch;
  final String? categoryId;
  final String? title;
  final FilterPrice? filterPrice;
  final SearchProvider? searchProvider;
  final String? attribute;
  final String? attributeType;
  final String? filterType;
  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late ProductListingProvider productListingProvider;
  late ScrollController controller;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    productListingProvider.dispose();
    super.dispose();
  }

  initFunction() {
    productListingProvider = ProductListingProvider();
    controller = ScrollController()
      ..addListener(() {
        if (controller.offset >= (controller.position.maxScrollExtent)) {
          productListingProvider.loadMoreProductDetails(
            widget.searchProvider?.productItem ?? '',
          );
        }
      });
    productListingProvider.clearPageLoader();
    CommonFunctions.afterInit(() async {
      if ((widget.categoryId ?? '').isNotEmpty) {
        await productListingProvider.assignValuesToTempFilterMap(
            'category_id', widget.categoryId ?? '',
            enableLoaderState: true);
      }

      productListingProvider.updateCategoryId(widget.categoryId ?? '');
      if (widget.filterPrice != null) {
        if ((widget.filterPrice!.from ?? '').isNotEmpty &&
            (widget.filterPrice!.to ?? '').isNotEmpty) {
          await productListingProvider.assignValuesToTempFilterMap('price',
              '${widget.filterPrice!.from.notEmpty ? widget.filterPrice?.from : '0'},${widget.filterPrice!.to.notEmpty ? widget.filterPrice?.to : '0'}',
              enableLoaderState: true);
        }
      }
      if ((widget.attribute ?? '').isNotEmpty) {
        await productListingProvider.filterFromFourColumnAttribute(
            widget.attribute, widget.attributeType, widget.filterType);
      }
      await productListingProvider.assignValuesToFilterMap();

      //.then((value) => productListingProvider?.assignValuesToFilterMap());
      productListingProvider
          .getAggregationsList(widget.categoryId ?? '')
          .then((value) => productListingProvider.getProductDetails(
                widget.categoryId ?? '',
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: widget.title ?? '',
      ),
      // backgroundColor: HexColor("#E6E6E6"),
      body: ChangeNotifierProvider.value(
        value: productListingProvider,
        child: SafeArea(
          child: Consumer<ProductListingProvider>(
              builder: (context, value, child) {
            return _switchView(value.loaderState, value.isListView);
          }),
        ),
      ),
    );
  }

  _switchView(LoaderState loaderState, bool isListingView) {
    Widget child = const SizedBox.shrink().convertToSliver();
    switch (loaderState) {
      case LoaderState.loading:
        child = CustomScrollView(
          controller: controller,
          slivers: [
            ProductListingTopTab(
              productListingProvider: productListingProvider,
              categoryId: widget.categoryId ?? '',
              scrollController: controller,
            ),
            isListingView
                ? const ProductListingListViewShimmer().convertToSliver()
                : const ProductListingGridViewShimmer().convertToSliver()
          ],
        );
        break;
      case LoaderState.loaded:
        child = CustomSlidingFadeAnimation(
          fadeDuration: const Duration(milliseconds: 400),
          fadeCurve: Curves.easeIn,
          slideDuration: Duration.zero,
          child: Stack(
            children: [
              CustomScrollView(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ProductListingTopTab(
                    productListingProvider: productListingProvider,
                    categoryId: widget.categoryId ?? '',
                    scrollController: controller,
                  ),
                  if (productListingProvider.productRemoveLoader)
                    const CommonLinearProgress().convertToSliver(),
                  isListingView
                      ? productListingListView()
                      : productListingGridView(),
                  10.verticalSpace.convertToSliver(),
                  if (productListingProvider.paginationLoader)
                    SliverPaginationLoader(
                        async: productListingProvider.paginationLoader),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box<CompareProducts>(
                        HiveServices.instance.compareProductBoxName)
                    .listenable(),
                builder: (context, box, child) {
                  return ((productListingProvider.isCompareTapped &&
                              box.values.isNotEmpty)
                          ? const ProductListingCompareBottomWidget()
                          : const SizedBox.shrink())
                      .animatedSwitch();
                },
              )
            ],
          ),
        );

        break;

      case LoaderState.error:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              ProductListingTopTab(
                productListingProvider: productListingProvider,
                categoryId: widget.categoryId ?? '',
                scrollController: controller,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.error,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver()
            ],
          );
        });
        break;
      case LoaderState.networkErr:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              ProductListingTopTab(
                productListingProvider: productListingProvider,
                categoryId: widget.categoryId ?? '',
                scrollController: controller,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.networkErr,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver()
            ],
          );
        });
        break;
      case LoaderState.noData:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              ProductListingTopTab(
                productListingProvider: productListingProvider,
                categoryId: widget.categoryId ?? '',
                scrollController: controller,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child: ApiErrorScreens(
                  loaderState: LoaderState.noData,
                  onTryAgain: () => onRetryTap(),
                ),
              ).convertToSliver()
            ],
          );
        });
        break;
      case LoaderState.noProducts:
        child = LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            controller: controller,
            slivers: [
              ProductListingTopTab(
                productListingProvider: productListingProvider,
                categoryId: widget.categoryId ?? '',
                scrollController: controller,
              ),
              SizedBox(
                height: constraints.maxHeight - 40.h,
                child:
                    const ApiErrorScreens(loaderState: LoaderState.noProducts),
              ).convertToSliver()
            ],
          );
        });
        break;
    }
    return child;
  }

  productListingListView() {
    return SliverPadding(
      padding: EdgeInsets.only(
          bottom: productListingProvider.isCompareTapped ? 168.h : 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: (productListingProvider.productItems).isNotEmpty
                ? productListingProvider.productItems.length
                : 0, (context, index) {
          Item item = productListingProvider.productItems[index];
          return GestureDetector(
            onTap: () {
              NavRoutes.instance
                  .navToProductDetailScreen(context, sku: item.sku, item: item);
            },
            child: ProductListingRowCardWidget(
              productId: item.id.toString(),
              productListingProvider: productListingProvider,
              isLoading: productListingProvider.btnLoaderState,
              isShowAddToCompare: productListingProvider.isCompareTapped,
              isAddedToCompare: item.isAddedToCompare ?? false,
              onAddToCompareTap: () async {
                addToCompareFunction(item);
              },
              index: index,
              length: productListingProvider.productItems.length,
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
            ),
          );
        }),
      ),
    );
  }

  productListingGridView() {
    return SliverPadding(
      padding: productListingProvider.isCompareTapped
          ? EdgeInsets.only(bottom: 168.h)
          : EdgeInsets.zero,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent:
              (productListingProvider.isCompareTapped ? 320.h : 300.h) +
                  (context.validateScale(defaultVal: 0.0) * 40).h,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            Item item = productListingProvider.productItems[index];
            return GestureDetector(
              onTap: () {
                NavRoutes.instance.navToProductDetailScreen(context,
                    sku: item.sku, item: item);
              },
              child: ProductListingGridCardWidget(
                showTopMargin: index < 2,
                productId: item.id.toString(),
                productListingProvider: productListingProvider,
                isLoading: productListingProvider.btnLoaderState,
                isShowAddToCompare: productListingProvider.isCompareTapped,
                isAddedToCompare: item.isAddedToCompare ?? false,
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
                isEven: index % 2 == 0,
                onAddToCompareTap: () async {
                  addToCompareFunction(item);
                },
              ),
            );
          },
          childCount: (productListingProvider.productItems).isNotEmpty
              ? productListingProvider.productItems.length
              : 0,
        ),
      ),
    );
  }

  onRetryTap() {
    CommonFunctions.afterInit(() async {
      await productListingProvider.assignValuesToTempFilterMap(
          'category_id', widget.categoryId ?? '',
          enableLoaderState: true);
      await productListingProvider.assignValuesToFilterMap();
      //.then((value) => productListingProvider?.assignValuesToFilterMap());
      productListingProvider
          .getAggregationsList(widget.categoryId ?? '')
          .then((value) => productListingProvider.getProductDetails(
                widget.categoryId ?? '',
              ));
    });
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

  clearTempValueList() {
    if (productListingProvider.tempValueList.notEmpty) {
      for (int i = 0; i < productListingProvider.tempValueList.length; i++) {
        if (productListingProvider.valueList
            .contains(productListingProvider.tempValueList[i])) {
          productListingProvider.valueList
              .remove(productListingProvider.tempValueList[i]);
        }
      }
    }
  }
}
