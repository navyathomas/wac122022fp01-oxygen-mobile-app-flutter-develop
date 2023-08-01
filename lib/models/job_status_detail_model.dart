class JobStatusDetailModel {
  JobStatusDetailModel({
    this.data,
  });

  final JobStatusData? data;

  factory JobStatusDetailModel.fromJson(Map<String, dynamic> json) =>
      JobStatusDetailModel(
        data:
            json["data"] == null ? null : JobStatusData.fromJson(json["data"]),
      );
}

class JobStatusData {
  JobStatusData({
    this.jobStatusDetails,
  });

  final JobStatusDetails? jobStatusDetails;

  factory JobStatusData.fromJson(Map<String, dynamic> json) => JobStatusData(
        jobStatusDetails: json["jobStatusDetails"] == null
            ? null
            : JobStatusDetails.fromJson(json["jobStatusDetails"]),
      );
}

class JobStatusDetails {
  JobStatusDetails({
    this.customerDetails,
    this.itemDetails,
    this.jobCategory,
    this.jobDetails,
    this.jobStatus,
    this.lastStatusUpdate,
  });

  final CustomerDetails? customerDetails;
  final List<ItemDetail?>? itemDetails;
  final JobCategory? jobCategory;
  final JobDetails? jobDetails;
  final List<JobStatus?>? jobStatus;
  final LastStatusUpdate? lastStatusUpdate;

  factory JobStatusDetails.fromJson(Map<String, dynamic> json) =>
      JobStatusDetails(
        customerDetails: json["customerDetails"] == null
            ? null
            : CustomerDetails.fromJson(json["customerDetails"]),
        itemDetails:
            (json["itemDetails"] == null || json["itemDetails"].isEmpty)
                ? null
                : List<ItemDetail?>.from(json["itemDetails"]
                    .map((x) => x == null ? null : ItemDetail.fromJson(x))),
        jobCategory: json["jobCategory"] == null
            ? null
            : JobCategory.fromJson(json["jobCategory"]),
        jobDetails: json["jobDetails"] == null
            ? null
            : JobDetails.fromJson(json["jobDetails"]),
        jobStatus: (json["jobStatus"] == null || json["jobStatus"].isEmpty)
            ? null
            : List<JobStatus?>.from(json["jobStatus"]
                .map((x) => x == null ? null : JobStatus.fromJson(x))),
        lastStatusUpdate: json["lastStatusUpdate"] == null
            ? null
            : LastStatusUpdate.fromJson(json["lastStatusUpdate"]),
      );
}

class LastStatusUpdate {
  LastStatusUpdate({
    this.lastUpdatedDate,
    this.updatedBy,
  });

  final String? lastUpdatedDate;
  final String? updatedBy;

  factory LastStatusUpdate.fromJson(Map<String, dynamic> json) =>
      LastStatusUpdate(
        lastUpdatedDate: json["last_updated_date"],
        updatedBy: json["updated_by"],
      );
}

class CustomerDetails {
  CustomerDetails({
    this.billingAddress,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
  });

  final String? billingAddress;
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? shippingAddress;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        billingAddress: json["billing_address"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerPhone: json["customer_phone"],
        shippingAddress: json["shipping_address"],
      );
}

class ItemDetail {
  ItemDetail({
    this.colorCode,
    this.title,
    this.value,
  });

  final String? colorCode;
  final String? title;
  final String? value;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        colorCode: json["color_code"],
        title: json["title"],
        value: json["value"],
      );
}

class JobCategory {
  JobCategory({
    this.gst,
    this.jobCategory,
    this.jobId,
    this.storeCode,
  });

  final String? gst;
  final String? jobCategory;
  final String? jobId;
  final String? storeCode;

  factory JobCategory.fromJson(Map<String, dynamic> json) => JobCategory(
        gst: json["gst"],
        jobCategory: json["job_category"],
        jobId: json["job_id"],
        storeCode: json["store_code"],
      );
}

class JobDetails {
  JobDetails({
    this.accessoriesReceived,
    this.accountClosed,
    this.assignedTo,
    this.complaint,
    this.contactDetails,
    this.currentCondition,
    this.expectedDelivery,
    this.jobAddedBy,
    this.jobAddedOn,
    this.updatedOn,
    this.updateBy,
  });

  final String? accessoriesReceived;
  final String? accountClosed;
  final String? assignedTo;
  final String? complaint;
  final String? contactDetails;
  final String? currentCondition;
  final String? expectedDelivery;
  final String? jobAddedBy;
  final String? jobAddedOn;
  final String? updatedOn;
  final String? updateBy;

  factory JobDetails.fromJson(Map<String, dynamic> json) => JobDetails(
        accessoriesReceived: json["accessories_recieved"],
        accountClosed: json["account_closed"],
        assignedTo: json["assigned_to"],
        complaint: json["complaint"],
        contactDetails: json["contact_details"],
        currentCondition: json["current_condition"],
        expectedDelivery: json["expected_delivery"],
        jobAddedBy: json["job_added_by"],
        jobAddedOn: json["job_added_on"],
        updatedOn: json["updated_on"],
        updateBy: json["upadate_by"],
      );
}

class JobStatus {
  JobStatus({
    this.colorCode,
    this.isActive,
    this.status,
  });

  final String? colorCode;
  final bool? isActive;
  final String? status;

  factory JobStatus.fromJson(Map<String, dynamic> json) => JobStatus(
        colorCode: json["color_code"],
        isActive: json["is_active"],
        status: json["status"],
      );
}
