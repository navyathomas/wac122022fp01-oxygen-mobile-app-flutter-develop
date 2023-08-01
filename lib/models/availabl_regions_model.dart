class AvailablRegionsModel {
  AvailablRegionsModel({
    this.id,
    this.availableRegions,
  });

  AvailablRegionsModel.fromJson(dynamic json) {
    id = json['id'];
    if (json['available_regions'] != null) {
      availableRegions = [];
      json['available_regions'].forEach((v) {
        availableRegions?.add(AvailableRegions.fromJson(v));
      });
    }
  }

  String? id;
  List<AvailableRegions>? availableRegions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (availableRegions != null) {
      map['available_regions'] =
          availableRegions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AvailableRegions {
  AvailableRegions({
    this.id,
    this.code,
    this.name,
    this.availableDistricts,
  });

  AvailableRegions.fromJson(dynamic json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    if (json['available_districts'] != null) {
      availableDistricts = [];
      json['available_districts'].forEach((v) {
        availableDistricts?.add(AvailableDistricts.fromJson(v));
      });
    }
  }

  int? id;
  String? code;
  String? name;
  List<AvailableDistricts>? availableDistricts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['name'] = name;
    if (availableDistricts != null) {
      map['available_districts'] =
          availableDistricts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AvailableDistricts {
  AvailableDistricts({
    this.name,
  });

  AvailableDistricts.fromJson(dynamic json) {
    name = json['name'];
  }

  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
