import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:oxygen/widgets/custom_check_box.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProductDetailFrequentlyBoughtTogetherWidget extends StatelessWidget {
  const ProductDetailFrequentlyBoughtTogetherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Tuple2<List<Item?>?, List<String>>>(
        selector: (context, provider) =>
            Tuple2(provider.upSellProducts, provider.frequentlyList),
        shouldRebuild: (previous, next) {
          return previous.item2 == previous.item2;
        },
        builder: (context, value, child) {
          return (value.item1 == null || (value.item1?.isEmpty ?? true))
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 5.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.verticalSpace,
                      Text(
                        Constants.frequentlyBoughtTogether,
                        style: FontPalette.black16Medium,
                      ),
                      18.verticalSpace,
                      ValueListenableBuilder<Box<LocalProducts>>(
                          valueListenable: Hive.box<LocalProducts>(
                                  HiveServices.instance.cartBoxName)
                              .listenable(),
                          builder: (context, box, child) {
                            return Column(
                              children: List.generate(
                                value.item1?.length ?? 0,
                                (index) {
                                  final upSellProducts =
                                      value.item1?.elementAt(index);
                                  final stockStatus =
                                      upSellProducts?.stockStatus;
                                  return (stockStatus == "IN_STOCK")
                                      ? Column(
                                          children: [
                                            _OfferRow(
                                                box: box, item: upSellProducts),
                                            22.verticalSpace,
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            );
                          }),
                    ],
                  ),
                );
        });
  }
}

class _OfferRow extends StatefulWidget {
  final Item? item;
  final Box<LocalProducts> box;

  const _OfferRow({
    Key? key,
    this.item,
    required this.box,
  }) : super(key: key);

  @override
  State<_OfferRow> createState() => _OfferRowState();
}

class _OfferRowState extends State<_OfferRow> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = context.read<CartProvider>();
    final quantity = widget.box.get(widget.item?.sku)?.quantity;
    final showDiscount =
        (widget.item?.priceRange?.maximumPrice?.discount?.percentOff != null &&
            widget.item?.priceRange?.maximumPrice?.discount?.percentOff != 0.0);
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, value, child) {
              return value
                  ? SizedBox.square(
                      dimension: 18.r,
                      child: CircularProgressIndicator(strokeWidth: 2.r))
                  : InkWell(
                      onTap: () async {
                        if (quantity == null || quantity == 0) {
                          isLoading.value = true;
                          await cartModel.addToCart(context,
                              sku: widget.item?.sku ?? "",
                              name: widget.item?.name,
                              qty: 1);
                          isLoading.value = false;
                        } else {
                          isLoading.value = true;
                          await cartModel.removeFromCart(context,
                              sku: widget.item?.sku ?? "",
                              cartItemId: widget.box
                                      .get(widget.item?.sku ?? "")
                                      ?.cartItemId ??
                                  -1);
                          isLoading.value = false;
                        }
                      },
                      child: SizedBox(
                        height: 46.r,
                        child: Center(
                          child: CustomCheckBox(
                            isSelected: (quantity == null || quantity == 0)
                                ? false
                                : true,
                          ),
                        ),
                      ),
                    );
            }),
        12.horizontalSpace,
        SizedBox.square(
          dimension: 46.r,
          child: CommonFadeInImage(image: widget.item?.smallImage?.url),
        ),
        16.horizontalSpace,
        Expanded(
          child: InkWell(
            onTap: () {
              NavRoutes.instance.navToProductDetailScreen(context,
                  sku: widget.item?.sku, item: widget.item);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item?.name ?? "",
                  style: FontPalette.black14Regular,
                ),
                5.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.item?.priceRange?.maximumPrice?.finalPrice
                                    ?.value ==
                                null
                            ? ""
                            : "₹${widget.item?.priceRange?.maximumPrice?.finalPrice?.value?.toString()}",
                        style: FontPalette.black14Bold,
                      ),
                      WidgetSpan(child: 10.horizontalSpace),
                      if (showDiscount)
                        TextSpan(
                          text: widget.item?.priceRange?.maximumPrice
                                      ?.regularPrice?.value ==
                                  null
                              ? ""
                              : "₹${widget.item?.priceRange?.maximumPrice?.regularPrice?.value?.toString()}",
                          style: FontPalette.f7E818C_12RegularLineThrough,
                        ),
                      WidgetSpan(child: 10.horizontalSpace),
                      if (showDiscount)
                        TextSpan(
                          text: widget.item?.priceRange?.maximumPrice?.discount
                                      ?.percentOff ==
                                  null
                              ? ""
                              : "${widget.item?.priceRange?.maximumPrice?.discount?.percentOff?.round().toString()}% OFF",
                          style: FontPalette.fE50019_12Medium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
