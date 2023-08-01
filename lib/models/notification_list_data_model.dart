class NotificationListDataModel {
  NotificationListDataModel({
    this.title,
    this.totalCount,
    this.items,
  });

  NotificationListDataModel.fromJson(dynamic json) {
    title = json['title'];
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(NotificationItem.fromJson(v));
      });
    }
  }

  dynamic title;
  int? totalCount;
  List<NotificationItem>? items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['total_count'] = totalCount;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NotificationItem {
  NotificationItem({
    this.name,
    this.shortDescription,
    this.date,
    this.type,
    this.linkType,
    this.linkId,
    this.incrementId,
  });

  NotificationItem.fromJson(dynamic json) {
    name = json['name'];
    shortDescription = json['short_description'];
    date = json['date'];
    type = json['type'];
    linkType = json['link_type'];
    linkId = json['link_id'];
    incrementId = json['increment_id'];
  }

  String? name;
  String? shortDescription;
  String? date;
  String? type;
  String? linkType;
  String? linkId;
  dynamic incrementId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['short_description'] = shortDescription;
    map['date'] = date;
    map['type'] = type;
    map['link_type'] = linkType;
    map['link_id'] = linkId;
    map['increment_id'] = incrementId;
    return map;
  }
}
