import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_four_column_images.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_four_images_background.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_latest_offers_banner.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_owl_carousel_products.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_price_based_classification.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_six_column_images_with_bg.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_top_category.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_versatile_slider.dart';

class CategoryDetailedProvider extends ChangeNotifier with ProviderHelperClass {
  bool _disposed = false;

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

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

  CategoryDetailedModel? categoryDetailedModel;
  List<Widget> categoryDetailedWidgets = [];

  bool loaderStateEnabled = true;

  Future<void> getCategoryDetailed(BuildContext context,
      {String? type, bool loaderStateEnabled = true}) async {
    this.loaderStateEnabled = loaderStateEnabled;
    if (this.loaderStateEnabled) {
      updateLoadState(LoaderState.loading);
    }
    try {
      var resp = await serviceConfig.getCategoryDetailed(type: type ?? "");
      debugPrint(resp.toString());
      if (resp != null && resp is ApiExceptions) {
        if (this.loaderStateEnabled) {
          updateLoadState(LoaderState.networkErr);
        }
      } else {
        if (resp?['categoryDetailedPageCms'] != null) {
          CategoryDetailedModel categoryDetailedModel =
              CategoryDetailedModel.fromJson(resp["categoryDetailedPageCms"]);
          updateCategoryDetailedModelData(categoryDetailedModel);
        }
      }
    } catch (_) {
      if (this.loaderStateEnabled) {
        updateLoadState(LoaderState.error);
      }
    }
  }

  void updateCategoryDetailedModelData(CategoryDetailedModel? data) {
    categoryDetailedModel = data;
    categoryDetailedWidgets = [];
    if (categoryDetailedModel?.categoryData?.isEmpty ?? true) {
      if (loaderStateEnabled) {
        updateLoadState(LoaderState.noData);
      }
    } else {
      for (CategoryData? element in categoryDetailedModel?.categoryData ?? []) {
        switch (element?.blockType ?? '') {
          case "top-category-detail-page":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets
                  .add(CategoryDetailedTopCategory(content: element?.content));
            }
            continue;

          case "versatile_slider":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets.add(
                  CategoryDetailedVersatileSlider(content: element?.content));
            }
            continue;

          case "four_column_images":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets.add(CategoryDetailedFourColumnImages(
                title: element?.title,
                titleColor: element?.titleColor,
                content: element?.content,
              ));
            }
            continue;

          case "latest_offers_banner_block_type":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets.add(CategoryDetailedLatestOffersBanner(
                content: element?.content,
              ));
            }
            continue;

          case "owlcarosel-products":
            if ((element?.products ?? []).isNotEmpty) {
              categoryDetailedWidgets.add(CategoryDetailedOwlCarouselProducts(
                title: element?.title,
                titleColor: element?.titleColor,
                products: element?.products,
                linkId: element?.link,
              ));
            }
            continue;

          case "four_column_images_background_image":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets
                  .add(CategoryDetailedFourColumnImagesBackground(
                title: element?.title,
                titleColor: element?.titleColor,
                backgroundImage: element?.backgroundImage,
                content: element?.content,
              ));
            }
            continue;

          case "six_column_image":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets.add(CategoryDetailedSixColumnImagesWithBg(
                title: element?.title,
                titleColor: element?.titleColor,
                backgroundImage: element?.backgroundImage,
                content: element?.content,
              ));
            }
            continue;
          case "price_based_classification":
            if ((element?.content ?? []).isNotEmpty) {
              categoryDetailedWidgets
                  .add(CategoryDetailedPriceBasedClassification(
                title: element?.title,
                titleColor: element?.titleColor,
                content: element?.content,
              ));
              continue;
            }
        }
      }
      if (loaderStateEnabled) {
        updateLoadState(LoaderState.loaded);
      }
    }
  }
}
