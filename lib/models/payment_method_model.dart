class PaymentMethodResponse {
  PaymentMethodData? data;

  PaymentMethodResponse({this.data});

  PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? PaymentMethodData.fromJson(json['data']) : null;
  }
}

class PaymentMethodData {
  PaymentMethodCart? cart;

  PaymentMethodData({this.cart});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    cart =
        json['cart'] != null ? PaymentMethodCart.fromJson(json['cart']) : null;
  }
}

class PaymentMethodCart {
  List<AvailablePaymentMethods>? availablePaymentMethods;
  List<AvailablePaymentMethods>? availablePaymentModes;

  PaymentMethodCart({this.availablePaymentMethods, this.availablePaymentModes});

  PaymentMethodCart.fromJson(Map<String, dynamic> json) {
    if (json['available_payment_methods'] != null) {
      availablePaymentMethods = <AvailablePaymentMethods>[];
      json['available_payment_methods'].forEach((v) {
        availablePaymentMethods!.add(AvailablePaymentMethods.fromJson(v));
      });
    }
    if (json['available_payment_modes'] != null) {
      availablePaymentModes = <AvailablePaymentMethods>[];
      json['available_payment_modes'].forEach((v) {
        availablePaymentModes!.add(AvailablePaymentMethods.fromJson(v));
      });
    }
  }
}

class AvailablePaymentMethods {
  String? code;
  String? title;
  String? imageUrl;
  String? description;
  String? mobileImageUrl;

  AvailablePaymentMethods(
      {this.code,
      this.title,
      this.imageUrl,
      this.description,
      this.mobileImageUrl});

  AvailablePaymentMethods.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    imageUrl = json['image_url'];
    description = json['description'];
    mobileImageUrl = json['mobile_image_url'];
  }
}
