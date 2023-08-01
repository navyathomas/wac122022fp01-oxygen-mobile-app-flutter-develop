class ServiceListingModel {
  ServiceListingModel({
    this.data,
  });

  final ServiceListingData? data;

  factory ServiceListingModel.fromJson(Map<String, dynamic> json) =>
      ServiceListingModel(
        data: json["data"] == null
            ? null
            : ServiceListingData.fromJson(json["data"]),
      );
}

class ServiceListingData {
  ServiceListingData({
    this.serviceListing,
  });

  final List<ServiceList?>? serviceListing;

  factory ServiceListingData.fromJson(Map<String, dynamic> json) =>
      ServiceListingData(
        serviceListing:
            (json["servicelisting"] == null || json["servicelisting"].isEmpty)
                ? null
                : List<ServiceList?>.from(json["servicelisting"]
                    .map((x) => x == null ? null : ServiceList.fromJson(x))),
      );
}

class ServiceList {
  ServiceList({
    this.serviceId,
    this.categoryType,
    this.brand,
    this.model,
    this.serialNumber,
    this.issueDescription,
    this.jsonImage,
    this.serviceRequestType,
    this.district,
    this.store,
    this.productFrom,
    this.title,
    this.customerId,
    this.phoneNumber,
    this.status,
    this.createdAt,
  });

  final int? serviceId;
  final String? categoryType;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? issueDescription;
  final String? jsonImage;
  final String? serviceRequestType;
  final String? district;
  final String? store;
  final String? productFrom;
  final String? title;
  final int? customerId;
  final String? phoneNumber;
  final String? status;
  final String? createdAt;

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        serviceId: json["service_id"],
        categoryType: json["category_type"],
        brand: json["Brand"],
        model: json["Model"],
        serialNumber: json["Serial_number"],
        issueDescription: json["issue_description"],
        jsonImage: json["json_image"],
        serviceRequestType: json["Service_request_type"],
        district: json["district"],
        store: json["store"],
        productFrom: json["product_from"],
        title: json["title"],
        customerId: json["customer_id"],
        phoneNumber: json["phone_number"].toString(),
        status: json["status"],
        createdAt: json["created_at"],
      );
}
