class SelectedScheme {
  SelectedScheme({
    this.columns,
    this.items,
  });

  List<String?>? columns;
  List<SelectedSchemeItem?>? items;

  factory SelectedScheme.fromJson(Map<String, dynamic> json) => SelectedScheme(
        columns: (json["columns"] == null || json["columns"].isEmpty)
            ? null
            : List<String>.from(json["columns"].map((x) => x)),
        items: (json["items"] == null || json["items"].isEmpty)
            ? null
            : List<SelectedSchemeItem?>.from(json["items"]
                .map((x) => x == null ? null : SelectedSchemeItem.fromJson(x))),
      );
}

class SelectedSchemeItem {
  SelectedSchemeItem({
    this.id,
    this.schemeId,
    this.values,
  });

  int? id;
  String? schemeId;
  List<String?>? values;

  factory SelectedSchemeItem.fromJson(Map<String, dynamic> json) =>
      SelectedSchemeItem(
        id: json["id"],
        schemeId: json["schemeId"],
        values: (json["values"] == null || json["values"].isEmpty)
            ? null
            : List<String?>.from(json["values"].map((x) => x)),
      );
}
