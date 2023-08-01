import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/category_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';

import '../services/helpers.dart';
import '../services/service_config.dart';

class CategoryProvider extends ChangeNotifier with ProviderHelperClass {
  List<CategoryContent> popularCategoriesList = [];
  List<CategoryContent> allCategoriesList = [];

  Future<void> getCategoryPageData() async {
    allCategoriesList = [];
    popularCategoriesList = [];
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getCategoryPageData();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        CategoryDataModel categoryDataModel =
            CategoryDataModel.fromJson(resp['getCategoryPageData']);
        updateCategoryPageData(categoryDataModel);
      }
    } catch (e) {
      'Get category page data  $e'.log(name: 'Category provider');
      updateLoadState(LoaderState.loaded);
    }
  }

  updateCategoryPageData(CategoryDataModel? categoryDataModel) {
    for (CategoryData? element in categoryDataModel?.categoryData ?? []) {
      switch (element?.title ?? '') {
        case 'Popular Categories':
          popularCategoriesList = element?.content ?? [];
          continue;
        case 'All Categories':
          allCategoriesList = element?.content ?? [];
      }
    }
    if (allCategoriesList.isEmpty) {
      updateLoadState(LoaderState.noData);
    } else {
      updateLoadState(LoaderState.loaded);
    }

    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
