import 'package:hive/hive.dart';

part 'compare_products_model.g.dart';

@HiveType(typeId: 2)
class CompareProducts extends HiveObject {
  @HiveField(0)
  String? imageUrl;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? productId;
  @HiveField(3)
  int? itemIndex;
  @HiveField(4)
  int? productTypeSet;

  CompareProducts(
      {this.name,
      this.imageUrl,
      this.productId,
      this.itemIndex,
      this.productTypeSet});
}
