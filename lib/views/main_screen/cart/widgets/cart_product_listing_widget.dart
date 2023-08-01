import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/cart_data_model.dart';
import 'package:oxygen/utils/color_palette.dart';

import 'cart_product_card_widget.dart';

class CartProductListingWidget extends StatelessWidget {
  final CartDataModel? cartDataModel;
  final Function(CartItems?) onDecrementTap;
  final Function(CartItems?) onIncrementTap;
  final Function(CartItems?) onRemoveItem;

  const CartProductListingWidget(
      {Key? key,
      this.cartDataModel,
      required this.onDecrementTap,
      required this.onIncrementTap,
      required this.onRemoveItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: cartDataModel?.cartItems?.length ?? 0,
        (cxt, index) {
          CartItems? item = cartDataModel?.cartItems?[index];
          return Column(
            children: [
              CartProductCardWidget(
                  image: item?.variationData?.thumbnail ??
                      item?.cartProduct?.smallImage?.url,
                  cartItemId: item?.cartItemId,
                  sku: item?.variationData?.sku ?? item?.cartProduct?.sku,
                  productName: item?.cartProduct?.name,
                  discountPrice: item?.cartProduct?.priceRange?.maximumPrice
                      ?.finalPrice?.value,
                  actualPrice: item?.cartProduct?.priceRange?.maximumPrice
                      ?.regularPrice?.value,
                  discount: item?.cartProduct?.priceRange?.maximumPrice
                      ?.discount?.percentOff,
                  itemCount: item?.quantity ?? 1,
                  isOutOfStock: item?.cartProduct?.stockStatus?.toLowerCase() !=
                      "in_stock",
                  onDecrementTap: () => onDecrementTap(item),
                  onIncrementTap: () => onIncrementTap(item),
                  onRemoveProduct: () => onRemoveItem(item),
                  addonOptions: item?.addonOptions,
                  childCustomizableOptions: item?.simpleAddonOptions ??
                      item?.configurableAddonOptions),
              Divider(
                height: 1.h,
                thickness: 1.h,
                color: HexColor("#F3F3F7"),
              ),
            ],
          );
        },
      ),
    );
  }
}
