import 'dart:convert';

class CompareProductsResponse {
  CompareProductsData? data;

  CompareProductsResponse({this.data});

  CompareProductsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? CompareProductsData.fromJson(json['data'])
        : null;
  }
}

class CompareProductsData {
  List<GetCompareProducts>? getCompareProducts;

  CompareProductsData({this.getCompareProducts});

  CompareProductsData.fromJson(Map<String, dynamic> json) {
    if (json['getCompareProducts'] != null) {
      getCompareProducts = <GetCompareProducts>[];
      json['getCompareProducts'].forEach((v) {
        if (v is Map) {
          getCompareProducts!
              .add(GetCompareProducts.fromJson(v as Map<String, dynamic>));
        }
      });
    }
  }
}

class GetCompareProducts {
  ComparableAttributes? comparableAttributes;
  String? discount;
  String? image;
  String? price;
  String? productId;
  String? productName;
  String? regularPrice;
  String? url;
  ProductInterface? productInterface;

  GetCompareProducts(
      {this.comparableAttributes,
      this.discount,
      this.image,
      this.price,
      this.productId,
      this.productName,
      this.regularPrice,
      this.url,
      this.productInterface});

  GetCompareProducts.fromJson(Map<String, dynamic> json) {
    if (json['comparable_attributes'] != null) {
      comparableAttributes = (ComparableAttributes.fromJson(
          jsonDecode(json['comparable_attributes'])));
    }
    discount = json['discount'];
    image = json['image'];
    price = json['price'];
    productId = json['product_id'];
    productName = json['product_name'];
    regularPrice = json['regular_price'];
    url = json['url'];
    productInterface = json['product_interface'] != null
        ? ProductInterface.fromJson(json['product_interface'])
        : null;
  }
}

class ComparableAttributes {
  General? general;
  Dimensions? dimensions;
  Warranty? warranty;
  ManufacturingPackagingAndImportInfo? manufacturingPackagingAndImportInfo;
  OtherDetails? otherDetails;
  DisplayFeatures? displayFeatures;
  Processor? processor;
  StorageFeatures? storageFeatures;
  BatteryAndPowerFeatures? batteryAndPowerFeatures;
  MemoryAndStorageFeatures? memoryAndStorageFeatures;
  List<AttributeValuePair>? attributeList;

  List<AttributeValuePair>? returnKeyValue(Map<String, dynamic> json) {
    List<AttributeValuePair> val = [];
    json.forEach((key, value) {
      if (value != null && value is Map) {
        List<KeyValuePairModel>? keyValuePair = [];
        value.forEach((key, val) {
          keyValuePair.add(KeyValuePairModel(key: key, value: val));
        });
        val.add(AttributeValuePair(key: key, value: keyValuePair));
      }
    });
    return val;
  }

  ComparableAttributes(
      {this.general,
      this.dimensions,
      this.warranty,
      this.manufacturingPackagingAndImportInfo,
      this.otherDetails,
      this.displayFeatures,
      this.processor,
      this.storageFeatures,
      this.batteryAndPowerFeatures,
      this.memoryAndStorageFeatures,
      this.attributeList});

  ComparableAttributes.fromJson(Map<String, dynamic> json) {
    attributeList = returnKeyValue(json);
  }
}

class General {
  List<KeyValuePairModel>? keyValuePairList;

  General({this.keyValuePairList});

  List<KeyValuePairModel>? returnKeyValue(Map<String, dynamic> json) {
    List<KeyValuePairModel>? val = [];
    json.forEach((key, value) {
      val.add(KeyValuePairModel(key: key, value: value));
    });
    return val;
  }

  General.fromJson(Map<String, dynamic> json) {
    keyValuePairList = returnKeyValue(json);
  }
}

class Dimensions {
  dynamic height;
  dynamic width;
  dynamic depth;

  Dimensions({this.height, this.width, this.depth});

  Dimensions.fromJson(Map<String, dynamic> json) {
    height = json['Height'];
    width = json['Width'];
    depth = json['Depth'];
  }
}

class Warranty {
  String? warrantySummary;
  String? coveredInWarranty;

  Warranty({this.warrantySummary, this.coveredInWarranty});

  Warranty.fromJson(Map<String, dynamic> json) {
    warrantySummary = json['Warranty Summary'];
    coveredInWarranty = json['Covered in Warranty'];
  }
}

class ManufacturingPackagingAndImportInfo {
  String? manufacturerSDetails;
  String? importerSMarketerSDetails;
  String? packerSDetails;

  ManufacturingPackagingAndImportInfo(
      {this.manufacturerSDetails,
      this.importerSMarketerSDetails,
      this.packerSDetails});

  ManufacturingPackagingAndImportInfo.fromJson(Map<String, dynamic> json) {
    manufacturerSDetails = json["Manufacturer's Details"];
    importerSMarketerSDetails = json["Importer's / Marketer's Details"];
    packerSDetails = json["Packer's Details"];
  }
}

class OtherDetails {
  String? mobileSpeciality;

  OtherDetails({this.mobileSpeciality});

  OtherDetails.fromJson(Map<String, dynamic> json) {
    mobileSpeciality = json['Mobile Speciality'];
  }
}

class DisplayFeatures {
  bool? display;
  String? displayResolution;

  DisplayFeatures({this.display, this.displayResolution});

  DisplayFeatures.fromJson(Map<String, dynamic> json) {
    display = json['Display'];
    displayResolution = json['Display Resolution'];
  }
}

class Processor {
  var processorSpeed;

  Processor({this.processorSpeed});

  Processor.fromJson(Map<String, dynamic> json) {
    processorSpeed = json['Processor Speed'];
  }
}

class StorageFeatures {
  var smartWatchRAM;
  var smartWatchROM;

  StorageFeatures({this.smartWatchRAM, this.smartWatchROM});

  StorageFeatures.fromJson(Map<String, dynamic> json) {
    smartWatchRAM = json['Smart watch RAM'];
    smartWatchROM = json['Smart watch ROM'];
  }
}

class MemoryAndStorageFeatures {
  String? internalStorage;
  String? rAM;

  MemoryAndStorageFeatures({this.internalStorage, this.rAM});

  MemoryAndStorageFeatures.fromJson(Map<String, dynamic> json) {
    internalStorage = json['Internal Storage'];
    rAM = json['RAM'];
  }
}

class BatteryAndPowerFeatures {
  String? batteryCapacity;

  BatteryAndPowerFeatures({this.batteryCapacity});

  BatteryAndPowerFeatures.fromJson(Map<String, dynamic> json) {
    batteryCapacity = json['Battery Capacity'];
  }
}

class KeyValuePairModel {
  String? key;
  dynamic value;

  KeyValuePairModel({this.key, this.value});
}

class AttributeValuePair {
  String? key;
  dynamic value;

  AttributeValuePair({this.key, this.value});

  @override
  String toString() {
    return 'value:$value';
  }
}

class ListValueModel {
  String? title;
  List<List<String>>? values;
}

class AttributesModel {
  String? title;
  List<AttributesItems>? attributesItems;

  AttributesModel({this.title, this.attributesItems});
}

class AttributesItems {
  List<KeyValuePairModel>? keyValuePair;

  AttributesItems({this.keyValuePair});
}

class ProductInterface {
  String? sku;
  String? sTypename;
  int? productTypeSet;

  ProductInterface({this.sku, this.sTypename, this.productTypeSet});

  ProductInterface.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    sTypename = json['__typename'];
    productTypeSet = json['product_type_set'];
  }
}
