class PaymentModesModel {
  List<GetMobileAppPaymentModes>? getMobileAppPaymentModes;

  PaymentModesModel({this.getMobileAppPaymentModes});

  PaymentModesModel.fromJson(Map<String, dynamic> json) {
    if (json['getMobileAppPaymentModes'] != null) {
      getMobileAppPaymentModes = <GetMobileAppPaymentModes>[];
      json['getMobileAppPaymentModes'].forEach((v) {
        getMobileAppPaymentModes!.add(GetMobileAppPaymentModes.fromJson(v));
      });
    }
  }
}

class GetMobileAppPaymentModes {
  String? title;
  String? imageUrl;
  String? type;
  List<PaymentMethods>? paymentMethods;

  GetMobileAppPaymentModes(
      {this.title, this.imageUrl, this.type, this.paymentMethods});

  GetMobileAppPaymentModes.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageUrl = json['image_url'];
    type = json['type'];
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
  }
}

class PaymentMethods {
  String? title;
  String? paymentCode;

  PaymentMethods({this.title, this.paymentCode});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    title = json['title'];

    paymentCode = json['payment_code'];
  }
}
