import 'package:oxygen/models/service_request_response.dart';

class ServiceRequestDemoResponse {
  ServiceRequestDemoData? data;

  ServiceRequestDemoResponse({this.data});

  ServiceRequestDemoResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? ServiceRequestDemoData.fromJson(json['data'])
        : null;
  }
}

class ServiceRequestDemoData {
  GetServiceRequestDataWeb? getServiceRequestDataWeb;

  ServiceRequestDemoData({this.getServiceRequestDataWeb});

  ServiceRequestDemoData.fromJson(Map<String, dynamic> json) {
    getServiceRequestDataWeb = json['getServiceRequestDataWeb'] != null
        ? GetServiceRequestDataWeb.fromJson(json['getServiceRequestDataWeb'])
        : null;
  }
}

class GetServiceRequestDataWeb {
  List<ServiceRequestDemoValue>? formData;
  String? productName;

  GetServiceRequestDataWeb({this.formData, this.productName});

  GetServiceRequestDataWeb.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      formData = <ServiceRequestDemoValue>[];
      json['data'].forEach((v) {
        formData!.add(ServiceRequestDemoValue.fromJson(v));
      });
    }
    productName = json['product_name'];
  }
}

class ServiceRequestDemoValue {
  List<ServiceRequestValueData>? data;
  String? label;
  String? title;
  String? type;

  ServiceRequestDemoValue({this.data, this.label, this.title, this.type});

  ServiceRequestDemoValue.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServiceRequestValueData>[];
      json['data'].forEach((v) {
        data!.add(ServiceRequestValueData.fromJson(v));
      });
    }
    label = json['label'];
    title = json['title'];
    type = json['type'];
  }
}

class Data {
  bool? isSelected;
  String? label;
  String? value;

  Data({this.isSelected, this.label, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    isSelected = json['is_selected'];
    label = json['label'];
    value = json['value'];
  }
}
