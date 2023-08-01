class CmsItem {
  CmsItem({
    this.content,
    this.identifier,
    this.title,
  });

  String? content;
  String? identifier;
  String? title;

  factory CmsItem.fromJson(Map<String, dynamic> json) => CmsItem(
        content: json["content"],
        identifier: json["identifier"],
        title: json["title"],
      );
}
