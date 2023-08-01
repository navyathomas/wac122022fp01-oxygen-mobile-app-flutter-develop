import 'package:oxygen/services/helpers.dart';

class OrderDetailsResponse {
  OrderDetailsData? data;

  OrderDetailsResponse({this.data});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? OrderDetailsData.fromJson(json['data']) : null;
  }
}

class OrderDetailsData {
  CustomerOrders? customerOrders;

  OrderDetailsData({this.customerOrders});

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    customerOrders = json['customerOrders'] != null
        ? CustomerOrders.fromJson(json['customerOrders'])
        : null;
  }
}

class CustomerOrders {
  List<OrderDetailsItems>? items;

  CustomerOrders({this.items});

  CustomerOrders.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderDetailsItems>[];
      json['items'].forEach((v) {
        items!.add(OrderDetailsItems.fromJson(v));
      });
    }
  }
}

class OrderDetailsItems {
  String? orderNumber;
  OrderPaymentMethod? orderPaymentMethod;
  OrderShippingMethod? orderShippingMethod;
  OrderDetailsPrices? prices;
  List<OrderDetailsProducts>? products;

  OrderDetailsItems(
      {this.orderNumber,
      this.orderPaymentMethod,
      this.orderShippingMethod,
      this.prices,
      this.products});

  OrderDetailsItems.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    orderPaymentMethod = json['order_payment_method'] != null
        ? OrderPaymentMethod.fromJson(json['order_payment_method'])
        : null;
    orderShippingMethod = json['order_shipping_method'] != null
        ? OrderShippingMethod.fromJson(json['order_shipping_method'])
        : null;
    prices = json['prices'] != null
        ? OrderDetailsPrices.fromJson(json['prices'])
        : null;
    if (json['products'] != null) {
      products = <OrderDetailsProducts>[];
      json['products'].forEach((v) {
        products!.add(OrderDetailsProducts.fromJson(v));
      });
    }
  }
}

class OrderPaymentMethod {
  String? methodTitle;

  OrderPaymentMethod({this.methodTitle});

  OrderPaymentMethod.fromJson(Map<String, dynamic> json) {
    methodTitle = json['method_title'];
  }
}

class OrderShippingMethod {
  Amount? amount;

  OrderShippingMethod({this.amount});

  OrderShippingMethod.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }
}

class Amount {
  String? currency;
  double? value;

  Amount({this.currency, this.value});

  Amount.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }
}

class OrderDetailsPrices {
  List<Discount>? discount;
  Amount? grandTotal;
  Gst? gst;

  OrderDetailsPrices({this.discount, this.grandTotal, this.gst});

  OrderDetailsPrices.fromJson(Map<String, dynamic> json) {
    if (json['discount'] != null) {
      discount = <Discount>[];
      json['discount'].forEach((v) {
        discount!.add(Discount.fromJson(v));
      });
    }
    grandTotal = json['grand_total'] != null
        ? Amount.fromJson(json['grand_total'])
        : null;
    gst = json['gst'] != null ? Gst.fromJson(json['gst']) : null;
  }
}

class Discount {
  Amount? amount;
  String? label;

  Discount({this.amount, this.label});

  Discount.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    label = json['label'];
  }
}

class Gst {
  String? currency;
  double? totalGst;
  double? sgst;
  double? cgst;
  double? igst;

  Gst({this.currency, this.totalGst, this.sgst, this.cgst, this.igst});

  Gst.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    totalGst = Helpers.convertToDouble(json['total_gst']);
    sgst = Helpers.convertToDouble(json['sgst']);
    cgst = Helpers.convertToDouble(json['cgst']);
    igst = Helpers.convertToDouble(json['igst']);
  }
}

class OrderDetailsProducts {
  OrderDetails? orderDetails;
  Thumbnail? thumbnail;

  OrderDetailsProducts({this.orderDetails, this.thumbnail});

  OrderDetailsProducts.fromJson(Map<String, dynamic> json) {
    orderDetails = json['order_details'] != null
        ? OrderDetails.fromJson(json['order_details'])
        : null;
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
  }
}

class OrderDetails {
  int? discount;
  String? finalPrice;
  int? id;
  bool? isItemAvailableForReview;
  String? name;
  String? quantity;
  String? regularPrice;
  String? sku;

  OrderDetails(
      {this.discount,
      this.finalPrice,
      this.id,
      this.isItemAvailableForReview,
      this.name,
      this.quantity,
      this.regularPrice,
      this.sku});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    discount = Helpers.convertToInt(json['discount']);
    finalPrice = json['final_price'];
    id = json['id'];
    isItemAvailableForReview = json['is_item_available_for_review'];
    name = json['name'];
    quantity = json['quantity'];
    regularPrice = json['regular_price'];
    sku = json['sku'];
  }
}

class Thumbnail {
  String? url;

  Thumbnail({this.url});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}
