import 'package:oxygen/models/search_response_model.dart';

import '../services/helpers.dart';

class WishListDataModel {
  WishListDataModel({
    this.wishlist,
  });

  WishListDataModel.fromJson(dynamic json) {
    wishlist = Wishlist.fromJson(json['wishlist']);
  }

  Wishlist? wishlist;
}

class Wishlist {
  Wishlist({this.items, this.itemsCount});

  Wishlist.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(WishListItems.fromJson(v));
      });
      itemsCount = json['items_count'];
    }
  }

  int? itemsCount;
  List<WishListItems>? items;
}

class WishListItems {
  WishListItems({this.product, this.itemId});

  WishListItems.fromJson(dynamic json) {
    product = json['product'] != null
        ? WishListProduct.fromJson(json['product'])
        : null;
    itemId = json['id'];
  }

  WishListProduct? product;
  int? itemId;
}

class WishListProduct {
  WishListProduct(
      {this.sku,
      this.name,
      this.highlight,
      this.smallImage,
      this.stockStatus,
      this.productSticker,
      this.priceRange,
      this.isNew});

  WishListProduct.fromJson(dynamic json) {
    sku = json['sku'];
    name = json['name'];
    highlight = json['highlight'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
    stockStatus = json['stock_status'];
    productSticker = json['product_sticker'] != null
        ? ProductSticker.fromJson(json['product_sticker'])
        : null;
    priceRange = json['price_range'] != null
        ? PriceRange.fromJson(json['price_range'])
        : null;
    isNew = Helpers.validateNewDates(
        fromDate: json["new_from_date"], toDate: json["new_to_date"]);
  }

  String? sku;
  String? name;
  String? highlight;
  SmallImage? smallImage;
  String? stockStatus;
  ProductSticker? productSticker;
  PriceRange? priceRange;
  bool? isNew;
}
