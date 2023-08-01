import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/wish_list_data_model.dart';
import 'package:oxygen/providers/wishlist_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/error_screens/custom_error_screens.dart';
import 'package:oxygen/views/main_screen/my_items/widgets/my_items_product_card_widget.dart';
import 'package:oxygen/views/shimmers/product_listing_grid_view_shimmer.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:provider/provider.dart';

import '../../../repositories/app_data_repo.dart';
import '../../../services/app_config.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';

class MyItemsScreen extends StatefulWidget {
  final Function(int) onTabSwitch;
  final bool? enableBackBtn;

  const MyItemsScreen({Key? key, required this.onTabSwitch, this.enableBackBtn})
      : super(key: key);

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  late final ScrollController scrollController;
  double cardHeight = 320.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        actionList: const [],
        titleWidget: Selector<WishListProvider, int?>(
          selector: (context, provider) =>
              provider.wishListDataModel?.wishlist?.itemsCount,
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Items",
                  style: FontPalette.f282C3F_18Bold,
                ),
                AnimatedCrossFade(
                  firstChild: Text(
                    " ($value Items)",
                    style: FontPalette.f282C3F_18Bold,
                  ),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState: ((value ?? 0) > 0)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                ),
                35.horizontalSpace
              ],
            );
          },
        ),
        enableNavBack: widget.enableBackBtn ?? false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<WishListProvider>()
                .getWishListProducts(enableLoader: false);
          },
          child: _SwitchView(
            cardHeight: cardHeight,
            onRemove: (item) => onRemove(item),
            onMoveToCart: (item) => onMoveToCart(item),
            onMainTabSwitch: widget.onTabSwitch,
            onTryAgain: () => fetchData(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    scrollController = ScrollController();
    fetchData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    double tempHeight = cardHeight + (context.validateScale() * 20).h;
    if (tempHeight != cardHeight) {
      setState(() {
        cardHeight = tempHeight;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void fetchData() {
    CommonFunctions.afterInit(() {
      context.read<WishListProvider>()
        ..initData()
        ..getWishListProducts(onAuthError: (bool? val) {
          if (val ?? false) {
            HiveServices.instance.saveNavPath(RouteGenerator.routeMainScreen);
            Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
                    arguments: true)
                .then((value) {
              if (AppConfig.isAuthorized) {
                context.read<WishListProvider>().getWishListProducts();
              }
            });
          }
        });
      AppDataRepo.getWishListData(clearData: false);
    });
  }

  void onRemove(WishListItems? item) async {
    final model = context.read<WishListProvider>();
    if (model.btnLoaderState == true) return;
    bool res = await model.removeFromWishList(
        itemId: item?.itemId, sku: item?.product?.sku ?? '', refreshData: true);
    if (res) {
      if (mounted) {
        Helpers.flushImageToast(context,
            msg: Constants.removedFromWishList,
            image: item?.product?.smallImage?.url ?? '', onUndo: () {
          model.addToWishList(
              sku: item?.product?.sku ?? '',
              name: item?.product?.name,
              refreshData: true);
        });
      }
    }
  }

  void onMoveToCart(WishListItems? item) async {
    final model = context.read<WishListProvider>();
    if (model.btnLoaderState == true) return;
    bool res = await model.moveFromMyItem(
        sku: item?.product?.sku ?? '', itemId: item?.itemId);
    if (res) {
      if (mounted) {
        Helpers.flushImageToast(context,
            msg: Constants.movedFromWishListToCart,
            image: item?.product?.smallImage?.url ?? '', onUndo: () {
          model.restoreProduct(
              sku: item?.product?.sku ?? '',
              itemId: item?.itemId,
              name: item?.product?.name);
        });
      }
    }
  }
}

class _SwitchView extends StatelessWidget {
  final Function(WishListItems?) onRemove;
  final Function(WishListItems?) onMoveToCart;
  final Function(int) onMainTabSwitch;
  final VoidCallback? onTryAgain;
  final double cardHeight;

  const _SwitchView(
      {Key? key,
      required this.onRemove,
      required this.onMoveToCart,
      required this.cardHeight,
      required this.onMainTabSwitch,
      this.onTryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<WishListProvider, bool>(
            selector: (context, provider) => provider.btnLoaderState,
            builder: (context, state, _) {
              return WidgetExtension.crossSwitch(
                  first: const CommonLinearProgress(), value: state);
            }),
        Expanded(
          child: ValueListenableBuilder<Box<LocalProducts>>(
            valueListenable:
                Hive.box<LocalProducts>(HiveServices.instance.wishlistBoxName)
                    .listenable(),
            builder: (context, value, child) {
              if (value.isEmpty) {
                return CustomErrorScreen(
                  errorType: CustomErrorType.myItemsEmpty,
                  onButtonPressed: () {
                    onMainTabSwitch(0);
                  },
                );
              }
              return Selector<WishListProvider, LoaderState>(
                  selector: (context, provider) => provider.loaderState,
                  builder: (context, value, child) {
                    switch (value) {
                      case LoaderState.loaded:
                        return _WishListView(
                          onRemove: onRemove,
                          onMoveToCart: onMoveToCart,
                          cardHeight: cardHeight,
                        );
                      case LoaderState.loading:
                        return const ProductListingGridViewShimmer();
                      case LoaderState.error:
                        return CustomSlidingFadeAnimation(
                          slideDuration: const Duration(milliseconds: 300),
                          child: ApiErrorScreens(
                            loaderState: LoaderState.error,
                            onTryAgain: onTryAgain,
                          ),
                        );
                      case LoaderState.networkErr:
                        return CustomSlidingFadeAnimation(
                          slideDuration: const Duration(milliseconds: 300),
                          child: ApiErrorScreens(
                            loaderState: LoaderState.networkErr,
                            onTryAgain: onTryAgain,
                          ),
                        );
                      case LoaderState.noData:
                        return CustomErrorScreen(
                          errorType: CustomErrorType.myItemsEmpty,
                          onButtonPressed: () {
                            onMainTabSwitch(0);
                          },
                        );
                      case LoaderState.noProducts:
                        return const SizedBox.shrink();
                        break;
                    }
                  });
            },
          ),
        ),
      ],
    );
  }
}

class _WishListView extends StatelessWidget {
  final double cardHeight;
  final Function(WishListItems?) onMoveToCart;
  final Function(WishListItems?) onRemove;

  const _WishListView(
      {Key? key,
      required this.cardHeight,
      required this.onMoveToCart,
      required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<WishListProvider, List<WishListItems>?>(
      selector: (context, provider) => provider.wishListItems,
      builder: (context, value, child) {
        return CustomSlidingFadeAnimation(
          slideDuration: const Duration(milliseconds: 300),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: cardHeight),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    WishListItems? item = value?[index];
                    return MyItemsProductCardWidget(
                      onTap: () => Navigator.pushNamed(
                          context, RouteGenerator.routeProductDetailScreen,
                          arguments: ProductDetailsArguments(
                              sku: item?.product?.sku ?? '',
                              isFromInitialState: true)),
                      productName: item?.product?.name,
                      category: item?.product?.highlight,
                      discountPrice: item?.product?.priceRange?.maximumPrice
                              ?.finalPrice?.value ??
                          0,
                      actualPrice: item?.product?.priceRange?.maximumPrice
                              ?.regularPrice?.value ??
                          0,
                      image: item?.product?.smallImage?.url ?? '',
                      offerImage: item?.product?.productSticker?.imageUrl ?? '',
                      discount: item?.product?.priceRange?.maximumPrice
                              ?.discount?.percentOff ??
                          0,
                      isNew: item?.product?.isNew ?? false,
                      isOutOfStock: item?.product?.stockStatus?.toLowerCase() !=
                          'in_stock',
                      showTopMargin: index < 2,
                      isEven: index % 2 == 0,
                      onClear: () => onRemove(item),
                      onMoveToCart: () => onMoveToCart(item),
                    );
                  },
                  childCount: value?.length ?? 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
