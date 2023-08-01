import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/services/helpers.dart';

class ProductListingResponse {
  ProductData? data;

  ProductListingResponse({this.data});

  ProductListingResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProductData.fromJson(json['data']) : null;
  }
}

class ProductData {
  Products? products;

  ProductData({this.products});

  ProductData.fromJson(Map<String, dynamic> json) {
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
  }
}

class Products {
  List<Item>? items;
  PageInfo? pageInfo;
  int? totalCount;

  Products({this.items, this.pageInfo, this.totalCount});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
    pageInfo =
        json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
    totalCount = json['total_count'];
  }
}

//
// class ProductItems {
//   int? id;
//   String? sku;
//   String? typeName;
//   String? ratingAggregationValue;
//   String? productReviewCount;
//   String? name;
//   String? stockStatus;
//   String? highLight;
//   SmallImage? smallImage;
//   ProductSticker? productSticker;
//   String? urlKey;
//   PriceRange? priceRange;
//   String? qtyLeftInStock;
//   bool? isNew;
//   bool? isAddedToCompare;
//   ProductItems({
//     this.id,
//     this.sku,
//     this.name,
//     this.stockStatus,
//     this.highLight,
//     this.smallImage,
//     this.productSticker,
//     this.urlKey,
//     this.priceRange,
//     this.qtyLeftInStock,
//     this.productReviewCount,
//     this.ratingAggregationValue,
//     this.typeName,
//     this.isNew,
//     this.isAddedToCompare = false,
//   });
//
//   ProductItems.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     sku = json['sku'];
//     name = json['name'];
//     stockStatus = json['stock_status'];
//     highLight = json['highlight'];
//     smallImage = json['small_image'] != null
//         ? SmallImage.fromJson(json['small_image'])
//         : null;
//     productSticker = json['product_sticker'] != null
//         ? ProductSticker.fromJson(json['product_sticker'])
//         : null;
//     urlKey = json['url_key'];
//     priceRange = json['price_range'] != null
//         ? PriceRange.fromJson(json['price_range'])
//         : null;
//     qtyLeftInStock = json['qty_left_in_stock'];
//     typeName = json['__typename'];
//     ratingAggregationValue = json['rating_aggregation_value'];
//     productReviewCount = json['product_review_count'];
//     isNew = Helpers.validateNewDates(
//         fromDate: json["new_from_date"], toDate: json["new_to_date"]);
//   }
// }

class SmallImage {
  String? url;

  SmallImage({this.url});

  SmallImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}

class Jpg {
  String? mobile;

  Jpg({this.mobile});

  Jpg.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
  }
}

class PriceRange {
  PriceDetails? maximumPrice;

  PriceRange({this.maximumPrice});

  PriceRange.fromJson(Map<String, dynamic> json) {
    maximumPrice = json['maximum_price'] != null
        ? PriceDetails.fromJson(json['maximum_price'])
        : null;
  }
}

class PriceDetails {
  Discount? discount;
  FinalPrice? finalPrice;
  FinalPrice? regularPrice;

  PriceDetails({this.discount, this.finalPrice, this.regularPrice});

  PriceDetails.fromJson(Map<String, dynamic> json) {
    discount =
        json['discount'] != null ? Discount.fromJson(json['discount']) : null;
    finalPrice = json['final_price'] != null
        ? FinalPrice.fromJson(json['final_price'])
        : null;
    regularPrice = json['regular_price'] != null
        ? FinalPrice.fromJson(json['regular_price'])
        : null;
  }
}

class Discount {
  double? amountOff;
  int? percentOff;

  Discount({this.amountOff, this.percentOff});

  Discount.fromJson(Map<String, dynamic> json) {
    amountOff = Helpers.convertToDouble(json['amount_off']);
    percentOff = Helpers.convertToDouble(json['percent_off']).round();
  }
}

class FinalPrice {
  String? currency;
  int? value;

  FinalPrice({this.currency, this.value});

  FinalPrice.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertToInt(json['value']);
  }
}

class PageInfo {
  int? totalPages;

  PageInfo({this.totalPages});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
  }
}

class ProductSticker {
  String? imageUrl;
  String? position;

  ProductSticker({this.imageUrl, this.position});

  ProductSticker.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    position = json['position'];
  }
}
