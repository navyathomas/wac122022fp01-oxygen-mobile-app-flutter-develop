class RecentlyViewedListResponse {
  RecentlyViewedListData? data;

  RecentlyViewedListResponse({this.data});

  RecentlyViewedListResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? RecentlyViewedListData.fromJson(json['data'])
        : null;
  }
}

class RecentlyViewedListData {
  List<GetRecentlyviewedProducts>? getRecentlyviewedProducts;

  RecentlyViewedListData({this.getRecentlyviewedProducts});

  RecentlyViewedListData.fromJson(Map<String, dynamic> json) {
    if (json['getRecentlyviewedProducts'] != null) {
      getRecentlyviewedProducts = <GetRecentlyviewedProducts>[];
      json['getRecentlyviewedProducts'].forEach((v) {
        getRecentlyviewedProducts!.add(GetRecentlyviewedProducts.fromJson(v));
      });
    }
  }
}

class GetRecentlyviewedProducts {
  String? name;
  String? sku;
  SmallImage? smallImage;

  GetRecentlyviewedProducts({this.name, this.smallImage, this.sku});

  GetRecentlyviewedProducts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sku = json['sku'];
    smallImage = json['small_image'] != null
        ? SmallImage.fromJson(json['small_image'])
        : null;
  }
}

class SmallImage {
  String? url;

  SmallImage({this.url});

  SmallImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}
