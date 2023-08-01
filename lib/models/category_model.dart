import 'dart:convert';

class CategoryDataModel {
  List<CategoryData>? categoryData;

  CategoryDataModel({this.categoryData});

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      categoryData = <CategoryData>[];
      jsonDecode(json['content']).forEach((v) {
        if (v is Map<String, dynamic>) {
          categoryData!.add(CategoryData.fromJson(v));
        }
      });
    }
  }
}

class CategoryData {
  String? title;
  String? blockType;
  List<CategoryContent>? content;
  int? blockId;

  CategoryData({this.title, this.blockType, this.content, this.blockId});

  CategoryData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    blockType = json['block_type'];
    if (json['content'] != null) {
      content = <CategoryContent>[];
      json['content'].forEach((v) {
        content!.add(CategoryContent.fromJson(v));
      });
    }
    blockId = json['block_id'];
  }
}

class CategoryContent {
  String? id;
  String? name;
  String? image;
  String? shareUrl;

  CategoryContent({this.id, this.name, this.image, this.shareUrl});

  CategoryContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    shareUrl = json['share_url'];
  }
}
