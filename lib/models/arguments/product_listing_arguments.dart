import 'package:oxygen/models/category_detailed_model.dart';

import '../../providers/search_provider.dart';

class ProductListingArguments {
  final bool? isFromSearch;
  final String? categoryId;
  final String? title;
  final FilterPrice? filterPrice;
  final SearchProvider? searchProvider;
  final String? attribute;
  final String? attributeType;
  final String? filterType;
  ProductListingArguments(
      {this.isFromSearch,
      this.categoryId,
      this.title,
      this.filterPrice,
      this.searchProvider,
      this.attribute,
      this.filterType,
      this.attributeType});
}
