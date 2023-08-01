class ReviewsModel {
  ReviewsModel({
    this.data,
  });

  ReviewsData? data;

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
        data: json["data"] != null ? ReviewsData.fromJson(json["data"]) : null,
      );
}

class ReviewsData {
  ReviewsData({
    this.products,
  });

  Products? products;

  factory ReviewsData.fromJson(Map<String, dynamic> json) => ReviewsData(
        products: json["products"] != null
            ? Products.fromJson(json["products"])
            : null,
      );
}

class Products {
  Products({
    this.items,
  });

  List<ProductsItem?>? items;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        items: json["items"] == null
            ? null
            : List<ProductsItem?>.from(json["items"]
                .map((x) => x != null ? ProductsItem.fromJson(x) : null)),
      );
}

class ProductsItem {
  ProductsItem({
    this.id,
    this.sku,
    this.name,
    this.ratingAggregationValue,
    this.productReviewCount,
    this.ratingSummaryData,
    this.reviews,
  });

  int? id;
  String? sku;
  String? name;
  double? ratingAggregationValue;
  String? productReviewCount;
  List<RatingSummaryDatum?>? ratingSummaryData;
  ProductReviews? reviews;

  factory ProductsItem.fromJson(Map<String, dynamic> json) => ProductsItem(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        ratingAggregationValue: json["rating_aggregation_value"]?.toDouble(),
        productReviewCount: json["product_review_count"],
        ratingSummaryData: json["rating_summary_data"] == null
            ? null
            : List<RatingSummaryDatum?>.from(json["rating_summary_data"]
                .map((x) => x != null ? RatingSummaryDatum.fromJson(x) : null)),
        reviews: json["reviews"] != null
            ? ProductReviews.fromJson(json["reviews"])
            : null,
      );
}

class RatingSummaryDatum {
  RatingSummaryDatum({
    this.ratingCount,
    this.ratingValue,
  });

  double? ratingCount;
  double? ratingValue;

  factory RatingSummaryDatum.fromJson(Map<String, dynamic> json) =>
      RatingSummaryDatum(
        ratingCount: json["rating_count"]?.toDouble(),
        ratingValue: json["rating_value"]?.toDouble(),
      );
}

class ProductReviews {
  ProductReviews({
    this.pageInfo,
    this.items,
  });

  PageInfo? pageInfo;
  List<ProductReviewsItem?>? items;

  factory ProductReviews.fromJson(Map<String, dynamic> json) => ProductReviews(
        pageInfo: json["page_info"] != null
            ? PageInfo.fromJson(json["page_info"])
            : null,
        items: json["items"] == null
            ? null
            : List<ProductReviewsItem?>.from(json["items"]
                .map((x) => x != null ? ProductReviewsItem.fromJson(x) : null)),
      );
}

class ProductReviewsItem {
  ProductReviewsItem({
    this.ratingValue,
    this.summary,
    this.text,
    this.createdAt,
    this.nickname,
  });

  double? ratingValue;
  String? summary;
  String? text;
  String? createdAt;
  String? nickname;

  factory ProductReviewsItem.fromJson(Map<String, dynamic> json) =>
      ProductReviewsItem(
        ratingValue: json["rating_value"]?.toDouble(),
        summary: json["summary"],
        text: json["text"],
        createdAt: json["created_at"],
        nickname: json["nickname"],
      );
}

class PageInfo {
  PageInfo({
    this.currentPage,
    this.pageSize,
    this.totalPages,
  });

  int? currentPage;
  int? pageSize;
  int? totalPages;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        currentPage: json["current_page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
      );
}
