class WacLoyaltyProductPoint {
  List<WacLoyaltyPoint>? wacLoyaltyPoint;

  WacLoyaltyProductPoint({this.wacLoyaltyPoint});

  WacLoyaltyProductPoint.fromJson(Map<String, dynamic> json) {
    if (json['WacLoyalityProduct'] != null) {
      wacLoyaltyPoint = <WacLoyaltyPoint>[];
      json['WacLoyalityProduct'].forEach((v) {
        wacLoyaltyPoint!.add(WacLoyaltyPoint.fromJson(v));
      });
    }
  }
}

class WacLoyaltyBillPoint {
  List<WacLoyaltyPoint>? wacLoyaltyPoint;

  WacLoyaltyBillPoint({this.wacLoyaltyPoint});

  WacLoyaltyBillPoint.fromJson(Map<String, dynamic> json) {
    if (json['WacLoyalityBilling'] != null) {
      wacLoyaltyPoint = <WacLoyaltyPoint>[];
      json['WacLoyalityBilling'].forEach((v) {
        wacLoyaltyPoint!.add(WacLoyaltyPoint.fromJson(v));
      });
    }
  }
}

class WacLoyaltyPoint {
  String? createdAt;
  bool? credited;
  String? label;
  int? points;

  WacLoyaltyPoint({this.createdAt, this.credited, this.label, this.points});

  WacLoyaltyPoint.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    credited = json['credited'];
    label = json['label'];
    points = json['points'];
  }
}
