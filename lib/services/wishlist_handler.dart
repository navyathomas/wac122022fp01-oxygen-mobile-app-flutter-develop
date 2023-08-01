import 'package:flutter/material.dart';

class WishListHandler {
  static void addToWishList(
      {required String sku,
      required String name,
      required BuildContext context,
      String? cartItemId,
      bool fromCart = false}) async {
    int? itemId;
    // context.circularLoaderPopUp;
    /*bool model = await context.read<WishListProvider>().addToWishList(
        sku: sku,
        itemId: (val) {
          if (val != null) {
            itemId = int.tryParse(val.toString());
          }
        });
    if (model && itemId != null) {
      */ /* context
          .read<AppDataProvider>()
          .addToWishListLocal(sku, itemId: itemId!)
          .then((value) async {
        if (fromCart) {
          await context.read<WishListProvider>().getWishListData();
          context.rootPop();
          removeFromCart(
              sku: sku,
              context: context,
              cartItemId: cartItemId,
              fromCart: fromCart);
        } else {
          context.rootPop();
        }
      });*/ /*
    } else {
       context.rootPop;
    }*/
  }
}
