import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/models/emi_plans_model.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/repositories/compare_repo.dart';
import 'package:oxygen/services/firebase_dynamic_link_services.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_compare_bottom_widget.dart';
import 'package:oxygen/views/product_detail/widgets/product_detail_image_slider.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:oxygen/widgets/favourite_btn.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailTopWidget extends StatelessWidget {
  final Item? item;

  const ProductDetailTopWidget({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          Item? product;
          if (value == null) {
            product = item;
          } else {
            product = value;
          }
          final discount =
              product?.priceRange?.maximumPrice?.discount?.percentOff;
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: constraints.maxWidth * .8027,
                    child: Stack(
                      children: [
                        (product?.stockStatus != "IN_STOCK")
                            ? Opacity(
                                opacity: .50,
                                child: Center(
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: ProductDetailImageSlider(
                                        mediaGallery: product?.mediaGallery),
                                  ),
                                ))
                            : Center(
                                child: SizedBox(
                                  height: double.maxFinite,
                                  child: ProductDetailImageSlider(
                                      mediaGallery: product?.mediaGallery),
                                ),
                              ),
                        if (product?.stockStatus != "IN_STOCK")
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.20),
                                        blurRadius: 10)
                                  ]),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9.w, vertical: 6.h),
                              child: Text(
                                Constants.currentlyOutOfStock,
                                style: FontPalette.fE50019_13Medium,
                              ),
                            ),
                          ),
                        Positioned(
                          top: 20.49.h,
                          right: 5.w,
                          child: Column(
                            children: [
                              ValueListenableBuilder<Box<LocalProducts>>(
                                  valueListenable: Hive.box<LocalProducts>(
                                          HiveServices.instance.wishlistBoxName)
                                      .listenable(),
                                  builder: (context, box, child) {
                                    return FavoriteIconWidget(
                                        isWishListed: (box
                                                .get(product?.sku ?? '')
                                                ?.isFavourite ??
                                            false),
                                        sku: product?.sku ?? "",
                                        box: box,
                                        size: 21.r,
                                        name: item?.name,
                                        navPath: RouteGenerator
                                            .routeProductDetailScreen);
                                  }),
                              13.verticalSpace,
                              _ShareButton(product: product),
                            ],
                          ),
                        ),
                        if (product?.productSticker?.imageUrl != null &&
                            (product?.productSticker?.imageUrl?.isNotEmpty ??
                                false))
                          Positioned(
                            bottom: 12.h,
                            left: 12.w,
                            child: SizedBox(
                              height: 75.72.r,
                              width: 75.72.r,
                              child: CommonFadeInImage(
                                image: product?.productSticker?.imageUrl,
                                placeHolderImage: Assets.imagesBlankImage,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product?.isNew ?? false)
                          Container(
                            color: HexColor("#1CAF65"),
                            margin: EdgeInsets.only(top: 3.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                              horizontal: 4.w,
                            ),
                            child: Text(
                              Constants.newText,
                              style: FontPalette.white13Medium,
                            ),
                          ),
                        3.verticalSpace,
                        Text(
                          product?.name ?? "",
                          textAlign: TextAlign.start,
                          style: FontPalette.black18Regular,
                        ),
                        8.verticalSpace,
                        RichText(
                          text: TextSpan(
                            children: [
                              if (product?.priceRange?.maximumPrice?.finalPrice
                                      ?.value !=
                                  null)
                                TextSpan(
                                  text: product?.priceRange?.maximumPrice
                                      ?.finalPrice?.value?.toRupee,
                                  style: FontPalette.black24Bold,
                                ),
                              WidgetSpan(child: 12.horizontalSpace),
                              if (discount != null &&
                                  discount.toString() != "0.0")
                                TextSpan(
                                  text: product?.priceRange?.maximumPrice
                                      ?.regularPrice?.value?.toRupee,
                                  style:
                                      FontPalette.f7E818C_18RegularLineThrough,
                                ),
                              WidgetSpan(child: 12.horizontalSpace),
                              if (discount != null &&
                                  discount.toString() != "0.0")
                                TextSpan(
                                  text:
                                      "${product?.priceRange?.maximumPrice?.discount?.percentOff?.round() ?? ""}% OFF",
                                  style: FontPalette.fE50019_18Medium,
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            children: [
                              if (product?.productReviewCount != null &&
                                  (product?.productReviewCount?.isNotEmpty ??
                                      false))
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      NavRoutes.instance
                                          .navToProductDetailRatingsAndReviewsScreen(
                                              context,
                                              sku: product?.sku);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 4.h),
                                      margin: EdgeInsets.only(right: 12.w),
                                      color: HexColor("#f1f1f1"),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox.square(
                                            dimension: 12.r,
                                            child: SvgPicture.asset(
                                                Assets.iconsStar),
                                          ),
                                          4.horizontalSpace,
                                          Text(
                                                  product?.ratingAggregationValue
                                                          ?.toString() ??
                                                      "0.0",
                                                  style:
                                                      FontPalette.black12Medium)
                                              .translateWidgetVertically(
                                                  value: 1.2),
                                          7.horizontalSpace,
                                          Text("|",
                                              style: FontPalette
                                                  .f757575_12Regular),
                                          7.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                                    product?.productReviewCount ??
                                                        "0",
                                                    style: FontPalette
                                                        .f757575_12Regular)
                                                .translateWidgetVertically(
                                                    value: 1.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (product?.qtyLeftInStock != null &&
                                  (product?.qtyLeftInStock?.isNotEmpty ??
                                      false))
                                Text(
                                  product?.qtyLeftInStock ?? "",
                                  textAlign: TextAlign.start,
                                  style: FontPalette.f039614_14Medium,
                                ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder<Box<CompareProducts>>(
                          valueListenable: Hive.box<CompareProducts>(
                                  HiveServices.instance.compareProductBoxName)
                              .listenable(),
                          builder: (context, box, child) {
                            return box.containsKey(product?.id.toString() ?? '')
                                ? const _GoToCompare()
                                : const _AddToCompareButton();
                          },
                        ),
                        Selector<ProductDetailProvider, BajajEmiDetails?>(
                            selector: (context, provider) =>
                                provider.bajajEmiDetails,
                            builder: (context, bajajEmiDetails, child) {
                              return SizedBox(
                                width: double.maxFinite,
                                child: AnimatedCrossFade(
                                  firstChild: Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: double.maxFinite,
                                          height: context.sw() * .1707,
                                          child: CommonCachedNetworkImage(
                                            image:
                                                product?.bajajBannerImage?.url,
                                            fit: BoxFit.cover,
                                            placeHolderWidget:
                                                Container(color: Colors.white)
                                                    .addShimmer(),
                                            imageErrorWidget:
                                                Container(color: Colors.white)
                                                    .addShimmer(),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              highlightColor:
                                                  Colors.white.withOpacity(.25),
                                              splashColor:
                                                  Colors.white.withOpacity(.30),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    RouteGenerator
                                                        .routeBajajEmiDetailsScreen,
                                                    arguments:
                                                        ProductDetailsArguments(
                                                            bajajEmiDetails:
                                                                bajajEmiDetails));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: const SizedBox.shrink(),
                                  alignment: Alignment.center,
                                  firstCurve: Curves.easeIn,
                                  crossFadeState:
                                      (bajajEmiDetails?.items?.isEmpty ?? true)
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 300),
                                ),
                              );
                            }),
                        SizedBox(
                          width: double.maxFinite,
                          child: Selector<ProductDetailProvider, EmiPlansData?>(
                              selector: (context, provider) =>
                                  provider.emiPlans,
                              builder: (context, emiPlans, child) {
                                return AnimatedCrossFade(
                                  firstChild: Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.maxFinite,
                                          height: context.sw() * 0.24,
                                          child: SvgPicture.asset(
                                              Assets.iconsOtherEmiPlans,
                                              fit: BoxFit.cover),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              highlightColor:
                                                  Colors.white.withOpacity(.25),
                                              splashColor:
                                                  Colors.white.withOpacity(.30),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    RouteGenerator
                                                        .routeProductEmiPlansScreen,
                                                    arguments:
                                                        ProductDetailsArguments(
                                                            item: product,
                                                            emiPlans: emiPlans,
                                                            onRefresh:
                                                                () async {
                                                              context
                                                                  .read<
                                                                      ProductDetailProvider>()
                                                                  .getEmiPlans(
                                                                      sku: product
                                                                          ?.sku);
                                                            }));
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: const SizedBox.shrink(),
                                  alignment: Alignment.center,
                                  firstCurve: Curves.easeIn,
                                  crossFadeState:
                                      (emiPlans?.getBankEmiByProductSku ==
                                                  null ||
                                              (emiPlans?.getBankEmiByProductSku
                                                      ?.isEmpty ??
                                                  true))
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 200),
                                );
                              }),
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class _AddToCompareButton extends StatefulWidget {
  const _AddToCompareButton({Key? key}) : super(key: key);

  @override
  State<_AddToCompareButton> createState() => _AddToCompareButtonState();
}

class _AddToCompareButtonState extends State<_AddToCompareButton> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return GestureDetector(
      onTap: () async {
        if (model.selectedItem == null) {
          return;
        }
        isLoading.value = true;
        await addToCompareFunction(context, model.selectedItem);
        isLoading.value = false;
      },
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, value, child) {
                return Container(
                  height: 30.h,
                  width: 135.w,
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorPalette.primaryColor.withOpacity(.50),
                    ),
                  ),
                  child: value
                      ? ThreeBounce(
                          color: ColorPalette.primaryColor, size: 27.h)
                      : Center(
                          child: FittedBox(
                            child: Text(
                              Constants.addToCompare,
                              textAlign: TextAlign.start,
                              style: FontPalette.fE50019_15Medium,
                            ),
                          ),
                        ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> addToCompareFunction(BuildContext context, Item? item) async {
    List<CompareProducts> localCompareValues =
        await HiveServices.instance.getComparedProductsLocalValues();
    if (localCompareValues.length > 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) {
          return ProductDetailCompareBottomWidget(item: item);
        },
      );
      return;
    }
    if (localCompareValues.notEmpty) {
      if (localCompareValues[0].productTypeSet != item?.productTypeSet) {
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
}

class _GoToCompare extends StatelessWidget {
  const _GoToCompare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteGenerator.routeCompareScreen);
      },
      child: Row(
        children: [
          Container(
            height: 30.h,
            width: 135.w,
            padding: EdgeInsets.symmetric(horizontal: 9.w),
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor,
              border: Border.all(
                color: ColorPalette.primaryColor,
              ),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  Constants.goToCompare,
                  textAlign: TextAlign.start,
                  style: FontPalette.white15Medium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatefulWidget {
  const _ShareButton({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Item? product;

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loadingValue, child) {
          return Material(
            color: Colors.white.withOpacity(.80),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                isLoading.value = true;
                final shortDynamicLink = await FirebaseDynamicLinkServices
                    .instance
                    .createDynamicLink(
                  context: context,
                  image: widget.product?.mediaGallery?.first?.url ?? "",
                  name: widget.product?.name,
                  sku: widget.product?.sku,
                  url: widget.product?.urlKey,
                );
                isLoading.value = false;
                Share.share(shortDynamicLink);
              },
              child: loadingValue
                  ? Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox.square(
                          dimension: 21.r,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CircularProgressIndicator(
                                value: 1,
                                strokeWidth: 3.r,
                                color: HexColor("#696969").withOpacity(.25),
                              ),
                              CircularProgressIndicator(
                                strokeWidth: 3.r,
                              ),
                            ],
                          )),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox.square(
                        dimension: 21.r,
                        child: SvgPicture.asset(Assets.iconsShare),
                      ),
                    ),
            ),
          );
        });
  }
}
