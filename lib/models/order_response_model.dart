class OrderResponse {
  OrderData? data;

  OrderResponse({this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
  }
}

class OrderData {
  PlaceOrder? placeOrder;

  OrderData({this.placeOrder});

  OrderData.fromJson(Map<String, dynamic> json) {
    placeOrder = json['placeOrder'] != null
        ? PlaceOrder.fromJson(json['placeOrder'])
        : null;
  }
}

class PlaceOrder {
  Order? order;

  PlaceOrder({this.order});

  PlaceOrder.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

class Order {
  String? actionUrl;
  String? actionUrlMob;
  String? orderNumber;
  Payu? payu;

  Order({this.actionUrl, this.actionUrlMob, this.orderNumber, this.payu});

  Order.fromJson(Map<String, dynamic> json) {
    actionUrl = json['action_url'];
    actionUrlMob = json['action_url_mob'];
    orderNumber = json['order_number'];
    payu = json['payu'] != null ? Payu.fromJson(json['payu']) : null;
  }
}

class Payu {
  String? url;
  String? redirectHtml;
  String? redirectLink;

  Payu({this.url, this.redirectHtml, this.redirectLink});

  Payu.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    redirectHtml = json['redirectHTML'];
    redirectLink = json['redirectlink'];
  }
}
