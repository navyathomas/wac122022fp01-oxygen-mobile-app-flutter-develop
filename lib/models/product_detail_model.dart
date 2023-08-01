import 'package:oxygen/services/helpers.dart';

import 'cart_data_model.dart';

class ProductDetailModel {
  ProductDetailModel({
    this.data,
  });

  ProductDetailData? data;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        data: json["data"] != null
            ? ProductDetailData.fromJson(json["data"])
            : null,
      );
}

class ProductDetailData {
  ProductDetailData({
    this.products,
  });

  Products? products;

  factory ProductDetailData.fromJson(Map<String, dynamic> json) =>
      ProductDetailData(
        products: json["products"] != null
            ? Products.fromJson(json["products"])
            : null,
      );
}

class Products {
  Products({
    this.items,
  });

  List<Item?>? items;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        items: (json["items"] == null || json["items"].isEmpty)
            ? null
            : List<Item?>.from(
                json["items"].map((x) => x != null ? Item.fromJson(x) : null)),
      );
}

class Variant {
  Variant({
    this.attributes,
    this.product,
  });

  List<Attribute?>? attributes;
  Item? product;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        attributes: json["attributes"] != null
            ? List<Attribute?>.from(json["attributes"]
                .map((x) => x != null ? Attribute.fromJson(x) : null))
            : null,
        product:
            json["product"] != null ? Item.fromJson(json["product"]) : null,
      );
}

class Item {
  Item(
      {this.id,
      this.sku,
      this.name,
      this.productType,
      this.mediaGallery,
      this.buyAndGetBanner,
      this.bajajBannerImage,
      this.productSticker,
      this.priceRange,
      this.crossSellProducts,
      this.upSellProducts,
      this.relatedProducts,
      this.description,
      this.emiData,
      this.bajajEmi,
      this.bajajCode,
      this.stockStatus,
      this.qtyLeftInStock,
      this.ratingAggregationValue,
      this.productReviewCount,
      this.productVideo,
      this.highlight,
      this.productCustomAttributes,
      this.urlKey,
      this.configurableOptions,
      this.variants,
      this.reviews,
      this.selectedVariantOptions,
      this.options,
      this.isNew = false,
      this.isAddedToCompare = false,
      this.smallImage,
      this.productTypeSet,
      this.rewardPoints,
      this.rewardPointsText});

  int? id;
  String? sku;
  String? name;
  String? productType;
  int? productTypeSet;
  List<MediaGallery?>? mediaGallery;
  BuyAndGetBanner? buyAndGetBanner;
  BajajBannerImage? bajajBannerImage;
  ProductSticker? productSticker;
  PriceRange? priceRange;
  List<Item?>? crossSellProducts;
  List<Item?>? upSellProducts;
  List<Item?>? relatedProducts;
  Description? description;
  String? emiData;
  String? bajajEmi;
  String? bajajCode;
  String? stockStatus;
  String? qtyLeftInStock;
  double? ratingAggregationValue;
  String? productReviewCount;
  List<ProductVideo?>? productVideo;
  String? highlight;
  String? productCustomAttributes;
  String? urlKey;
  List<ConfigurableOption?>? configurableOptions;
  List<Variant?>? variants;
  Reviews? reviews;
  List<SelectedVariantOption?>? selectedVariantOptions;
  List<Option?>? options;
  bool isNew;
  bool? isAddedToCompare;
  SmallImage? smallImage;
  int? rewardPoints;
  String? rewardPointsText;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        productType: json["__typename"],
        mediaGallery: json["media_gallery"] != null
            ? List<MediaGallery?>.from(json["media_gallery"]
                .map((x) => x != null ? MediaGallery.fromJson(x) : null))
            : null,
        buyAndGetBanner: json["buy_and_get_banner"] != null
            ? BuyAndGetBanner.fromJson(json["buy_and_get_banner"])
            : null,
        bajajBannerImage: json["bajaj_banner_image"] != null
            ? BajajBannerImage.fromJson(json["bajaj_banner_image"])
            : null,
        productSticker: json["product_sticker"] != null
            ? ProductSticker.fromJson(json["product_sticker"])
            : null,
        priceRange: json["price_range"] != null
            ? PriceRange.fromJson(json["price_range"])
            : null,
        crossSellProducts: json["crosssell_products"] == null
            ? null
            : List<Item?>.from(json["crosssell_products"]
                .map((x) => x != null ? Item.fromJson(x) : null)),
        upSellProducts: json["upsell_products"] == null
            ? null
            : List<Item?>.from(json["upsell_products"]
                .map((x) => x != null ? Item.fromJson(x) : null)),
        relatedProducts: json["related_products"] == null
            ? null
            : List<Item?>.from(json["related_products"]
                .map((x) => x != null ? Item.fromJson(x) : null)),
        description: json["description"] != null
            ? Description.fromJson(json["description"])
            : null,
        emiData: json["emi_data"],
        bajajEmi: json["bajaj_emi"],
        bajajCode: json["bajaj_code"],
        stockStatus: json["stock_status"],
        qtyLeftInStock: json["qty_left_in_stock"],
        ratingAggregationValue: json["rating_aggregation_value"]?.toDouble(),
        productReviewCount: json["product_review_count"],
        productVideo: json["product_video"] != null
            ? List<ProductVideo?>.from(json["product_video"]
                .map((x) => x != null ? ProductVideo.fromJson(x) : null))
            : null,
        highlight: json["highlight"],
        productCustomAttributes: json["product_custom_attributes"],
        urlKey: json["url_key"],
        configurableOptions: json["configurable_options"] == null
            ? null
            : List<ConfigurableOption?>.from(json["configurable_options"]
                .map((x) => x != null ? ConfigurableOption.fromJson(x) : null)),
        variants: json["variants"] == null
            ? null
            : List<Variant?>.from(json["variants"]
                .map((x) => x != null ? Variant.fromJson(x) : null)),
        reviews:
            json["reviews"] != null ? Reviews.fromJson(json["reviews"]) : null,
        selectedVariantOptions: json["selected_variant_options"] == null
            ? null
            : List<SelectedVariantOption?>.from(json["selected_variant_options"]
                .map((x) =>
                    x != null ? SelectedVariantOption.fromJson(x) : null)),
        options: json["options"] == null
            ? null
            : List<Option?>.from(json["options"]
                .map((x) => x != null ? Option.fromJson(x) : null)),
        isNew: Helpers.validateNewDates(
          fromDate: json["new_from_date"],
          toDate: json["new_to_date"],
        ),
        smallImage: json['small_image'] != null
            ? SmallImage.fromJson(json['small_image'])
            : null,
        productTypeSet: json['product_type_set'],
        rewardPoints: Helpers.convertToInt(json['reward_points']),
        rewardPointsText: json['reward_points_text'],
      );
}

class Attribute {
  Attribute({
    this.code,
    this.valueIndex,
  });

  String? code;
  int? valueIndex;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        code: json["code"],
        valueIndex: json["value_index"],
      );
}

class ConfigurableOption {
  ConfigurableOption({
    this.attributeCode,
    this.attributeId,
    this.id,
    this.label,
    this.values,
  });

  String? attributeCode;
  String? attributeId;
  int? id;
  String? label;
  List<Value?>? values;

  factory ConfigurableOption.fromJson(Map<String, dynamic> json) =>
      ConfigurableOption(
        attributeCode: json["attribute_code"],
        attributeId: json["attribute_id"],
        id: json["id"],
        label: json["label"],
        values: json["values"] != null
            ? List<Value?>.from(
                json["values"].map((x) => x != null ? Value.fromJson(x) : null))
            : null,
      );
}

class Value {
  Value({
    this.label,
    this.useDefaultValue,
    this.valueIndex,
    this.swatchData,
    this.nonExistentAttributes,
  });

  String? label;
  bool? useDefaultValue;
  int? valueIndex;
  SwatchData? swatchData;
  List<int?>? nonExistentAttributes;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        useDefaultValue: json["use_default_value"],
        valueIndex: json["value_index"],
        swatchData: json["swatch_data"] != null
            ? SwatchData.fromJson(json["swatch_data"])
            : null,
        nonExistentAttributes: json["non_existent_attributes"] == null
            ? null
            : List<int?>.from(json["non_existent_attributes"].map((x) => x)),
      );
}

class SwatchData {
  SwatchData({
    this.value,
    this.thumbnail,
  });

  String? value;
  String? thumbnail;

  factory SwatchData.fromJson(Map<String, dynamic> json) => SwatchData(
        value: json["value"],
        thumbnail: json["thumbnail"],
      );
}

class MediaGallery {
  MediaGallery({
    this.url,
  });

  String? url;

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
        url: json["url"],
      );
}

class PriceRange {
  PriceRange({
    this.maximumPrice,
  });

  MaximumPrice? maximumPrice;

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        maximumPrice: json["maximum_price"] != null
            ? MaximumPrice.fromJson(json["maximum_price"])
            : null,
      );
}

class MaximumPrice {
  MaximumPrice({
    this.discount,
    this.finalPrice,
    this.regularPrice,
  });

  Discount? discount;
  Price? finalPrice;
  Price? regularPrice;

  factory MaximumPrice.fromJson(Map<String, dynamic> json) => MaximumPrice(
        discount: json["discount"] != null
            ? Discount.fromJson(json["discount"])
            : null,
        finalPrice: json["final_price"] != null
            ? Price.fromJson(json["final_price"])
            : null,
        regularPrice: json["regular_price"] != null
            ? Price.fromJson(json["regular_price"])
            : null,
      );
}

class Discount {
  Discount({
    this.amountOff,
    this.percentOff,
  });

  double? amountOff;
  double? percentOff;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        amountOff: json["amount_off"]?.toDouble(),
        percentOff: json["percent_off"]?.toDouble(),
      );
}

class Price {
  Price({
    this.currency,
    this.value,
  });

  String? currency;
  int? value;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        currency: json["currency"],
        value: Helpers.convertToInt(json["value"]),
      );
}

class ProductSticker {
  ProductSticker({
    this.imageUrl,
  });

  String? imageUrl;

  factory ProductSticker.fromJson(Map<String, dynamic> json) => ProductSticker(
        imageUrl: json["image_url"],
      );
}

class ProductVideo {
  ProductVideo({
    this.videoUrl,
    this.videoTitle,
  });

  String? videoUrl;
  String? videoTitle;

  factory ProductVideo.fromJson(Map<String, dynamic> json) => ProductVideo(
        videoUrl: json["video_url"],
        videoTitle: json["video_title"],
      );
}

class CrossSellProduct {
  CrossSellProduct({
    this.id,
    this.sku,
    this.name,
    this.stockStatus,
    this.image,
    this.priceRange,
  });

  int? id;
  String? sku;
  String? name;
  String? stockStatus;
  ProductImage? image;
  PriceRange? priceRange;

  factory CrossSellProduct.fromJson(Map<String, dynamic> json) =>
      CrossSellProduct(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        stockStatus: json["stock_status"],
        image:
            json["image"] != null ? ProductImage.fromJson(json["image"]) : null,
        priceRange: json["price_range"] != null
            ? PriceRange.fromJson(json["price_range"])
            : null,
      );
}

class UpSellProduct {
  UpSellProduct({
    this.id,
    this.sku,
    this.name,
    this.highlight,
    this.qtyLeftInStock,
    this.image,
    this.priceRange,
    this.isNew = false,
  });

  int? id;
  String? sku;
  String? name;
  String? highlight;
  String? qtyLeftInStock;
  ProductImage? image;
  PriceRange? priceRange;
  bool isNew;

  factory UpSellProduct.fromJson(Map<String, dynamic> json) => UpSellProduct(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        highlight: json["highlight"],
        qtyLeftInStock: json["qty_left_in_stock"],
        image:
            json["image"] != null ? ProductImage.fromJson(json["image"]) : null,
        priceRange: json["price_range"] != null
            ? PriceRange.fromJson(json["price_range"])
            : null,
        isNew: Helpers.validateNewDates(
            fromDate: json["new_from_date"], toDate: json["new_to_date"]),
      );
}

class RelatedProduct {
  RelatedProduct({
    this.id,
    this.sku,
    this.name,
    this.highlight,
    this.qtyLeftInStock,
    this.image,
    this.priceRange,
    this.isNew = false,
  });

  int? id;
  String? sku;
  String? name;
  String? highlight;
  String? qtyLeftInStock;
  ProductImage? image;
  PriceRange? priceRange;
  bool isNew;

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        highlight: json["highlight"],
        qtyLeftInStock: json["qty_left_in_stock"],
        image:
            json["image"] != null ? ProductImage.fromJson(json["image"]) : null,
        priceRange: json["price_range"] != null
            ? PriceRange.fromJson(json["price_range"])
            : null,
        isNew: Helpers.validateNewDates(
            fromDate: json["new_from_date"], toDate: json["new_to_date"]),
      );
}

class ProductImage {
  ProductImage({
    this.jpgUrl,
  });

  String? jpgUrl;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        jpgUrl: json["jpg_url"],
      );
}

class Description {
  Description({
    this.html,
  });

  String? html;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        html: json["html"],
      );
}

class ProductAttributes {
  final String? title;
  final Map<String, dynamic>? values;

  ProductAttributes({this.title, this.values});
}

class Reviews {
  Reviews({
    this.items,
  });

  List<ReviewsItem?>? items;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        items: json["items"] != null
            ? List<ReviewsItem?>.from(json["items"]
                .map((x) => x != null ? ReviewsItem.fromJson(x) : null))
            : null,
      );
}

class ReviewsItem {
  ReviewsItem({
    this.ratingValue,
    this.summary,
    this.text,
    this.createdAt,
    this.name,
  });

  double? ratingValue;
  String? summary;
  String? text;
  String? createdAt;
  String? name;

  factory ReviewsItem.fromJson(Map<String, dynamic> json) => ReviewsItem(
        ratingValue: json["rating_value"]?.toDouble(),
        summary: json["summary"],
        text: json["text"],
        createdAt: json["created_at"],
        name: json["nickname"],
      );
}

class SelectedVariantOption {
  SelectedVariantOption({
    this.code,
    this.valueIndex,
    this.label,
  });

  String? code;
  int? valueIndex;
  String? label;

  factory SelectedVariantOption.fromJson(Map<String, dynamic> json) =>
      SelectedVariantOption(
        code: json["code"],
        valueIndex: json["value_index"],
        label: json["label"],
      );
}

class Option {
  Option({
    this.sortOrder,
    this.description,
    this.title,
    this.optionId,
    this.termsAndConditions,
    this.value,
  });

  int? sortOrder;
  String? description;
  String? title;
  int? optionId;
  TermsAndConditions? termsAndConditions;
  List<OptionValue?>? value;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        sortOrder: json["sort_order"],
        description: json["description"],
        title: json["title"],
        optionId: json["option_id"],
        termsAndConditions: json["terms_and_conditions"] != null
            ? TermsAndConditions.fromJson(json["terms_and_conditions"])
            : null,
        value: json["value"] == null
            ? null
            : List<OptionValue?>.from(json["value"]
                .map((x) => x != null ? OptionValue.fromJson(x) : null)),
      );
}

class TermsAndConditions {
  TermsAndConditions({
    this.identifier,
    this.linkLabel,
  });

  String? identifier;
  String? linkLabel;

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) =>
      TermsAndConditions(
        identifier: json["identifier"],
        linkLabel: json["link_label"],
      );
}

class OptionValue {
  OptionValue({
    this.optionTypeId,
    this.price,
    this.priceType,
    this.sku,
    this.title,
  });

  int? optionTypeId;
  double? price;
  String? priceType;
  String? sku;
  String? title;

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
        optionTypeId: json["option_type_id"],
        price: json["price"]?.toDouble(),
        priceType: json["price_type"],
        sku: json["sku"],
        title: json["title"],
      );
}

class BuyAndGetBanner {
  BuyAndGetBanner({this.url});
  String? url;

  factory BuyAndGetBanner.fromJson(Map<String, dynamic> json) =>
      BuyAndGetBanner(url: json["url"]);
}

class BajajBannerImage {
  BajajBannerImage({this.url});
  String? url;

  factory BajajBannerImage.fromJson(Map<String, dynamic> json) =>
      BajajBannerImage(url: json["url"]);
}
