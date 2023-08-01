import 'package:flutter/foundation.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/aggregation_list_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';

import '../models/compare_products_model.dart';
import '../models/search_response_model.dart';
import '../services/helpers.dart';
import '../services/service_config.dart';

class SearchProductListingProvider extends ChangeNotifier
    with ProviderHelperClass {
  int pageCount = 1;
  int length = 24;
  int totalPageLength = 0;
  bool paginationLoader = false;
  ProductData? productListingResponse;
  List<Item> productItems = [];
  AggregationData? aggregationResponse;
  List<Aggregations> aggregationsList = [];
  List<AggregateOptions> aggregateOptionsList = [];
  int selectedAggregationTab = 0;
  Map<String, dynamic> tempFilterMap = {};
  Map<String, dynamic> filterMap = {};
  List valueList = [];
  List<AggregateOptions> priceValueList = [];
  List<SortOptions> sortOptionsList = [];
  int sortOrderIndex = 0;
  String? sortOrderValue;
  String? sortDirection;
  Map<String, dynamic> sortMap = {};
  bool isListView = true;
  List<CompareProducts> compareProductsList = [];
  String errorMessage = '';
  bool isRemoveCompareBottomTab = true;
  bool productRemoveLoader = false;
  bool isCompareTapped = false;
  bool _disposed = false;

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

  getSearchProductDetails(String product,
      {Function? onSuccess, bool enableLoaderState = true}) async {
    if (enableLoaderState) updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getSearchProductDetails(
          pageCount, length, product, filterMap, sortMap);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        if (enableLoaderState) updateLoadState(LoaderState.loaded);
        paginationLoader = false;
      } else {
        debugPrint('search product listing  response $resp');
        productListingResponse = ProductData.fromJson(resp);
        if (productListingResponse != null) {
          updateSearchProductDetails(productListingResponse!);
        }
        if (onSuccess != null) onSuccess();
        if ((productListingResponse?.products?.items ?? []).isEmpty) {
          if (enableLoaderState) updateLoadState(LoaderState.noProducts);
        } else {
          if (enableLoaderState) updateLoadState(LoaderState.loaded);
        }
        paginationLoader = false;
      }
    } catch (e) {
      'Search product $e'.log(name: 'ProductListingProvider');
      if (enableLoaderState) updateLoadState(LoaderState.loaded);
      paginationLoader = false;
    }
    notifyListeners();
  }

  loadMoreSearchProductDetails(String product) {
    if (totalPageLength > pageCount && !paginationLoader) {
      paginationLoader = true;
      pageCount = pageCount + 1;
      getSearchProductDetails(product, enableLoaderState: false);
      notifyListeners();
    }
  }

  updateSearchProductDetails(ProductData productData) {
    if (pageCount == 1) {
      productItems.clear();
      productItems = productData.products?.items ?? [];
    } else {
      List<Item> tempProductItems = [...productItems];
      productItems = [
        ...tempProductItems,
        ...productData.products?.items ?? []
      ];
    }
    totalPageLength = ((productData.products?.totalCount ?? 24) / 24).ceil();
    for (var element in productItems) {
      for (var elements in compareProductsList) {
        if (elements.productId == element.id.toString()) {
          element.isAddedToCompare = true;
        }
      }
    }
    notifyListeners();
  }

  Future<void> getAggregationsList(String product) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp =
          await serviceConfig.getSearchAggregationsList(product, filterMap);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.loaded);
        paginationLoader = false;
      } else {
        aggregationResponse = AggregationData.fromJson(resp);
        if (sortOptionsList.isEmpty) {
          updateSortOptions(aggregationResponse?.products?.sortFields);
        }
        if ((aggregationResponse?.products?.aggregations).notEmpty) {
          aggregationsList.clear();
          aggregationsList = aggregationResponse?.products?.aggregations ?? [];
          updatePriceValueList(aggregationsList);
        }
      }
    } catch (e) {
      'Aggregations list $e'.log(name: 'ProductListingProvider');
      updateLoadState(LoaderState.loaded);
      paginationLoader = false;
    }
    notifyListeners();
  }

  updateAggregationOptionsList(int index) {
    if (aggregationsList.notEmpty) {
      aggregateOptionsList = aggregationsList[index].options ?? [];
    }

    notifyListeners();
  }

  updateSelectedAggregationTab(int index) {
    selectedAggregationTab = index;
    updateAggregationOptionsList(index);
    updateOptionValuesList();
    //updateTempMap();
    notifyListeners();
  }

  updateTempMap() {
    tempFilterMap.addAll({
      'category': ['1', '2', '3']
    });
    tempFilterMap.addAll({'price': 'below 1000'});
    Map temp = {...tempFilterMap};
    List tempList = [...temp['category']];
    tempList.addAll(['4', '5', '6']);
    temp.addAll({
      'category': ['4', '5', '6']
    });
    tempFilterMap['category'] = tempList;

    // tempFilterMap = {...temp};
  }

  assignValuesToTempFilterMap(String aggregationKey, var optionsValues) {
    if (tempFilterMap.isNotEmpty) {
      if (tempFilterMap.containsKey(aggregationKey)) {
        if (aggregationKey == 'price' || aggregationKey == 'discount') {
          List idList = [...tempFilterMap[aggregationKey]];
          if (idList.notEmpty) {
            if (idList[0] != optionsValues) {
              idList.add(optionsValues);
            }
            idList.removeAt(0);
          } else {
            idList.add(optionsValues);
          }
          if (idList.notEmpty) {
            tempFilterMap[aggregationKey] = idList;
          } else {
            tempFilterMap.remove(aggregationKey);
          }
        } else {
          List idList = [...tempFilterMap[aggregationKey]];
          if (idList.contains(optionsValues)) {
            if (idList.length == 1) {
              tempFilterMap.remove(aggregationKey);
            } else {
              idList.remove(optionsValues);
              tempFilterMap[aggregationKey] = idList;
            }
          } else {
            idList.add(optionsValues);
            tempFilterMap[aggregationKey] = idList;
          }
        }
      } else {
        tempFilterMap[aggregationKey] = [optionsValues];
      }
    } else {
      tempFilterMap[aggregationKey] = [optionsValues];
    }
    debugPrint('temp filter map $tempFilterMap');
  }

  updateOptionValuesList() {
    valueList = tempFilterMap.isNotEmpty
        ? tempFilterMap[
                aggregationsList[selectedAggregationTab].attributeCode] ??
            []
        : [];
  }

  updatePriceValueList(List<Aggregations> aggregationList) {
    for (int i = 0; i < aggregationList.length; i++) {
      if (aggregationList[i].attributeCode == 'price') {
        if (aggregationList[i].options.notEmpty) {
          priceValueList.clear();
          for (int j = 0; j < aggregationList[i].options!.length; j++) {
            if (j == 0) {
              priceValueList.add(AggregateOptions(
                  label: aggregationList[i].options?[j].label,
                  value: '0,${aggregationList[i].options?[j].value}'));
            } else if (j == aggregationList[i].options!.length - 1) {
              priceValueList.add(AggregateOptions(
                  label:
                      '${aggregationList[i].options?[j - 1].value} - ${aggregationList[i].options?[j].value}',
                  value:
                      '${aggregationList[i].options?[j - 1].value},${aggregationList[i].options?[j].value}'));
              priceValueList.add(AggregateOptions(
                  label: aggregationList[i].options?[j].label,
                  value: '${aggregationList[i].options?[j].value},0'));
            } else {
              priceValueList.add(AggregateOptions(
                  label:
                      '${aggregationList[i].options?[j - 1].value} - ${aggregationList[i].options?[j].value}',
                  value:
                      '${aggregationList[i].options?[j - 1].value},${aggregationList[i].options?[j].value}'));
            }
          }
          // for (var element in priceValueList) {
          //   debugPrint('price value list ${element.label}');
          // }
        }
      }
    }
    notifyListeners();
  }

  assignValuesToFilterMap() {
    filterMap.clear();
    // selectedAggregationTab = 0;
    if (tempFilterMap.isNotEmpty) {
      tempFilterMap.forEach((key, value) {
        List<String> priceIdList = [];
        String tempPriceValue = value[0];

        if (key == 'price') {
          priceIdList = tempPriceValue.split(',');
        } else if (key == 'discount') {
          priceIdList = tempPriceValue.split('_');
        }
        filterMap.addAll({
          key: key == 'price'
              ? {
                  priceIdList[0] != '0' && priceIdList[1] != '0'
                      ? 'from:${"\"${priceIdList[0]}\""},to:${"\"${priceIdList[1]}\""}'
                      : priceIdList[0] == '0'
                          ? 'to:${"\"${priceIdList[1]}\""}'
                          : 'from:${"\"${priceIdList[0]}\""}'
                }
              : key == 'discount'
                  ? {
                      'from:${"\"${priceIdList[0]}\""},to:${"\"${priceIdList[1]}\""}'
                    }
                  : {'in: [${value.map((e) => "\"$e\"").join(', ')}]'}
        });
      });
    }
    updateOptionValuesList();
  }

  Future<void> updateSortOptions(SortFields? sortFields) async {
    if (sortFields != null) {
      sortOrderValue = sortFields.defaultSortValue ?? '';
      sortDirection = sortFields.defaultDirection ?? '';
      assignValuesToSortMap();
      if ((sortFields.options).notEmpty) {
        sortOptionsList = sortFields.options ?? [];
      }
    }
  }

  getSortOrderIndex(String sortValue, String direction) {
    if (sortOptionsList.notEmpty) {
      for (int i = 0; i < sortOptionsList.length; i++) {
        if (sortValue == sortOptionsList[i].value &&
            direction == sortOptionsList[i].sortDirection) {
          updateSortValuesIndex(i);
        }
      }
    }
  }

  updateSortValuesIndex(int index) {
    sortOrderIndex = index;
    sortOrderValue = sortOptionsList[index].value ?? '';
    sortDirection = sortOptionsList[index].sortDirection ?? '';
    notifyListeners();
  }

  assignValuesToSortMap() {
    sortMap = {sortOrderValue ?? '': sortDirection ?? ''};
    notifyListeners();
  }

  updateIsProductRemovedFromCompare(bool value) {
    productRemoveLoader = value;
    notifyListeners();
  }

  updateIsCompareTapped(bool value) {
    isCompareTapped = value;
    notifyListeners();
  }

  changeView() {
    isListView = !isListView;
    notifyListeners();
  }

  clearFilterMap({bool isFromSearch = false, bool isFromSort = true}) {
    tempFilterMap.clear();
    filterMap.clear();
    valueList.clear();
    if (isFromSort) sortOptionsList.clear();
    if (isFromSearch) priceValueList.clear();
    notifyListeners();
  }

  clearPageLoader() {
    pageCount = 1;
    length = 24;
    totalPageLength = 0;
    paginationLoader = false;
    productItems.clear();
    selectedAggregationTab = 0;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
