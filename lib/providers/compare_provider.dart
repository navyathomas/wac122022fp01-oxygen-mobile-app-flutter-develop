import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';

import '../models/compare_products_response_model.dart';
import '../models/error_model.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import '../services/service_config.dart';

class CompareProvider extends ChangeNotifier with ProviderHelperClass {
  String errorMessage = '';
  CompareProductsData? compareProductsData;
  List<GetCompareProducts> compareProductList = [];
  List comparableAttributeList = [];
  List comparableAttributeValueList = [];
  List<ListValueModel> listValueModelList = [];
  Map<String, dynamic> tempFilterMap = {};
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

  getCompareProductDetails({Function? onSuccess, Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getCompareProductsDetails();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp['getCompareProducts'] != null) {
          compareProductsData = CompareProductsData.fromJson(resp);

          if (compareProductsData != null) {
            //updateTempMap();
            updateCompareProductList(compareProductsData);
          }
          if (onSuccess != null) onSuccess();
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
            updateLoadState(LoaderState.loaded);
          }
        }
      }
    } catch (e) {
      'Search product $e'.log(name: 'ProductListingProvider');
      updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

  updateTempMap() {
    tempFilterMap.addAll({
      'category': [
        ['1', '2', '3']
      ]
    });
    tempFilterMap.addAll({'price': 'below 1000'});
    Map temp = {...tempFilterMap};
    List tempList = [...temp['category']];
    tempList.addAll([
      ['4', '5', '6']
    ]);
    temp.addAll({
      'category': ['4', '5', '6']
    });
    tempFilterMap['category'] = tempList;
    debugPrint('tempfilter map $tempFilterMap}');
    // tempFilterMap = {...temp};
  }

  updateCompareProductList(CompareProductsData? compareProductsData) {
    compareProductList.clear();
    compareProductList = compareProductsData?.getCompareProducts ?? [];
    if (compareProductList.length > 3) {
      compareProductList = [...compareProductList.getRange(0, 3)];
    }
    int length = compareProductList.length;
    for (int i = 0; i < length; i++) {
      comparableAttributeList
          .add(compareProductList[i].comparableAttributes?.attributeList ?? []);
    }

    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
