import 'package:hive/hive.dart';

part 'local_products.g.dart';

@HiveType(typeId: 0)
class LocalProducts extends HiveObject {
  @HiveField(1)
  String? sku;
  @HiveField(2)
  int quantity = 0;
  @HiveField(3)
  int? cartItemId;
  @HiveField(4)
  bool isFavourite = false;
  @HiveField(5)
  int? itemId;
  @HiveField(6)
  int? cartPlanId;

  LocalProducts(
      {this.sku = '',
      this.quantity = 0,
      this.cartItemId,
      this.isFavourite = false,
      this.itemId,
      this.cartPlanId});
}
