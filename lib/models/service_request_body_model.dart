class ServiceRequestBody {
  String? categoryType;
  String? brand;
  String? model;
  String? issueDescription;
  List<dynamic>? addPhotoList;
  String? serviceRequestType;
  String? selectDistrict;
  String? store;
  String? productFrom;
  String? title;
  String? pickupAddress;
  String? serialNumber;
  String? warranty;
  ServiceRequestBody(
      {this.categoryType,
      this.brand,
      this.model,
      this.issueDescription,
      this.addPhotoList,
      this.serviceRequestType,
      this.selectDistrict,
      this.store,
      this.productFrom,
      this.title,
      this.pickupAddress,
      this.serialNumber,
      this.warranty});
}
