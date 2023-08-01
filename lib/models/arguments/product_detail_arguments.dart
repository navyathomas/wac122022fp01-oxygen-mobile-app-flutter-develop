import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/models/emi_plans_model.dart';
import 'package:oxygen/models/product_detail_model.dart';

import '../../providers/search_provider.dart';

class ProductDetailsArguments {
  final String? sku;
  final String? identifier;
  final bool? isFromSearch;
  final Item? item;
  final bool isFromInitialState;
  final SearchProvider? searchProvider;
  final EmiPlansData? emiPlans;
  final Future<void> Function()? onRefresh;
  final BajajEmiDetails? bajajEmiDetails;

  ProductDetailsArguments(
      {this.sku,
      this.identifier,
      this.isFromSearch,
      this.item,
      this.isFromInitialState = false,
      this.searchProvider,
      this.emiPlans,
      this.onRefresh,
      this.bajajEmiDetails});
}
