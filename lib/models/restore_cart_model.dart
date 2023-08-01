class RestoreCartModel {
  Customer? customer;

  RestoreCartModel({this.customer});

  RestoreCartModel.fromJson(Map<String, dynamic> json) {
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }
}

class Customer {
  bool? isRedirected;
  String? popupMessage;

  Customer({this.isRedirected, this.popupMessage});

  Customer.fromJson(Map<String, dynamic> json) {
    isRedirected = json['is_redirected'];
    popupMessage = json['popup_message'];
  }
}
