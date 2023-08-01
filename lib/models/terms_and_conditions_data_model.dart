class TermsAndConditionsPrivacyPolicyModel {
  TermsAndConditionsPrivacyPolicyModel({
    this.urlKey,
    this.content,
    this.contentHeading,
    this.title,
    this.pageLayout,
    this.metaTitle,
    this.metaKeywords,
    this.metaDescription,
  });

  TermsAndConditionsPrivacyPolicyModel.fromJson(dynamic json) {
    urlKey = json['url_key'];
    content = json['content'];
    contentHeading = json['content_heading'];
    title = json['title'];
    pageLayout = json['page_layout'];
    metaTitle = json['meta_title'];
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
  }

  String? urlKey;
  String? content;
  String? contentHeading;
  String? title;
  String? pageLayout;
  String? metaTitle;
  String? metaKeywords;
  String? metaDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url_key'] = urlKey;
    map['content'] = content;
    map['content_heading'] = contentHeading;
    map['title'] = title;
    map['page_layout'] = pageLayout;
    map['meta_title'] = metaTitle;
    map['meta_keywords'] = metaKeywords;
    map['meta_description'] = metaDescription;
    return map;
  }
}
