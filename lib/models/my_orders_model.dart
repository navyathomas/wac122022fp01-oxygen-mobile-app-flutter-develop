import 'package:oxygen/services/helpers.dart';

class MyOrdersModel {
  MyOrdersModel({
    this.items,
    this.pageInfo,
    this.totalCount,
  });

  MyOrdersModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    pageInfo =
        json['page_info'] != null ? PageInfo.fromJson(json['page_info']) : null;
    totalCount = json['total_count'];
  }

  List<Items>? items;
  PageInfo? pageInfo;
  int? totalCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      map['page_info'] = pageInfo?.toJson();
    }
    map['total_count'] = totalCount;
    return map;
  }

  MyOrdersModel copyWith({int? count, MyOrdersModel? model}) {
    List<Items> _items = model!.items!;
    items?.addAll(model.items!);
    return MyOrdersModel(
        items: _items, pageInfo: model.pageInfo, totalCount: model.totalCount);
  }
}

class PageInfo {
  PageInfo({
    this.currentPage,
    this.pageSize,
    this.totalPages,
  });

  PageInfo.fromJson(dynamic json) {
    currentPage = json['current_page'];
    pageSize = json['page_size'];
    totalPages = json['total_pages'];
  }

  int? currentPage;
  int? pageSize;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['page_size'] = pageSize;
    map['total_pages'] = totalPages;
    return map;
  }
}

class Items {
  Items({
    this.id,
    this.currentStatus,
    this.shippingAddresses,
    this.createdAt,
    this.orderNumber,
    this.status,
    this.orderProcess,
    this.products,
    this.prices,
    this.trackingData,
    this.orderPaymentMethod,
    this.trackDeliveryStatus,
    this.customerDeliveryDetails,
  });

  Items.fromJson(dynamic json) {
    id = json['id'];
    currentStatus = json['current_status'] != null
        ? CurrentStatus.fromJson(json['current_status'])
        : null;
    shippingAddresses = json['shipping_addresses'] != null
        ? ShippingAddresses.fromJson(json['shipping_addresses'])
        : null;
    orderPaymentMethod = json['order_payment_method'] != null
        ? OrderPaymentMethod.fromJson(json['order_payment_method'])
        : null;
    createdAt = json['created_at'];
    orderNumber = json['order_number'];
    status = json['status'];
    orderProcess = json['order_process'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    trackingData = json['tracking_data'] != null
        ? TrackingData.fromJson(json['tracking_data'])
        : null;
    trackDeliveryStatus = json["trackDeliveryStatus"] == null
        ? null
        : TrackDeliveryStatus.fromJson(json["trackDeliveryStatus"]);
    customerDeliveryDetails = json["customerDeliveryDetails"] == null
        ? null
        : CustomerDeliveryDetails.fromJson(json["customerDeliveryDetails"]);
  }

  int? id;
  CurrentStatus? currentStatus;
  ShippingAddresses? shippingAddresses;
  String? createdAt;
  String? orderNumber;
  String? status;
  String? orderProcess;
  List<Products>? products;
  Prices? prices;
  TrackingData? trackingData;
  OrderPaymentMethod? orderPaymentMethod;
  TrackDeliveryStatus? trackDeliveryStatus;
  CustomerDeliveryDetails? customerDeliveryDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (currentStatus != null) {
      map['current_status'] = currentStatus?.toJson();
    }
    if (shippingAddresses != null) {
      map['shipping_addresses'] = shippingAddresses?.toJson();
    }
    map['created_at'] = createdAt;
    map['order_number'] = orderNumber;
    map['status'] = status;
    map['order_process'] = orderProcess;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (prices != null) {
      map['prices'] = prices?.toJson();
    }
    if (trackingData != null) {
      map['tracking_data'] = trackingData?.toJson();
    }
    return map;
  }
}

class TrackingData {
  TrackingData({
    this.status,
    this.url,
  });

  TrackingData.fromJson(dynamic json) {
    status = json['status'];
    url = json['url'];
  }

  bool? status;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['url'] = url;
    return map;
  }
}

class Prices {
  Prices({
    this.gst,
    this.discount,
    this.grandTotal,
    this.subtotalExcludingTax,
    this.subtotalIncludingTax,
  });

  Prices.fromJson(dynamic json) {
    gst = json['gst'] != null ? Gst.fromJson(json['gst']) : null;
    if (json['shipping_addresses'] != null) {
      shippingFee = [];
      json['shipping_addresses'].forEach((v) {
        shippingFee?.add(ShippingFee.fromJson(v));
      });
    }
    if (json['discount'] != null) {
      discount = [];
      json['discount'].forEach((v) {
        discount?.add(Discount.fromJson(v));
      });
    }
    grandTotal = json['grand_total'] != null
        ? GrandTotal.fromJson(json['grand_total'])
        : null;
    subtotalExcludingTax = json['subtotal_excluding_tax'] != null
        ? SubtotalExcludingTax.fromJson(json['subtotal_excluding_tax'])
        : null;
    subtotalIncludingTax = json['subtotal_including_tax'] != null
        ? SubtotalIncludingTax.fromJson(json['subtotal_including_tax'])
        : null;
  }

  Gst? gst;
  List<Discount>? discount;
  GrandTotal? grandTotal;
  SubtotalExcludingTax? subtotalExcludingTax;
  SubtotalIncludingTax? subtotalIncludingTax;
  List<ShippingFee>? shippingFee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (gst != null) {
      map['gst'] = gst?.toJson();
    }
    if (discount != null) {
      map['discount'] = discount?.map((v) => v.toJson()).toList();
    }
    if (grandTotal != null) {
      map['grand_total'] = grandTotal?.toJson();
    }
    if (subtotalExcludingTax != null) {
      map['subtotal_excluding_tax'] = subtotalExcludingTax?.toJson();
    }
    if (subtotalIncludingTax != null) {
      map['subtotal_including_tax'] = subtotalIncludingTax?.toJson();
    }
    return map;
  }
}

class ShippingFee {
  ShippingFee({
    this.selectedShippingMethod,
  });

  SelectedShippingMethod? selectedShippingMethod;

  ShippingFee.fromJson(dynamic json) {
    selectedShippingMethod = json['selected_shipping_method'] != null
        ? SelectedShippingMethod.fromJson(json['selected_shipping_method'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (selectedShippingMethod != null) {
      map['selected_shipping_method'] = selectedShippingMethod?.toJson();
    }
    return map;
  }
}

class SelectedShippingMethod {
  SelectedShippingMethod({
    this.amount,
  });

  SelectedShippingMethod.fromJson(dynamic json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }

  Amount? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (amount != null) {
      map['amount'] = amount?.toJson();
    }
    return map;
  }
}

class SubtotalIncludingTax {
  SubtotalIncludingTax({
    this.currency,
    this.value,
  });

  SubtotalIncludingTax.fromJson(dynamic json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  String? currency;
  double? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['value'] = value;
    return map;
  }
}

class SubtotalExcludingTax {
  SubtotalExcludingTax({
    this.currency,
    this.value,
  });

  SubtotalExcludingTax.fromJson(dynamic json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  String? currency;
  double? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['value'] = value;
    return map;
  }
}

class GrandTotal {
  GrandTotal({
    this.currency,
    this.value,
  });

  GrandTotal.fromJson(dynamic json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  String? currency;
  double? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['value'] = value;
    return map;
  }
}

class Discount {
  Discount({
    this.amount,
    this.label,
  });

  Discount.fromJson(dynamic json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    label = json['label'];
  }

  Amount? amount;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (amount != null) {
      map['amount'] = amount?.toJson();
    }
    map['label'] = label;
    return map;
  }
}

class Amount {
  Amount({
    this.currency,
    this.value,
  });

  Amount.fromJson(dynamic json) {
    currency = json['currency'];
    value = Helpers.convertToDouble(json['value']);
  }

  String? currency;
  double? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['value'] = value;
    return map;
  }
}

class Gst {
  Gst({
    this.cgst,
    this.igst,
    this.sgst,
    this.shippingGst,
    this.totalGst,
    this.currency,
    this.gstType,
  });

  Gst.fromJson(dynamic json) {
    cgst = Helpers.convertToDouble(json['cgst']);
    igst = Helpers.convertToDouble(json['igst']);
    sgst = Helpers.convertToDouble(json['sgst']);
    shippingGst = Helpers.convertToDouble(json['shipping_gst']);
    totalGst = Helpers.convertToDouble(json['total_gst']);
    currency = json['currency'];
    gstType = json['gst_type'];
  }

  double? cgst;
  double? igst;
  double? sgst;
  double? shippingGst;
  double? totalGst;
  String? currency;
  bool? gstType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cgst'] = cgst;
    map['igst'] = igst;
    map['sgst'] = sgst;
    map['shipping_gst'] = shippingGst;
    map['total_gst'] = totalGst;
    map['currency'] = currency;
    map['gst_type'] = gstType;
    return map;
  }
}

class Products {
  Products({
    this.id,
    this.smallImage,
    this.orderDetails,
  });

  Products.fromJson(dynamic json) {
    id = json['id'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
    orderDetails = json['order_details'] != null
        ? OrderDetails.fromJson(json['order_details'])
        : null;
  }

  int? id;
  SmallImage? smallImage;
  OrderDetails? orderDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (smallImage != null) {
      map['small_image'] = smallImage?.toJson();
    }
    if (orderDetails != null) {
      map['order_details'] = orderDetails?.toJson();
    }
    return map;
  }
}

class OrderDetails {
  OrderDetails({
    this.id,
    this.name,
    this.sku,
    this.quantity,
    this.regularPrice,
    this.finalPrice,
    this.discount,
    this.isItemAvailableForReview,
  });

  OrderDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    quantity = json['quantity'];
    regularPrice = json['regular_price'];
    finalPrice = json['final_price'];
    discount = Helpers.convertToDouble(json['discount']);
    isItemAvailableForReview = json['is_item_available_for_review'];
  }

  int? id;
  String? name;
  String? sku;
  String? quantity;
  String? regularPrice;
  String? finalPrice;
  double? discount;
  bool? isItemAvailableForReview;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sku'] = sku;
    map['quantity'] = quantity;
    map['regular_price'] = regularPrice;
    map['final_price'] = finalPrice;
    map['discount'] = discount;
    map['is_item_available_for_review'] = isItemAvailableForReview;
    return map;
  }
}

class SmallImage {
  SmallImage({
    this.url,
  });

  SmallImage.fromJson(dynamic json) {
    url = json['url'];
  }

  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}

class ShippingAddresses {
  ShippingAddresses({
    this.addresstype,
    this.firstname,
    this.lastname,
    this.street,
    this.city,
    this.postcode,
    this.telephone,
  });

  ShippingAddresses.fromJson(dynamic json) {
    addresstype = json['addresstype'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    street = json['street'] != null ? json['street'].cast<String>() : [];
    city = json['city'];
    postcode = json['postcode'];
    telephone = json['telephone'];
  }

  String? addresstype;
  String? firstname;
  String? lastname;
  List<String>? street;
  String? city;
  String? postcode;
  String? telephone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addresstype'] = addresstype;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['street'] = street;
    map['city'] = city;
    map['postcode'] = postcode;
    map['telephone'] = telephone;
    return map;
  }

  String get address {
    if ((street ?? []).isNotEmpty) {
      if (street!.length > 2) {
        return '${street?[0]} ${street?[1]}, ${city != null ? "$city, " : ''}${postcode != null ? "$postcode, " : ""}\nMobile:${telephone ?? ''}';
      } else {
        return '${street?[0]}, ${city != null ? "$city, " : ''}${postcode != null ? "$postcode, " : ""}\nMobile:${telephone ?? ''}';
      }
    }
    return '';
  }
}

//  "order_payment_method": {
//             "code": null,
//             "method_title": "Pay Now",
//             "purchase_order_number": null
//           },

class OrderPaymentMethod {
  dynamic code;
  String? methodTitle;

  OrderPaymentMethod({
    this.code,
    this.methodTitle,
  });

  OrderPaymentMethod.fromJson(dynamic json) {
    code = json['code'];
    methodTitle = json['method_title'];
  }
}

class CurrentStatus {
  CurrentStatus({
    this.status,
    this.date,
    this.value,
  });

  CurrentStatus.fromJson(dynamic json) {
    status = json['status'];
    date = json['date'];
    value = json['value'];
  }

  String? status;
  String? date;
  int? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['date'] = date;
    map['value'] = value;
    return map;
  }
}

class CustomerDeliveryDetails {
  CustomerDeliveryDetails({
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
    this.billingAddress,
  });

  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? shippingAddress;
  final String? billingAddress;

  factory CustomerDeliveryDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDeliveryDetails(
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerPhone: json["customer_phone"],
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
      );
}

class TrackDeliveryStatus {
  TrackDeliveryStatus({
    this.title,
    this.status,
    this.expectedDelivery,
  });

  final String? title;
  final List<Status?>? status;
  final ExpectedDelivery? expectedDelivery;

  factory TrackDeliveryStatus.fromJson(Map<String, dynamic> json) =>
      TrackDeliveryStatus(
        title: json["title"],
        status: (json["status"] == null || json["status"].isEmpty)
            ? null
            : List<Status?>.from(json["status"]
                .map((x) => x == null ? null : Status.fromJson(x))),
        expectedDelivery: json["expected_delivery"] == null
            ? null
            : ExpectedDelivery.fromJson(json["expected_delivery"]),
      );
}

class Status {
  Status({
    this.status,
    this.statusLabel,
    this.colorCode,
    this.isActive,
    this.lastUpdated,
  });

  final String? status;
  final String? statusLabel;
  final String? colorCode;
  final bool? isActive;
  final String? lastUpdated;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json["status"],
        statusLabel: json["status_label"],
        colorCode: json["color_code"],
        isActive: json["is_active"],
        lastUpdated: json["last_updated"],
      );
}

class ExpectedDelivery {
  ExpectedDelivery({
    this.title,
    this.date,
  });

  final String? title;
  final String? date;

  factory ExpectedDelivery.fromJson(Map<String, dynamic> json) =>
      ExpectedDelivery(
        title: json["title"],
        date: json["date"],
      );
}
