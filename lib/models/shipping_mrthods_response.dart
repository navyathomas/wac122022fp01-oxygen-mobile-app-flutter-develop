class ShippingMethodsResponse {
  ShippingMethodData? data;

  ShippingMethodsResponse({this.data});

  ShippingMethodsResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? ShippingMethodData.fromJson(json['data']) : null;
  }
}

class ShippingMethodData {
  SetShippingAddressOnCart? setShippingAddressOnCart;

  ShippingMethodData({this.setShippingAddressOnCart});

  ShippingMethodData.fromJson(Map<String, dynamic> json) {
    setShippingAddressOnCart = json['setShippingAddressesOnCart'] != null
        ? SetShippingAddressOnCart.fromJson(json['setShippingAddressesOnCart'])
        : null;
  }
}

class SetShippingAddressOnCart {
  Cart? cart;

  SetShippingAddressOnCart({this.cart});

  SetShippingAddressOnCart.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
  }
}

class Cart {
  String? id;
  bool? isVirtual;
  List<ShippingAddresses>? shippingAddresses;

  Cart({this.id, this.isVirtual, this.shippingAddresses});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isVirtual = json['is_virtual'];
    if (json['shipping_addresses'] != null) {
      shippingAddresses = <ShippingAddresses>[];
      json['shipping_addresses'].forEach((v) {
        shippingAddresses!.add(ShippingAddresses.fromJson(v));
      });
    }
  }
}

class ShippingAddresses {
  List<AvailableShippingMethods>? availableShippingMethods;

  ShippingAddresses({this.availableShippingMethods});

  ShippingAddresses.fromJson(Map<String, dynamic> json) {
    if (json['available_shipping_methods'] != null) {
      availableShippingMethods = <AvailableShippingMethods>[];
      json['available_shipping_methods'].forEach((v) {
        availableShippingMethods!.add(AvailableShippingMethods.fromJson(v));
      });
    }
  }
}

class AvailableShippingMethods {
  String? carrierCode;
  String? carrierTitle;
  String? errorMessage;
  String? methodCode;
  String? methodTitle;

  AvailableShippingMethods(
      {this.carrierCode,
      this.carrierTitle,
      this.errorMessage,
      this.methodCode,
      this.methodTitle});

  AvailableShippingMethods.fromJson(Map<String, dynamic> json) {
    carrierCode = json['carrier_code'];
    carrierTitle = json['carrier_title'];
    errorMessage = json['error_message'];
    methodCode = json['method_code'];
    methodTitle = json['method_title'];
  }
}
