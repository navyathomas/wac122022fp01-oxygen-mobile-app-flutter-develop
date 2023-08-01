import 'dart:convert';

class TrendingSearchModel {
  List<TrendingSearchResponse>? trendingSearchResponse;

  TrendingSearchModel({this.trendingSearchResponse});

  TrendingSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      trendingSearchResponse = <TrendingSearchResponse>[];
      jsonDecode(json['content']).forEach((v) {
        if (v is Map<String, dynamic>) {
          trendingSearchResponse!.add(TrendingSearchResponse.fromJson(v));
        }
      });
    }
  }
}

class TrendingSearchResponse {
  String? blockType;
  String? title;
  List<String>? searchKeywords;
  int? blockId;

  TrendingSearchResponse(
      {this.blockType, this.title, this.searchKeywords, this.blockId});

  TrendingSearchResponse.fromJson(Map<String, dynamic> json) {
    blockType = json['block_type'];
    title = json['title'];
    searchKeywords = json['search_keywords'].cast<String>();
    blockId = json['block_id'];
  }
}
