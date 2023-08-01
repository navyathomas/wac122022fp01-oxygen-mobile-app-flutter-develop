class CustomerAddressModel {
  CustomerAddressModel({
    this.addresses,
  });

  CustomerAddressModel.fromJson(dynamic json) {
    if (json['addresses'] != null) {
      addresses = [];
      json['addresses'].forEach((v) {
        addresses?.add(Addresses.fromJson(v));
      });
    }
  }

  List<Addresses>? addresses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (addresses != null) {
      map['addresses'] = addresses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Addresses {
  Addresses({
    this.id,
    this.city,
    this.countryCode,
    this.defaultBilling,
    this.defaultShipping,
    this.firstname,
    this.lastname,
    this.postcode,
    this.street,
    this.telephone,
    this.addresstype,
    this.workdays,
    this.region,
    this.isSelected = false,
    this.email,
  });

  Addresses.fromJson(dynamic json) {
    id = json['id'];
    city = json['city'];
    countryCode = json['country_code'];
    defaultBilling = json['default_billing'];
    defaultShipping = json['default_shipping'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    postcode = json['postcode'];
    street = json['street'] != null ? json['street'].cast<String>() : [];
    telephone = json['telephone'];
    addresstype = json['addresstype'];
    workdays = json['workdays'];
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    isSelected = false;
  }

  int? id;
  String? city;
  String? countryCode;
  bool? defaultBilling;
  bool? defaultShipping;
  String? firstname;
  String? lastname;
  String? postcode;
  List<String>? street;
  String? telephone;
  String? addresstype;
  String? workdays;
  Region? region;
  bool? isSelected;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['city'] = city;
    map['country_code'] = countryCode;
    map['default_billing'] = defaultBilling;
    map['default_shipping'] = defaultShipping;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['postcode'] = postcode;
    map['street'] = street;
    map['telephone'] = telephone;
    map['addresstype'] = addresstype;
    map['workdays'] = workdays;
    if (region != null) {
      map['region'] = region?.toJson();
    }
    return map;
  }
}

class Region {
  Region({this.regionCode, this.region, this.regionId});

  Region.fromJson(dynamic json) {
    regionCode = json['region_code'];
    region = json['region'];
    regionId = json['region_id'];
  }

  String? regionCode;
  String? region;
  int? regionId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['region_code'] = regionCode;
    map['region'] = region;
    map['region_id'] = regionId;
    return map;
  }
}
