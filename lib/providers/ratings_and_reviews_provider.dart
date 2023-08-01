import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/reviews_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class RatingsAndReviewsProvider extends ChangeNotifier
    with ProviderHelperClass {
  bool _disposed = false;
  bool enableLoaderState = false;

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

  /* *** Reviews *** */
  ReviewsData? initialReviewsData;
  List<ProductReviewsItem?>? reviewList;
  ProductsItem? reviewsProductItem;
  int? reviewsCurrentPage;
  int? reviewsTotalPage;
  int reviewsPageCount = 1;
  bool reviewsPaginationEnabled = false;

  updateReviewsModel(value) {
    initialReviewsData = ReviewsData.fromJson(value);
    reviewsProductItem = initialReviewsData?.products?.items?.elementAt(0);
    reviewsCurrentPage = reviewsProductItem?.reviews?.pageInfo?.currentPage;
    reviewsTotalPage = reviewsProductItem?.reviews?.pageInfo?.totalPages;
    if (reviewsProductItem != null) {
      if (reviewList == null) {
        reviewList = reviewsProductItem?.reviews?.items;
        reviewsPageCount = reviewsPageCount + 1;
        if (enableLoaderState) {
          if (reviewList?.isEmpty ?? true) {
            updateLoadState(LoaderState.noData);
          } else {
            updateLoadState(LoaderState.loaded);
          }
        }
      } else if (reviewList != null &&
          reviewsProductItem?.reviews?.items != null &&
          (reviewsProductItem?.reviews?.items?.isNotEmpty ?? false)) {
        reviewList = [...?reviewList, ...?reviewsProductItem?.reviews?.items];
        reviewsPageCount = reviewsPageCount + 1;
        if (enableLoaderState) {
          if (reviewList?.isEmpty ?? true) {
            updateLoadState(LoaderState.noData);
          } else {
            updateLoadState(LoaderState.loaded);
          }
        }
      }
    }
    notifyListeners();
  }

  /* *** Reviews *** */

  Future<void> getReviews(BuildContext context, String sku,
      {int pageNo = 1}) async {
    reviewsPaginationEnabled = true;
    if (enableLoaderState) {
      updateLoadState(LoaderState.loading);
    }
    notifyListeners();
    try {
      var resp = await serviceConfig.getReviews(sku: sku, pageNo: pageNo);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        reviewsPaginationEnabled = false;
        if (enableLoaderState) {
          updateLoadState(LoaderState.networkErr);
        }
        notifyListeners();
      } else {
        if (resp != null && resp['products'] != null) {
          updateReviewsModel(resp);
          reviewsPaginationEnabled = false;
          notifyListeners();
        } else {
          reviewsPaginationEnabled = false;
          if (enableLoaderState) {
            updateLoadState(LoaderState.noData);
          }
          notifyListeners();
        }
      }
    } catch (e) {
      reviewsPaginationEnabled = false;
      if (enableLoaderState) {
        updateLoadState(LoaderState.error);
      }
      notifyListeners();
    }
  }
}
