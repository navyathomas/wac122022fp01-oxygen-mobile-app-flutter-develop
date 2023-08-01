import 'package:flutter/widgets.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/models/recently_viewed_list_response.dart';
import 'package:oxygen/models/search_response_model.dart';
import 'package:oxygen/models/trending_search_response.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';

import '../models/category_model.dart';
import '../services/helpers.dart';
import '../services/service_config.dart';

class SearchProvider extends ChangeNotifier with ProviderHelperClass {
  bool isBottomInsects = false;
  int pageCount = 1;
  int length = 10;
  String? productItem;
  String? sku;
  ProductData? searchProductResponse;
  List<Item> searchProductItems = [];
  RecentlyViewedListData? recentlyViewedListResponse;
  List<GetRecentlyviewedProducts>? getRecentlyViewedProductsList;
  List<dynamic> recentlySearchedList = [];
  List<CategoryContent> popularCategoriesList = [];
  TextEditingController searchController = TextEditingController();
  LoaderState searchLoadState = LoaderState.loaded;
  List<String> trendingSearchList = [];
  bool _disposed = false;
  bool isFromSearchProductListing = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> searchProduct(String product) async {
    updateSearchLoader(LoaderState.loading);
    productItem = product;
    try {
      var resp = await serviceConfig.searchProduct(pageCount, length, product);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateSearchLoader(LoaderState.noData);
      } else {
        searchProductResponse = ProductData.fromJson(resp);
        searchProductItems = searchProductResponse?.products?.items ?? [];
        if ((searchProductResponse?.products?.items ?? []).isNotEmpty) {
          updateSearchLoader(LoaderState.loaded);
        } else {
          updateSearchLoader(LoaderState.noData);
        }
      }
    } catch (e) {
      'Search product $e'.log(name: 'SearchProvider');
      updateSearchLoader(LoaderState.loaded);
    }
    notifyListeners();
  }

  void getRecentlySearchedKeys() async {
    // updateLoadState(LoaderState.loading);
    recentlySearchedList =
        await HiveServices.instance.getRecentlySearchedKeys();
    // await HiveServices.instance.closeRecentlySearchedBox();
    debugPrint('recently searched list $recentlySearchedList');
    //updateLoadState(LoaderState.loaded);
    notifyListeners();
  }

  void addRecentlySearchedKeys(String key, String sku) async {
    String value = '';
    if (!recentlySearchedList.contains(key)) {
      await HiveServices.instance.addRecentlySearchedKeys(key, sku);
    } else {
      for (int i = 0; i < recentlySearchedList.length; i++) {
        if (key == recentlySearchedList[i]) {
          value = recentlySearchedList[i];
          break;
        }
      }
      deleteKeyFromRecentlySearchedList(value, false);
      await HiveServices.instance.addRecentlySearchedKeys(key, sku);
    }
    notifyListeners();
  }

  void deleteKeyFromRecentlySearchedList(String value, bool isFromClose) {
    HiveServices.instance.deleteItemFromRecentlySearchedList(value);
    if (isFromClose) {
      getRecentlySearchedKeys();
    }
  }

  void updateSearchProduct(String product) {
    productItem = product;
    notifyListeners();
  }

  clearSearchProductList() {
    searchProductItems = [];
    debugPrint('search product items length ${searchProductItems.length}');
    notifyListeners();
  }

  Future<void> getRecentlyViewedProducts() async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getRecentlyViewedProducts();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        recentlyViewedListResponse = RecentlyViewedListData.fromJson(resp);
        getRecentlyViewedProductsList =
            recentlyViewedListResponse?.getRecentlyviewedProducts ?? [];
        updateLoadState(LoaderState.loaded);
      }
    } catch (e) {
      'Get recently viewed products $e'.log(name: 'SearchProvider');
      updateLoadState(LoaderState.loaded);
    }
  }

  Future<void> getSearchCategories() async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getSearchCategories();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.loaded);
      } else {
        CategoryDataModel categoryDataModel =
            CategoryDataModel.fromJson(resp['getMobileAppSearchPageData']);
        for (CategoryData? element in categoryDataModel.categoryData ?? []) {
          popularCategoriesList = element?.content ?? [];
        }
        updateLoadState(LoaderState.loaded);
      }
    } catch (e) {
      'Get search categories $e'.log(name: 'SearchProvider');
      updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

  Future<void> getTrendSearchList() async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getTrendingSearches();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.loaded);
      } else {
        TrendingSearchModel trendingSearchModel =
            TrendingSearchModel.fromJson(resp['getMobileAppSearchPageData']);
        for (TrendingSearchResponse? element
            in trendingSearchModel.trendingSearchResponse ?? []) {
          debugPrint('search key word ${element?.searchKeywords}');
          trendingSearchList = element?.searchKeywords ?? [];
        }
        updateLoadState(LoaderState.loaded);
      }
    } catch (e) {
      'Get search categories $e'.log(name: 'SearchProvider');
      updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

  void updateSearchInput(String value) {
    productItem = value;
    if (value.isNotEmpty) {
      searchProduct(value);
    } else {
      searchProductItems = [];
    }
    notifyListeners();
  }

  updateSku(String value) {
    sku = value;
    notifyListeners();
  }

  updateIsFromSearchProductListingScreen(bool value) {
    isFromSearchProductListing = value;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateSearchLoader(LoaderState state) {
    searchLoadState = state;
    notifyListeners();
  }

  @override
  void pageInit() {
    searchLoadState = LoaderState.loaded;
    productItem = null;
    searchProductItems = [];
    super.pageInit();
  }
}
