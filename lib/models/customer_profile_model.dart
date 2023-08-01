class CustomerProfileModel {
  CustomerProfileModel({
    this.firstname,
    this.lastname,
    this.email,
    this.mobileNumber,
    this.gender,
    this.dateOfBirth,
  });

  CustomerProfileModel.fromJson(dynamic json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
  }

  String? firstname;
  String? lastname;
  String? email;
  String? mobileNumber;
  int? gender;
  String? dateOfBirth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['email'] = email;
    map['mobile_number'] = mobileNumber;
    map['gender'] = gender;
    map['date_of_birth'] = dateOfBirth;
    return map;
  }
}
