import 'dart:convert';

class CategoryDetailedModel {
  List<CategoryData>? categoryData;

  CategoryDetailedModel({this.categoryData});

  CategoryDetailedModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      categoryData = <CategoryData>[];
      jsonDecode(json['content']).forEach((element) {
        if (element is Map<String, dynamic>) {
          categoryData?.add(CategoryData.fromJson(element));
        }
      });
    }
  }
}

class CategoryData {
  CategoryData(
      {this.title,
      this.blockType,
      this.content,
      this.products,
      this.backgroundImage,
      this.titleColor,
      this.link});

  String? title;
  String? blockType;
  List<DetailContent?>? content;
  List<Product?>? products;
  String? backgroundImage;
  String? titleColor;
  String? link;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
      title: json["title"],
      blockType: json["block_type"],
      content: json["content"] == null
          ? null
          : List<DetailContent?>.from(json["content"]
              .map((x) => x == null ? null : DetailContent.fromJson(x))),
      products: json["products"] == null
          ? null
          : List<Product?>.from(json["products"]
              .map((x) => x == null ? null : Product.fromJson(x))),
      backgroundImage: json["background_image"],
      titleColor: (json["titlecolor"] == null || json["titlecolor"].isEmpty)
          ? null
          : json["titlecolor"],
      link: json['link']);
}

class DetailContent {
  DetailContent(
      {this.imageText,
      this.image,
      this.linkType,
      this.linkId,
      this.categoryPage,
      this.imageUrl,
      this.label,
      this.filterPrice,
      this.attribute,
      this.attributeType,
      this.filterType});

  String? imageText;
  String? image;
  String? linkType;
  String? linkId;
  String? categoryPage;
  String? imageUrl;
  String? label;
  FilterPrice? filterPrice;
  String? attribute;
  String? attributeType;
  String? filterType;

  factory DetailContent.fromJson(Map<String, dynamic> json) => DetailContent(
        attribute: json['attribute'],
        filterType: json['filter_type'],
        attributeType: json['attribute_value'],
        imageText: json["image_text"],
        image: json["image"],
        linkType: json["link_type"],
        linkId: json["link_id"],
        categoryPage: json["category_page"],
        imageUrl: json["image_url"],
        label: json["label"],
        filterPrice: json["filter_price"] == null
            ? null
            : FilterPrice.fromJson(json["filter_price"]),
      );
}

class Product {
  Product({
    this.sku,
    this.productName,
    this.price,
    this.shortNote,
    this.regularPrice,
    this.discount,
    this.onlyFewProductsLeft,
    this.image,
    this.productSticker,
  });

  String? sku;
  String? productName;
  String? price;
  String? shortNote;
  String? regularPrice;
  String? discount;
  String? onlyFewProductsLeft;
  String? image;
  ProductSticker? productSticker;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      sku: json["sku"],
      productName: json["product_name"],
      price: json["price"],
      shortNote: json["short_note"],
      regularPrice: json["regular_price"],
      discount: json["discount"]?.toString(),
      onlyFewProductsLeft: json["only_few_products_left"],
      image: json["image"],
      productSticker: json['product_sticker'] == null
          ? null
          : ProductSticker.fromJson(json['product_sticker']));
}

class ProductSticker {
  ProductSticker({
    this.imageUrl,
    this.position,
  });

  String? imageUrl;
  String? position;

  factory ProductSticker.fromJson(Map<String, dynamic> json) => ProductSticker(
        imageUrl: json["image_url"],
        position: json["position"],
      );
}

class FilterPrice {
  FilterPrice({
    this.from,
    this.to,
  });

  String? from;
  String? to;

  factory FilterPrice.fromJson(Map<String, dynamic> json) => FilterPrice(
        from: json["from"],
        to: json["to"],
      );
}
