import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/latest_offers_data_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';
import 'package:oxygen/views/category_detailed/widgets/category_detailed_four_column_images.dart';
import 'package:oxygen/views/latest_offers/widgets/latest_offers_four_column_images.dart';
import 'package:oxygen/views/latest_offers/widgets/latest_offers_horizontal_product_list.dart';
import 'package:oxygen/views/latest_offers/widgets/latest_offers_product_offers.dart';
import 'package:oxygen/views/latest_offers/widgets/latest_offers_sliding_banner.dart';
import 'package:oxygen/views/latest_offers/widgets/latest_offers_sliding_products.dart';

class LatestOffersProvider extends ChangeNotifier with ProviderHelperClass {
  LatestOffersDataModel? latestOffersDataModel;
  List<Widget> latestOfferWidgets = [];

  Future<void> getLatestOffers(BuildContext context,
      {bool? tryAgain = false}) async {
    updateBtnLoaderState(true);
    if (!tryAgain!) updateLoadState(LoaderState.loading);

    try {
      var response = await serviceConfig.getLatestOffers();
      if (response != null && response is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        updateBtnLoaderState(false);
      } else {
        if (response['OfferpageAppCms'] != null) {
          if (response['OfferpageAppCms']['content'] != null &&
              response['OfferpageAppCms']['content'] != "[]") {
            response['OfferpageAppCms']['content'] =
                jsonDecode(response['OfferpageAppCms']['content']);
            var offerData =
                LatestOffersDataModel.fromJson(response['OfferpageAppCms']);

            updateLatestOffersData(offerData);
          } else {
            updateBtnLoaderState(false);
            updateLoadState(LoaderState.noData);
          }
        } else {
          updateBtnLoaderState(false);
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      updateBtnLoaderState(false);
      updateLoadState(LoaderState.error);
    }
  }

  void updateLatestOffersData(LatestOffersDataModel? data) {
    if (data != null) {
      latestOffersDataModel = data;
      latestOfferWidgets = [];

      for (LatestOffers? element in latestOffersDataModel?.latestOffers ?? []) {
        log(element?.blockType ?? '');
        switch (element?.blockType ?? '') {
          case 'versatile_slider':
            if ((element?.content ?? []).isNotEmpty) {
              latestOfferWidgets.add(
                LatestOffersSlidingBanner(
                  content: element?.content,
                ),
              );
            }
            continue;
          case 'owlcarosel-products':
            if ((element?.products ?? []).isNotEmpty) {
              latestOfferWidgets.add(
                LatestOffersHorizontalProductList(
                  products: element?.products,
                  title: element?.title,
                  linkId: element?.link,
                ),
              );
            }
            continue;
          case 'latest_offers_banner_block_type':
            if ((element?.content ?? []).isNotEmpty) {
              latestOfferWidgets.add(LatestOffersSlidingProducts(
                content: element?.content,
              ));
            }
            continue;
          case 'Offer_list_slider':
            if ((element?.content ?? []).isNotEmpty) {
              latestOfferWidgets.add(
                LatestOffersProductOffers(content: element?.content),
              );
            }
            continue;
          case "four_column_images":
            if ((element?.content ?? []).isNotEmpty) {
              latestOfferWidgets.add(LatestOffersFourColumnImages(
                title: element?.title,
                content: element?.content,
              ));
            }
            continue;
        }
      }
      updateBtnLoaderState(false);
      updateLoadState(LoaderState.loaded);
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  @override
  void pageDispose() {
    latestOfferWidgets.clear();
    latestOffersDataModel = null;
    super.pageDispose();
  }
}
