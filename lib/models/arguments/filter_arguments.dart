import 'package:flutter/cupertino.dart';

import '../../providers/product_listing_provider.dart';

class FilterArguments {
  final ProductListingProvider productListingProvider;
  final BuildContext context;
  final String categoryId;
  final ScrollController scrollController;

  FilterArguments(
      {required this.productListingProvider,
      required this.context,
      required this.categoryId,
      required this.scrollController});
}
