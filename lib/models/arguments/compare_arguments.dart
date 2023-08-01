import 'package:oxygen/providers/product_listing_provider.dart';

import '../../providers/search_product_listing_provider.dart';

class CompareArguments {
  final ProductListingProvider? productListingProvider;
  final SearchProductListingProvider? searchProductListingProvider;
  final bool? isFromSearch;

  CompareArguments(
      {this.productListingProvider,
      this.searchProductListingProvider,
      this.isFromSearch});
}
