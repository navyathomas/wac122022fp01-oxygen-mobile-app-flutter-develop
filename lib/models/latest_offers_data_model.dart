class LatestOffersDataModel {
  List<LatestOffers>? latestOffers;

  LatestOffersDataModel({this.latestOffers});

  LatestOffersDataModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      latestOffers = <LatestOffers>[];
      json['content'].forEach((v) {
        latestOffers!.add(LatestOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latestOffers != null) {
      data['latest_offers'] = latestOffers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LatestOffers {
  String? blockTitle;
  String? blockType;
  List<LatestOffersContent>? content;
  int? blockId;
  String? title;
  String? linkText;
  String? link;
  int? productCount;
  List<LatestOffersProducts>? products;
  PromoData? promoData;

  LatestOffers(
      {this.blockTitle,
      this.blockType,
      this.content,
      this.blockId,
      this.title,
      this.linkText,
      this.link,
      this.productCount,
      this.products,
      this.promoData});

  LatestOffers.fromJson(Map<String, dynamic> json) {
    blockTitle = json['block_title'];
    blockType = json['block_type'];
    if (json['content'] != null) {
      content = <LatestOffersContent>[];
      json['content'].forEach((v) {
        content!.add(LatestOffersContent.fromJson(v));
      });
    }
    blockId = json['block_id'];
    title = json['title'];
    linkText = json['link_text'];
    link = json['link'];
    productCount = json['product_count'];
    if (json['products'] != null) {
      products = <LatestOffersProducts>[];
      json['products'].forEach((v) {
        products!.add(LatestOffersProducts.fromJson(v));
      });
    }
    promoData = json['promo_data'] != null
        ? PromoData.fromJson(json['promo_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['block_title'] = blockTitle;
    data['block_type'] = blockType;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['block_id'] = blockId;
    data['title'] = title;
    data['link_text'] = linkText;
    data['link'] = link;
    data['product_count'] = productCount;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (promoData != null) {}
    return data;
  }
}

class LatestOffersContent {
  String? title;
  String? blockType;
  String? imageUrl;
  String? fullwidth;
  String? height;
  String? backgroundColor;
  String? linkType;
  String? linkId;
  String? trackingName;
  String? trackingLocation;
  int? blockId;
  int? id;
  String? link;
  String? attribute;
  String? attributeType;
  String? filterType;
  LatestOffersContent(
      {this.title,
      this.blockType,
      this.imageUrl,
      this.fullwidth,
      this.height,
      this.backgroundColor,
      this.linkType,
      this.linkId,
      this.trackingName,
      this.trackingLocation,
      this.blockId,
      this.id,
      this.link,
      this.attribute,
      this.attributeType,
      this.filterType});

  LatestOffersContent.fromJson(Map<String, dynamic> json) {
    attribute = json['attribute'];
    filterType = json['filter_type'];
    attributeType = json['attribute_value'];
    title = json['title'];
    blockType = json['block_type'];
    imageUrl = json['image_url'];
    fullwidth = json['fullwidth'];
    height = json['height'];
    backgroundColor = json['background_color'];
    linkType = json['link_type'];
    linkId = json['link_id'];
    trackingName = json['tracking_name'];
    trackingLocation = json['tracking_location'];
    blockId = json['block_id'];
    id = json['id'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['block_type'] = blockType;
    data['image_url'] = imageUrl;
    data['fullwidth'] = fullwidth;
    data['height'] = height;
    data['background_color'] = backgroundColor;
    data['link_type'] = linkType;
    data['link_id'] = linkId;
    data['tracking_name'] = trackingName;
    data['tracking_location'] = trackingLocation;
    data['block_id'] = blockId;
    data['id'] = id;
    data['link'] = link;
    return data;
  }
}

class LatestOffersProducts {
  String? id;
  String? sku;
  String? productName;
  String? price;
  String? url;
  String? tag;
  Null? shortNote;
  String? newFrom;
  String? newTo;
  String? regularPrice;
  dynamic? discount;
  String? onlyFewProductsLeft;
  String? productTagLabel;
  ProductSticker? productSticker;
  String? image;
  Images? images;
  Images? imagesOther;

  LatestOffersProducts(
      {this.id,
      this.sku,
      this.productName,
      this.price,
      this.url,
      this.tag,
      this.shortNote,
      this.newFrom,
      this.newTo,
      this.regularPrice,
      this.discount,
      this.onlyFewProductsLeft,
      this.productTagLabel,
      this.productSticker,
      this.image,
      this.images,
      this.imagesOther});

  LatestOffersProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    productName = json['product_name'];
    price = json['price'];
    url = json['url'];
    tag = json['tag'];
    shortNote = json['short_note'];
    newFrom = json['new_from'];
    newTo = json['new_to'];
    regularPrice = json['regular_price'];
    discount = json['discount'];
    onlyFewProductsLeft = json['only_few_products_left'];
    productTagLabel = json['product_tag_label'];
    productSticker = json['product_sticker'] != null
        ? ProductSticker.fromJson(json['product_sticker'])
        : null;
    image = json['image'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    imagesOther = json['images_other'] != null
        ? Images.fromJson(json['images_other'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sku'] = sku;
    data['product_name'] = productName;
    data['price'] = price;
    data['url'] = url;
    data['tag'] = tag;
    data['short_note'] = shortNote;
    data['new_from'] = newFrom;
    data['new_to'] = newTo;
    data['regular_price'] = regularPrice;
    data['discount'] = discount;
    data['only_few_products_left'] = onlyFewProductsLeft;
    data['product_tag_label'] = productTagLabel;
    if (productSticker != null) {
      data['product_sticker'] = productSticker!.toJson();
    }
    data['image'] = image;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    if (imagesOther != null) {
      data['images_other'] = imagesOther!.toJson();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    data['position'] = position;
    return data;
  }
}

class Images {
  String? desktop;
  String? desktop2x;
  String? laptop;
  String? laptop2x;
  String? ipad;
  String? ipad2x;
  String? mobile;
  String? mobile2x;
  String? placeholder;

  Images(
      {this.desktop,
      this.desktop2x,
      this.laptop,
      this.laptop2x,
      this.ipad,
      this.ipad2x,
      this.mobile,
      this.mobile2x,
      this.placeholder});

  Images.fromJson(Map<String, dynamic> json) {
    desktop = json['desktop'];
    desktop2x = json['desktop_2x'];
    laptop = json['laptop'];
    laptop2x = json['laptop_2x'];
    ipad = json['ipad'];
    ipad2x = json['ipad_2x'];
    mobile = json['mobile'];
    mobile2x = json['mobile_2x'];
    placeholder = json['placeholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['desktop'] = desktop;
    data['desktop_2x'] = desktop2x;
    data['laptop'] = laptop;
    data['laptop_2x'] = laptop2x;
    data['ipad'] = ipad;
    data['ipad_2x'] = ipad2x;
    data['mobile'] = mobile;
    data['mobile_2x'] = mobile2x;
    data['placeholder'] = placeholder;
    return data;
  }
}

class PromoData {
  String? promoImagePostion;
  List<dynamic>? promoImages;
  List<dynamic>? promoImagesOther;
  String? promoLink;

  PromoData(
      {this.promoImagePostion,
      this.promoImages,
      this.promoImagesOther,
      this.promoLink});

  PromoData.fromJson(Map<String, dynamic> json) {
    promoImagePostion = json['promo_image_postion'];
    if (json['promo_images'] != null) {
      promoImages = <dynamic>[];
      json['promo_images'].forEach((v) {
        promoImages!.add(v);
      });
    }
    if (json['promo_images_other'] != null) {
      promoImagesOther = <dynamic>[];
      json['promo_images_other'].forEach((v) {
        promoImagesOther!.add(v);
      });
    }
    promoLink = json['promo_link'];
  }
}
