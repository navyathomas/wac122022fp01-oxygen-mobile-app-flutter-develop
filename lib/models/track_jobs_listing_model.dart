class TrackJobsListingModel {
  TrackJobsListingModel({
    this.data,
  });

  final TrackJobsData? data;

  factory TrackJobsListingModel.fromJson(Map<String, dynamic> json) =>
      TrackJobsListingModel(
        data:
            json["data"] == null ? null : TrackJobsData.fromJson(json["data"]),
      );
}

class TrackJobsData {
  TrackJobsData({
    this.customer,
  });

  final Customer? customer;

  factory TrackJobsData.fromJson(Map<String, dynamic> json) => TrackJobsData(
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );
}

class Customer {
  Customer({
    this.trackJobsList,
  });

  final List<TrackJobsList?>? trackJobsList;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        trackJobsList:
            (json["trackJobsList"] == null || json["trackJobsList"].isEmpty)
                ? null
                : List<TrackJobsList?>.from(json["trackJobsList"]
                    .map((x) => x == null ? null : TrackJobsList.fromJson(x))),
      );
}

class TrackJobsList {
  TrackJobsList({
    this.id,
    this.jobId,
    this.itemName,
    this.status,
    this.colorCode,
    this.complaint,
    this.estimatedDelivery,
  });

  final int? id;
  final String? jobId;
  final String? itemName;
  final String? status;
  final String? colorCode;
  final String? complaint;
  final String? estimatedDelivery;

  factory TrackJobsList.fromJson(Map<String, dynamic> json) => TrackJobsList(
        id: json["id"],
        jobId: json["job_id"],
        itemName: json["item_name"],
        status: json["status"],
        colorCode: json["color_code"],
        complaint: json["complaint"],
        estimatedDelivery: json["estimated_delivery"],
      );
}
