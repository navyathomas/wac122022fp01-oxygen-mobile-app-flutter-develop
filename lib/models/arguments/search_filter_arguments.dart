import 'package:flutter/cupertino.dart';

import '../../providers/search_product_listing_provider.dart';
import '../../providers/search_provider.dart';

class SearchFilterArguments {
  final ScrollController scrollController;
  final SearchProductListingProvider searchProductListingProvider;
  final SearchProvider? searchProvider;

  SearchFilterArguments(
      {required this.scrollController,
      required this.searchProductListingProvider,
      this.searchProvider});
}
