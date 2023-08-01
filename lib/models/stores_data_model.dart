class StoresDataModel {
  StoresDataModel({
    this.id,
    this.images,
    this.heading,
    this.street,
    this.city,
    this.state,
    this.pincode,
    this.country,
    this.phone,
    this.mobile,
    this.email,
    this.latitude,
    this.longitude,
    this.linkLabel,
    this.link,
  });

  StoresDataModel.fromJson(dynamic json) {
    id = json['id'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    heading = json['heading'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    country = json['country'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    linkLabel = json['link_label'];
    link = json['link'];
  }

  String? id;
  Images? images;
  String? heading;
  String? street;
  String? city;
  String? state;
  String? pincode;
  String? country;
  dynamic phone;
  String? mobile;
  String? email;
  double? latitude;
  double? longitude;
  String? linkLabel;
  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (images != null) {
      map['images'] = images?.toJson();
    }
    map['heading'] = heading;
    map['street'] = street;
    map['city'] = city;
    map['state'] = state;
    map['pincode'] = pincode;
    map['country'] = country;
    map['phone'] = phone;
    map['mobile'] = mobile;
    map['email'] = email;
    map['Latitude'] = latitude;
    map['Longitude'] = longitude;
    map['link_label'] = linkLabel;
    map['link'] = link;
    return map;
  }
}

class ImagesData {
  ImagesData({
    this.images,
    this.imagesOther,
  });

  ImagesData.fromJson(dynamic json) {
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    imagesOther = json['images_other'] != null
        ? ImagesOther.fromJson(json['images_other'])
        : null;
  }

  Images? images;
  ImagesOther? imagesOther;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (images != null) {
      map['images'] = images?.toJson();
    }
    if (imagesOther != null) {
      map['images_other'] = imagesOther?.toJson();
    }
    return map;
  }
}

class ImagesOther {
  ImagesOther({
    this.desktop,
    this.desktop2x,
    this.laptop,
    this.laptop2x,
    this.ipad,
    this.ipad2x,
    this.mobile,
    this.mobile2x,
  });

  ImagesOther.fromJson(dynamic json) {
    desktop = json['desktop'];
    desktop2x = json['desktop_2x'];
    laptop = json['laptop'];
    laptop2x = json['laptop_2x'];
    ipad = json['ipad'];
    ipad2x = json['ipad_2x'];
    mobile = json['mobile'];
    mobile2x = json['mobile_2x'];
  }

  String? desktop;
  String? desktop2x;
  String? laptop;
  String? laptop2x;
  String? ipad;
  String? ipad2x;
  String? mobile;
  String? mobile2x;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['desktop'] = desktop;
    map['desktop_2x'] = desktop2x;
    map['laptop'] = laptop;
    map['laptop_2x'] = laptop2x;
    map['ipad'] = ipad;
    map['ipad_2x'] = ipad2x;
    map['mobile'] = mobile;
    map['mobile_2x'] = mobile2x;
    return map;
  }
}

class Images {
  Images({
    this.desktop,
    this.desktop2x,
    this.laptop,
    this.laptop2x,
    this.ipad,
    this.ipad2x,
    this.mobile,
    this.mobile2x,
  });

  Images.fromJson(dynamic json) {
    desktop = json['desktop'];
    desktop2x = json['desktop_2x'];
    laptop = json['laptop'];
    laptop2x = json['laptop_2x'];
    ipad = json['ipad'];
    ipad2x = json['ipad_2x'];
    mobile = json['mobile'];
    mobile2x = json['mobile_2x'];
  }

  String? desktop;
  String? desktop2x;
  String? laptop;
  String? laptop2x;
  String? ipad;
  String? ipad2x;
  String? mobile;
  String? mobile2x;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['desktop'] = desktop;
    map['desktop_2x'] = desktop2x;
    map['laptop'] = laptop;
    map['laptop_2x'] = laptop2x;
    map['ipad'] = ipad;
    map['ipad_2x'] = ipad2x;
    map['mobile'] = mobile;
    map['mobile_2x'] = mobile2x;
    return map;
  }
}
