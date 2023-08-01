class AggregationListModel {
  AggregationData? data;

  AggregationListModel({this.data});

  AggregationListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? AggregationData.fromJson(json['data']) : null;
  }
}

class AggregationData {
  Products? products;

  AggregationData({this.products});

  AggregationData.fromJson(Map<String, dynamic> json) {
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
  }
}

class Products {
  SortFields? sortFields;
  List<Aggregations>? aggregations;

  Products({this.aggregations});

  Products.fromJson(Map<String, dynamic> json) {
    sortFields = json['sort_fields'] != null
        ? SortFields.fromJson(json['sort_fields'])
        : null;
    if (json['aggregations'] != null) {
      aggregations = <Aggregations>[];
      json['aggregations'].forEach((v) {
        aggregations!.add(Aggregations.fromJson(v));
      });
    }
  }
}

class SortFields {
  String? defaultSortValue;
  String? defaultDirection;
  List<SortOptions>? options;

  SortFields({this.defaultSortValue, this.defaultDirection, this.options});

  SortFields.fromJson(Map<String, dynamic> json) {
    defaultSortValue = json['default'];
    defaultDirection = json['default_direction'];
    if (json['options'] != null) {
      options = <SortOptions>[];
      json['options'].forEach((v) {
        options!.add(SortOptions.fromJson(v));
      });
    }
  }
}

class SortOptions {
  String? label;
  String? sortDirection;
  String? value;

  SortOptions({this.label, this.sortDirection, this.value});

  SortOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    sortDirection = json['sort_direction'];
    value = json['value'];
  }
}

class Aggregations {
  String? attributeCode;
  String? label;
  List<AggregateOptions>? options;

  Aggregations({this.attributeCode, this.label, this.options});

  Aggregations.fromJson(Map<String, dynamic> json) {
    attributeCode = json['attribute_code'];
    label = json['label'];
    if (json['options'] != null) {
      options = <AggregateOptions>[];
      json['options'].forEach((v) {
        options!.add(AggregateOptions.fromJson(v));
      });
    }
  }
}

class AggregateOptions {
  String? label;
  String? value;
  SwatchData? swatchData;

  AggregateOptions({this.label, this.value, this.swatchData});

  AggregateOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    swatchData = json['swatch_data'] != null
        ? SwatchData.fromJson(json['swatch_data'])
        : null;
  }
}

class SwatchData {
  String? colorType;
  String? value;

  SwatchData({this.colorType, this.value});

  SwatchData.fromJson(Map<String, dynamic> json) {
    colorType = json['color_type'];
    value = json['value'];
  }
}
