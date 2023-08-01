class BajajEmiDetails {
  BajajEmiDetails({
    this.columns,
    this.items,
    this.subTitle,
    this.title,
  });

  List<String?>? columns;
  List<BajajItem?>? items;
  String? subTitle;
  String? title;

  factory BajajEmiDetails.fromJson(Map<String, dynamic> json) =>
      BajajEmiDetails(
        columns: (json["columns"] == null || json["columns"].isEmpty)
            ? null
            : List<String?>.from(json["columns"].map((x) => x)),
        items: (json["items"] == null || json["items"].isEmpty)
            ? null
            : List<BajajItem?>.from(json["items"]
                .map((x) => x == null ? null : BajajItem.fromJson(x))),
        subTitle: json["sub_title"],
        title: json["title"],
      );
}

class BajajItem {
  BajajItem({
    this.id,
    this.schemeId,
    this.values,
  });

  int? id;
  String? schemeId;
  List<String?>? values;

  factory BajajItem.fromJson(Map<String, dynamic> json) => BajajItem(
        id: json["id"],
        schemeId: json["schemeId"],
        values: (json["values"] == null || json["values"].isEmpty)
            ? null
            : List<String?>.from(json["values"].map((x) => x)),
      );
}

class BajajTermsAndConditions {
  String? title;
  String? description;

  BajajTermsAndConditions({this.title, this.description});

  factory BajajTermsAndConditions.fromJson(Map<String, dynamic> json) =>
      BajajTermsAndConditions(
        title: json["title"],
        description: json["description"],
      );
}
