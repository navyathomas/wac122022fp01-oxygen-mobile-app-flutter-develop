import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/models/search_response_model.dart';

import '../services/helpers.dart';

class CartDataModel {
  CartDataModel({
    this.cartItems,
    this.shippingAddresses,
    this.allNotInStock,
    this.shippingAmount,
    this.cartPrices,
    this.rewardPoints,
    this.rewardPointsText,
  });

  CartDataModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      cartItems = [];
      json['items'].forEach((v) {
        cartItems?.add(CartItems.fromJson(v));
      });
    }
    if (json['shipping_addresses'] != null) {
      shippingAddresses = <ShippingAddresses>[];
      json['shipping_addresses'].forEach((v) {
        shippingAddresses!.add(ShippingAddresses.fromJson(v));
      });
    }
    if (json['applied_coupons'] != null) {
      appliedCoupons = <AppliedCoupons>[];
      json['applied_coupons'].forEach((v) {
        appliedCoupons!.add(AppliedCoupons.fromJson(v));
      });
    }
    cartPrices =
        json['prices'] != null ? CartPrices.fromJson(json['prices']) : null;
    shippingAmount = shippingAddresses.notEmpty
        ? Helpers.convertToDouble(
            shippingAddresses?.first.selectedShippingMethod?.amount?.value)
        : 0.0;
    allNotInStock = cartItems == null
        ? false
        : cartItems!.any((element) =>
            (element.cartProduct?.stockStatus?.toUpperCase() ?? '') !=
            "IN_STOCK");
    rewardPoints = Helpers.convertToInt(json['reward_points']);
    rewardPointsText = json['reward_points_text'];
  }

  List<CartItems>? cartItems;
  List<ShippingAddresses>? shippingAddresses;
  List<AppliedCoupons>? appliedCoupons;
  double? shippingAmount;
  bool? allNotInStock;
  CartPrices? cartPrices;
  int? rewardPoints;
  String? rewardPointsText;
}

class AppliedCoupons {
  String? code;

  AppliedCoupons({this.code});

  AppliedCoupons.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }
}

class ShippingAddresses {
  SelectedShippingMethod? selectedShippingMethod;

  ShippingAddresses({this.selectedShippingMethod});

  ShippingAddresses.fromJson(Map<String, dynamic> json) {
    selectedShippingMethod = json['selected_shipping_method'] != null
        ? SelectedShippingMethod.fromJson(json['selected_shipping_method'])
        : null;
  }
}

class SelectedShippingMethod {
  Amount? amount;

  SelectedShippingMethod({this.amount});

  SelectedShippingMethod.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }
}

class CartPrices {
  List<AppliedTaxes>? appliedTaxes;
  BajajEmi? bajajEmi;
  List<Discounts>? discounts;
  Discounts? discountAmount;
  Amount? grandTotal;
  Amount? subtotalExcludingTax;
  Gst? gst;
  Amount? subtotalIncludingTax;

  CartPrices(
      {this.appliedTaxes,
      this.bajajEmi,
      this.discounts,
      this.discountAmount,
      this.grandTotal,
      this.subtotalExcludingTax,
      this.gst,
      this.subtotalIncludingTax});

  CartPrices.fromJson(Map<String, dynamic> json) {
    if (json['applied_taxes'] != null) {
      appliedTaxes = <AppliedTaxes>[];
      json['applied_taxes'].forEach((v) {
        appliedTaxes!.add(AppliedTaxes.fromJson(v));
      });
    }
    bajajEmi =
        json['bajaj_emi'] != null ? BajajEmi.fromJson(json['bajaj_emi']) : null;
    if (json['discounts'] != null) {
      discounts = <Discounts>[];
      json['discounts'].forEach((v) {
        discounts!.add(Discounts.fromJson(v));
      });
    }
    grandTotal = json['grand_total'] != null
        ? Amount.fromJson(json['grand_total'])
        : null;
    subtotalExcludingTax = json['subtotal_excluding_tax'] != null
        ? Amount.fromJson(json['subtotal_excluding_tax'])
        : null;
    gst = json['gst'] != null ? Gst.fromJson(json['gst']) : null;
    subtotalIncludingTax = json['subtotal_including_tax'] != null
        ? Amount.fromJson(json['subtotal_including_tax'])
        : null;
    discountAmount = discounts.notEmpty ? discounts?.first : null;
  }
}

class Discounts {
  Amount? amount;
  String? label;

  Discounts({this.amount, this.label});

  Discounts.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    label = json['label'];
  }
}

class AppliedTaxes {
  Amount? amount;

  AppliedTaxes({this.amount});

  AppliedTaxes.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }
}

class BajajEmi {
  String? label;
  Amount? amount;

  BajajEmi({this.label, this.amount});

  BajajEmi.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
  }
}

class Gst {
  String? currency;
  double? totalGst;
  double? cgst;
  bool? gstType;
  double? igst;
  double? sgst;
  double? shippingGst;

  Gst(
      {this.currency,
      this.totalGst,
      this.cgst,
      this.gstType,
      this.igst,
      this.sgst,
      this.shippingGst});

  Gst.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    totalGst = Helpers.convertToDouble(json['total_gst']);
    cgst = Helpers.convertToDouble(json['cgst']);
    gstType = json['gst_type'];
    igst = Helpers.convertToDouble(json['igst']);
    sgst = Helpers.convertToDouble(json['sgst']);
    shippingGst = Helpers.convertToDouble(json['shipping_gst']);
  }
}

class CartItems {
  CartItems(
      {this.quantity,
      this.cartProduct,
      this.cartItemId,
      this.sTypename,
      this.variationData,
      this.addonOptions,
      this.childCustomizableOptions});

  CartItems.fromJson(dynamic json) {
    quantity = Helpers.convertToInt(json['quantity']);
    cartProduct =
        json['product'] != null ? CartProduct.fromJson(json['product']) : null;
    cartItemId = Helpers.convertToInt(json['id'], defValue: -1);
    sTypename = json['__typename'];
    variationData = json['variation_data'] != null
        ? VariationData.fromJson(json['variation_data'])
        : null;
    if (json['child_customizable_options'] != null) {
      childCustomizableOptions = <ChildCustomizableOptions>[];
      json['child_customizable_options'].forEach((v) {
        childCustomizableOptions!.add(ChildCustomizableOptions.fromJson(v));
      });
    }
    if (json['addon_options'] != null) {
      addonOptions = <AddonOptions>[];
      json['addon_options'].forEach((v) {
        addonOptions!.add(AddonOptions.fromJson(v));
      });
    }
    if (json['simple_addon_options'] != null) {
      simpleAddonOptions = <ChildCustomizableOptions>[];
      json['simple_addon_options'].forEach((v) {
        simpleAddonOptions!.add(ChildCustomizableOptions.fromJson(v));
      });
    }
    if (json['configurable_addon_options'] != null) {
      configurableAddonOptions = <ChildCustomizableOptions>[];
      json['configurable_addon_options'].forEach((v) {
        configurableAddonOptions!.add(ChildCustomizableOptions.fromJson(v));
      });
    }
  }

  int? quantity;
  CartProduct? cartProduct;
  int? cartItemId;
  String? sTypename;
  VariationData? variationData;
  List<AddonOptions>? addonOptions;
  List<ChildCustomizableOptions>? simpleAddonOptions;
  List<ChildCustomizableOptions>? configurableAddonOptions;
  List<ChildCustomizableOptions>? childCustomizableOptions;
}

class VariationData {
  String? productUrlKey;
  String? sku;
  String? thumbnail;

  VariationData({this.productUrlKey, this.sku, this.thumbnail});

  VariationData.fromJson(Map<String, dynamic> json) {
    productUrlKey = json['product_url_key'];
    sku = json['sku'];
    thumbnail = json['thumbnail'];
  }
}

class AddonOptions {
  String? title;
  int? optionId;
  List<Value>? value;

  AddonOptions({this.title, this.optionId, this.value});

  AddonOptions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    optionId = json['option_id'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        if (v != null) value!.add(Value.fromJson(v));
      });
    }
  }
}

class Value {
  int? optionTypeId;
  int? price;
  String? sku;
  String? title;

  Value({this.optionTypeId, this.price, this.sku, this.title});

  Value.fromJson(Map<String, dynamic> json) {
    optionTypeId = json['option_type_id'];
    price = json['price'];
    sku = json['sku'];
    title = json['title'];
  }
}

class ChildCustomizableOptions {
  String? label;
  List<Values>? values;

  ChildCustomizableOptions({this.label, this.values});

  ChildCustomizableOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
  }
}

class Values {
  String? label;
  Price? price;
  int? value;

  Values({this.label, this.price, this.value});

  Values.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    value = Helpers.convertToInt(json['value'], defValue: -1);
  }
}

class Price {
  String? type;
  double? value;

  Price({this.type, this.value});

  Price.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = Helpers.convertToDouble(json['value']);
  }
}

class CartProduct {
  CartProduct(
      {this.sku,
      this.name,
      this.stockStatus,
      this.smallImage,
      this.productQuantity,
      this.priceRange});

  CartProduct.fromJson(dynamic json) {
    sku = json['sku'];
    name = json['name'];
    stockStatus = json['stock_status'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
    productQuantity = json['product_quantity'];
    priceRange = json['price_range'] != null
        ? PriceRange.fromJson(json['price_range'])
        : null;
  }

  String? sku;
  String? name;
  String? stockStatus;
  SmallImage? smallImage;
  int? productQuantity;
  PriceRange? priceRange;
}

class SmallImage {
  SmallImage({
    this.url,
  });

  SmallImage.fromJson(dynamic json) {
    url = json['url'];
  }

  String? url;
}
