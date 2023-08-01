class FaqListModel {
  FaqListModel({
    this.fAQs,
    this.pageInfo,
    this.totalCount,
  });

  FaqListModel.fromJson(dynamic json) {
    if (json['FAQs'] != null) {
      fAQs = [];
      json['FAQs'].forEach((v) {
        fAQs?.add(FaQs.fromJson(v));
      });
    }
    pageInfo =
        json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
    totalCount = json['totalCount'];
  }

  List<FaQs>? fAQs;
  PageInfo? pageInfo;
  int? totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fAQs != null) {
      map['FAQs'] = fAQs?.map((v) => v.toJson()).toList();
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

class FaQs {
  FaQs({
    this.answer,
    this.category,
    this.entityId,
    this.question,
  });

  FaQs.fromJson(dynamic json) {
    answer = json['answer'];
    category = json['category'];
    entityId = json['entity_id'];
    question = json['question'];
  }

  String? answer;
  dynamic category;
  int? entityId;
  String? question;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['answer'] = answer;
    map['category'] = category;
    map['entity_id'] = entityId;
    map['question'] = question;
    return map;
  }
}
