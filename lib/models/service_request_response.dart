class ServiceRequestResponse {
  ServiceRequestData? data;
  ServiceRequestResponse({this.data});
  ServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? ServiceRequestData.fromJson(json['data']) : null;
  }
}

class ServiceRequestData {
  List<GetServiceRequestData>? getServiceRequestData;
  ServiceRequestData({this.getServiceRequestData});
  ServiceRequestData.fromJson(Map<String, dynamic> json) {
    if (json['getServiceRequestData'] != null) {
      getServiceRequestData = <GetServiceRequestData>[];
      json['getServiceRequestData'].forEach((v) {
        getServiceRequestData!.add(GetServiceRequestData.fromJson(v));
      });
    }
  }
}

class GetServiceRequestData {
  List<ServiceRequestValueData>? data;
  String? label;
  String? type;
  GetServiceRequestData({this.data, this.label, this.type});
  GetServiceRequestData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServiceRequestValueData>[];
      json['data'].forEach((v) {
        data!.add(ServiceRequestValueData.fromJson(v));
      });
    }
    label = json['label'];
    type = json['type'];
  }
}

class ServiceRequestValueData {
  bool? isSelected;
  String? label;
  String? value;
  ServiceRequestValueData({this.isSelected, this.label, this.value});
  ServiceRequestValueData.fromJson(Map<String, dynamic> json) {
    isSelected = json['is_selected'];
    label = json['label'];
    value = json['value'];
  }
}
