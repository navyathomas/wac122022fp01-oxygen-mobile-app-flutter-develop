import 'package:hive/hive.dart';

part 'auth_data_model.g.dart';

class AuthDataModel extends HiveObject {
  AuthDataModel({
    this.token,
    this.authCustomer,
  });

  AuthDataModel.fromJson(dynamic json) {
    token = json['token'];
    authCustomer = json['customer'] != null
        ? AuthCustomer.fromJson(json['customer'])
        : null;
  }

  String? token;
  AuthCustomer? authCustomer;
}

@HiveType(typeId: 1)
class AuthCustomer {
  AuthCustomer({this.email, this.firstname, this.lastname, this.mobileNumber});

  AuthCustomer.fromJson(dynamic json) {
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    mobileNumber = json['mobile_number'];
  }

  @HiveField(1)
  String? email;
  @HiveField(2)
  String? firstname;
  @HiveField(3)
  String? lastname;
  @HiveField(4)
  String? mobileNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['mobile_number'] = mobileNumber;
    return map;
  }
}
