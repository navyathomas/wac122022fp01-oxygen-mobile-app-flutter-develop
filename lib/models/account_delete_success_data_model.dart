class AccountDeleteSuccessDataModel {
  AccountDeleteSuccessDataModel({
    this.status,
    this.message,
    this.reason,
    this.comment,
  });

  AccountDeleteSuccessDataModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    reason = json['reason'];
    comment = json['comment'];
  }

  bool? status;
  String? message;
  String? reason;
  String? comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['reason'] = reason;
    map['comment'] = comment;
    return map;
  }
}
