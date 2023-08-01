class ContactUsDataModel {
  ContactUsDataModel({
    this.address,
    this.email,
    this.showroom,
    this.support,
    this.locationData,
  });

  ContactUsDataModel.fromJson(dynamic json) {
    if (json['address'] != null) {
      address = [];
      json['address'].forEach((v) {
        address?.add(Address.fromJson(v));
      });
    }
    if (json['email'] != null) {
      email = [];
      json['email'].forEach((v) {
        email?.add(Email.fromJson(v));
      });
    }
    if (json['showroom'] != null) {
      showroom = [];
      json['showroom'].forEach((v) {
        showroom?.add(Showroom.fromJson(v));
      });
    }
    if (json['support'] != null) {
      support = [];
      json['support'].forEach((v) {
        support?.add(Support.fromJson(v));
      });
    }
    if (json['location'] != null) {
      locationData = [];
      json['location'].forEach((v) {
        locationData?.add(LocationData.fromJson(v));
      });
    }
  }

  List<Address>? address;
  List<Email>? email;
  List<Showroom>? showroom;
  List<Support>? support;
  List<LocationData>? locationData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (address != null) {
      map['address'] = address?.map((v) => v.toJson()).toList();
    }
    if (email != null) {
      map['email'] = email?.map((v) => v.toJson()).toList();
    }
    if (showroom != null) {
      map['showroom'] = showroom?.map((v) => v.toJson()).toList();
    }
    if (support != null) {
      map['support'] = support?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Support {
  Support({
    this.title,
    this.call,
    this.hour,
  });

  Support.fromJson(dynamic json) {
    title = json['title'];
    call = json['call'];
    hour = json['hour'];
  }

  String? title;
  String? call;
  String? hour;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['call'] = call;
    map['hour'] = hour;
    return map;
  }
}

class LocationData {
  dynamic longitude;
  dynamic latitude;

  LocationData({
    this.latitude,
    this.longitude,
  });

  LocationData.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class Showroom {
  Showroom({
    this.title,
    this.call,
    this.hour,
  });

  Showroom.fromJson(dynamic json) {
    title = json['title'];
    call = json['call'];
    hour = json['hour'];
  }

  String? title;
  String? call;
  String? hour;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['call'] = call;
    map['hour'] = hour;
    return map;
  }
}

class Email {
  Email({
    this.title,
    this.content,
  });

  Email.fromJson(dynamic json) {
    title = json['title'];
    content = json['content'];
  }

  String? title;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['content'] = content;
    return map;
  }
}

class Address {
  Address({
    this.title,
    this.content,
  });

  Address.fromJson(dynamic json) {
    title = json['title'];
    content = json['content'];
  }

  String? title;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['content'] = content;
    return map;
  }
}
