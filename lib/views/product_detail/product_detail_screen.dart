import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_attributes_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_available_offers_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_bottom_sheet_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_buy_and_get_banner.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_delivery_to_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_earn_points_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_frequently_bought_together_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_key_features_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_protection_and_warranty_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_rating_and_review_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_recommended_products_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_select_variant.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_similar_products_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_top_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_video_and_highlights_widget.dart';
import 'package:oxygen/views/shimmers/product_detail_screen_shimmer.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/search_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? sku;
  final bool? isFromSearch;
  final bool isFromInitialState;
  final Item? item;
  final SearchProvider? searchProvider;

  const ProductDetailScreen(
      {Key? key,
      this.sku,
      this.isFromSearch = false,
      this.isFromInitialState = false,
      this.item,
      this.searchProvider})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailProvider? productDetailProvider;

  @override
  void initState() {
    super.initState();
    productDetailProvider = ProductDetailProvider();
    CommonFunctions.afterInit(() {
      productDetailProvider?.getProductDetails(context, widget.sku ?? "");
      productDetailProvider?.getBankOffers(context, widget.sku ?? "");
      productDetailProvider?.getEmiPlans(sku: widget.sku);
      productDetailProvider?.getBajajEmiDetails(sku: widget.sku);
      if (widget.isFromSearch ?? false) {
        widget.searchProvider?.addRecentlySearchedKeys(
            widget.searchProvider?.productItem ?? '',
            widget.searchProvider?.sku ?? '');
      }
    });
  }

  @override
  void dispose() {
    productDetailProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: productDetailProvider,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            floatingActionButton:
                const WhatsappChatWidget().bottomPadding(padding: 75),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            appBar: CommonAppBar(
              buildContext: context,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Selector<ProductDetailProvider, LoaderState>(
                  selector: (context, provider) => provider.loaderState,
                  builder: (context, value, child) {
                    switch (value) {
                      case LoaderState.loading:
                        return widget.isFromInitialState
                            ? const ProductDetailScreenShimmer()
                            : _ProductDetailListViewWithTopShimmer(
                                item: widget.item);
                      case LoaderState.loaded:
                        return widget.isFromInitialState
                            ? const _ProductDetailListView()
                            : _ProductDetailListViewWithTopShimmer(
                                item: widget.item);
                      case LoaderState.noData:
                        return const ApiErrorScreens(
                            loaderState: LoaderState.noData);
                      case LoaderState.error:
                        return const ApiErrorScreens(
                            loaderState: LoaderState.error);
                      case LoaderState.networkErr:
                        return const ApiErrorScreens(
                            loaderState: LoaderState.networkErr);
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
            )),
      ),
    );
  }
}

class _ProductDetailListView extends StatelessWidget {
  const _ProductDetailListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return CustomSlidingFadeAnimation(
        fadeDuration: const Duration(milliseconds: 400),
        fadeCurve: Curves.easeIn,
        slideDuration: Duration.zero,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: model.scrollController,
              physics: const BouncingScrollPhysics(),
              child: ColoredBox(
                color: HexColor("#F3F3F7"),
                child: Column(
                  children: [
                    const ProductDetailTopWidget(),
                    const ProductDetailSelectVariant(),
                    const ProductDetailDeliveryToWidget(),
                    const ProductDetailEarnPointsWidget(),
                    const ProductDetailAvailableOffersWidget(),
                    const ProductDetailFrequentlyBoughtTogetherWidget(),
                    const ProductDetailProtectionAndWarrantyWidget(),
                    const ProductDetailBuyAndGetBanner(),
                    const ProductDetailKeyFeaturesWidget(),
                    const ProductDetailAttributesWidget(),
                    const ProductDetailVideoAndHighlightsWidget(),
                    const ProductDetailRatingAndReviewWidget(),
                    const ProductDetailSimilarProductsWidget(),
                    const ProductDetailRecommendedProductsWidget(),
                    Container(
                      height: 73.h,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter,
                child: ProductDetailBottomSheetWidget())
          ],
        ));
  }
}

class _ProductDetailListViewWithTopShimmer extends StatelessWidget {
  final Item? item;

  const _ProductDetailListViewWithTopShimmer({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return CustomSlidingFadeAnimation(
        fadeDuration: const Duration(milliseconds: 400),
        fadeCurve: Curves.easeIn,
        slideDuration: Duration.zero,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: model.scrollController,
              physics: const BouncingScrollPhysics(),
              child: ColoredBox(
                color: HexColor("#F3F3F7"),
                child: Column(
                  children: [
                    ProductDetailTopWidget(item: item),
                    Selector<ProductDetailProvider, LoaderState>(
                        selector: (context, provider) => provider.loaderState,
                        builder: (context, value, child) {
                          switch (value) {
                            case LoaderState.loading:
                              return const ProductDetailScreenPartialShimmer();
                            case LoaderState.loaded:
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ProductDetailSelectVariant(),
                                  const ProductDetailDeliveryToWidget(),
                                  const ProductDetailEarnPointsWidget(),
                                  const ProductDetailAvailableOffersWidget(),
                                  const ProductDetailFrequentlyBoughtTogetherWidget(),
                                  const ProductDetailProtectionAndWarrantyWidget(),
                                  const ProductDetailBuyAndGetBanner(),
                                  const ProductDetailKeyFeaturesWidget(),
                                  const ProductDetailAttributesWidget(),
                                  const ProductDetailVideoAndHighlightsWidget(),
                                  const ProductDetailRatingAndReviewWidget(),
                                  const ProductDetailSimilarProductsWidget(),
                                  const ProductDetailRecommendedProductsWidget(),
                                  Container(
                                    height: 73.h,
                                    color: Colors.white,
                                  )
                                ],
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        }),
                  ],
                ),
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter,
                child: ProductDetailBottomSheetWidget())
          ],
        ));
  }
}
