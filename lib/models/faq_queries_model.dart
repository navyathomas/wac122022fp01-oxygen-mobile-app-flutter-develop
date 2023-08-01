class FaqQueriesModel {
  FaqQueriesModel({
    this.faqCategories,
    this.pageInfo,
    this.totalCount,
  });

  FaqQueriesModel.fromJson(dynamic json) {
    if (json['faqCategories'] != null) {
      faqCategories = [];
      json['faqCategories'].forEach((v) {
        faqCategories?.add(FaqCategories.fromJson(v));
      });
    }
    pageInfo =
        json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
    totalCount = json['totalCount'];
  }

  List<FaqCategories>? faqCategories;
  PageInfo? pageInfo;
  int? totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (faqCategories != null) {
      map['faqCategories'] = faqCategories?.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      map['page_info'] = pageInfo?.toJson();
    }
    map['totalCount'] = totalCount;
    return map;
  }
}

class PageInfo {
  PageInfo({
    this.currentPage,
    this.pageSize,
    this.totalPages,
  });

  PageInfo.fromJson(dynamic json) {
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
  }

  int? currentPage;
  int? pageSize;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['page_size'] = pageSize;
    map['total_pages'] = totalPages;
    return map;
  }
}

class FaqCategories {
  FaqCategories({
    this.id,
    this.name,
  });

  FaqCategories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
