import 'dart:convert';

class HomeDataModel {
  List<HomeData>? homeData;

  HomeDataModel({this.homeData});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      homeData = <HomeData>[];
      jsonDecode(json['content']).forEach((v) {
        if (v is Map<String, dynamic>) homeData!.add(HomeData.fromJson(v));
      });
    }
  }
}

class HomeData {
  String? blockTitle;
  String? blockType;
  List<Content>? content;
  String? title;
  String? linkText;
  String? link;
  String? linkType;
  String? categoryDetail;
  String? linkId;
  int? productCount;
  List<HomeProducts>? products;
  PromoData? promoData;
  int? blockId;
  String? imageUrl;
  Images? images;
  MainImageData? mainImageData;

  HomeData(
      {this.blockTitle,
      this.blockType,
      this.content,
      this.blockId,
      this.title,
      this.linkText,
      this.link,
      this.linkType,
      this.categoryDetail,
      this.linkId,
      this.productCount,
      this.products,
      this.promoData,
      this.imageUrl,
      this.images,
      this.mainImageData});

  HomeData.fromJson(Map<String, dynamic> json) {
    blockTitle = json['block_title'];
    blockType = json['block_type'];
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(Content.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <HomeProducts>[];
      json['products'].forEach((v) {
        products!.add(HomeProducts.fromJson(v));
      });
    }
    title = json['title'];
    linkText = json['link_text'];
    link = json['link'];
    linkType = json['link_type'];
    categoryDetail = json['mobile-category-page'];
    linkId = json['link_id'];
    productCount = json['product_count'];
    promoData = json['promo_data'] != null
        ? PromoData.fromJson(json['promo_data'])
        : null;
    blockId = json['block_id'];
    imageUrl = json['image_url'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    mainImageData = json['main_image_data'] != null
        ? MainImageData.fromJson(json['main_image_data'])
        : null;
  }
}

class MainImageData {
  String? imageType;
  String? imageUrl;
  String? name;
  String? offerText;
  String? linkType;
  String? linkId;
  String? link;

  MainImageData(
      {this.imageType,
      this.imageUrl,
      this.name,
      this.offerText,
      this.linkType,
      this.linkId,
      this.link});

  MainImageData.fromJson(Map<String, dynamic> json) {
    imageType = json['image_type'];
    imageUrl = json['image_url'];
    name = json['name'];
    offerText = json['offer_text'];
    linkType = json['link_type'];
    linkId = json['link_id'];
    link = json['link'];
  }
}

class Content {
  Content(
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
      this.linkText,
      this.link,
      this.contentData,
      this.images,
      this.image,
      this.imageText,
      this.categoryPage,
      this.attribute,
      this.attributeType,
      this.filterType});

  Content.fromJson(dynamic json) {
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
    linkText = json['link_text'];
    link = json['link'];
    if (json['content'] != null) {
      contentData = <ContentData>[];
      json['content'].forEach((v) {
        contentData!.add(ContentData.fromJson(v));
      });
    }
    images = json['images'];
    image = json['image'];
    imageText = json['image_text'];
    categoryPage = json['category_page'];
    attribute = json['attribute'];
    attributeType = json['attribute_value'];
    filterType = json['filter_type'];
  }

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
  String? linkText;
  String? link;
  List<ContentData>? contentData;
  String? images;
  String? image;
  String? imageText;
  String? categoryPage;
  String? attribute;
  String? attributeType;
  String? filterType;
}

class ContentData {
  String? imageOptionType;
  List<ContentInnerData>? content;
  int? id;

  ContentData({this.imageOptionType, this.content, this.id});

  ContentData.fromJson(Map<String, dynamic> json) {
    imageOptionType = json['image_option_type'];
    if (json['content'] != null) {
      content = <ContentInnerData>[];
      json['content'].forEach((v) {
        content!.add(ContentInnerData.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class ContentInnerData {
  int? id;
  String? name;
  String? linkType;
  String? targetType;
  String? targetLink;
  String? linkLabel;
  String? link;
  String? images;

  ContentInnerData(
      {this.id,
      this.name,
      this.linkType,
      this.targetType,
      this.targetLink,
      this.linkLabel,
      this.link,
      this.images});

  ContentInnerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    linkType = json['link_type'];
    targetType = json['target_type'];
    targetLink = json['target_link'];
    linkLabel = json['link_label'];
    link = json['link'];
    images = json['images'];
  }
}

class HomeProducts {
  String? id;
  String? sku;
  String? productName;
  String? price;
  String? url;
  String? tag;
  String? newFrom;
  String? newTo;
  String? regularPrice;
  String? discount;
  String? onlyFewProductsLeft;
  String? productTagLabel;
  HomeProductSticker? productSticker;
  String? image;
  Images? images;
  Images? imagesOther;
  String? shortNote;

  HomeProducts(
      {this.id,
      this.sku,
      this.productName,
      this.price,
      this.url,
      this.tag,
      this.newFrom,
      this.newTo,
      this.regularPrice,
      this.discount,
      this.onlyFewProductsLeft,
      this.productTagLabel,
      this.productSticker,
      this.image,
      this.images,
      this.imagesOther,
      this.shortNote});

  HomeProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    productName = json['product_name'];
    price = json['price'] != null ? json['price'].toString() : '';
    url = json['url'];
    //tag = json['tag'];
    newFrom = json['new_from'];
    newTo = json['new_to'];
    regularPrice =
        json['regular_price'] != null ? json['regular_price'].toString() : '';
    discount = json['discount'] != null ? json['discount'].toString() : '';
    onlyFewProductsLeft = json['only_few_products_left'];
    productTagLabel = json['product_tag_label'];
    productSticker = json['product_sticker'] != null
        ? HomeProductSticker.fromJson(json['product_sticker'])
        : null;
    image = json['image'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    imagesOther = json['images_other'] != null
        ? Images.fromJson(json['images_other'])
        : null;
    shortNote = json['short_note'];
  }
}

class HomeProductSticker {
  String? imageUrl;
  String? position;

  HomeProductSticker({this.imageUrl, this.position});

  HomeProductSticker.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    position = json['position'];
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
}

class PromoData {
  String? promoImagePostion;
  List<String>? promoImages;
  List<String>? promoImagesOther;
  String? promoLink;

  PromoData(
      {this.promoImagePostion,
      this.promoImages,
      this.promoImagesOther,
      this.promoLink});

  PromoData.fromJson(Map<String, dynamic> json) {
    promoImagePostion = json['promo_image_postion'];
    if (json['promo_images'] != null) {
      promoImages = <String>[];
      json['promo_images'].forEach((v) {
        promoImages!.add(v);
      });
    }
    if (json['promo_images_other'] != null) {
      promoImagesOther = <String>[];
      json['promo_images_other'].forEach((v) {
        promoImagesOther!.add(v);
      });
    }
    promoLink = json['promo_link'];
  }
}
