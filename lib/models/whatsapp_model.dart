class WhatsappModel {
  final bool? configStatus;
  final String? mobileNumber;

  WhatsappModel({
    this.configStatus,
    this.mobileNumber,
  });

  factory WhatsappModel.fromJson(Map<String, dynamic> json) => WhatsappModel(
        configStatus: json["config_status"],
        mobileNumber: json["mobilenumber"],
      );
}
