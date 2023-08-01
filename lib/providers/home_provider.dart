import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/home_data_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_banner_grid_tile.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_categories.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_emi_slider.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_grid_menu.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_header_banner.dart';
import 'package:oxygen/views/main_screen/home/widgets/home_single_banner.dart';

import '../services/service_config.dart';
import '../views/main_screen/home/widgets/home_banner_slider.dart';
import '../views/main_screen/home/widgets/home_grid_banners.dart';
import '../views/main_screen/home/widgets/home_horizontal_product_list.dart';

class HomeProvider extends ChangeNotifier with ProviderHelperClass {
  HomeDataModel? homeDataModel;
  List<Widget> homeWidgets = [];

  Future<void> getHomeData(BuildContext context,
      {bool enableLoader = true}) async {
    if (enableLoader) updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getHomeData();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp?['homepageAppCms'] != null) {
          HomeDataModel homeDataModel =
              HomeDataModel.fromJson(resp['homepageAppCms']);
          updateHomeModelData(homeDataModel);
        } else {
          updateLoadState(LoaderState.error);
        }
      }
    } catch (_) {
      updateLoadState(LoaderState.error);
    }
  }

  void updateHomeModelData(HomeDataModel? data) {
    homeDataModel = data;
    homeWidgets = [];
    List<HomeData> homeData = homeDataModel?.homeData ?? [];
    if (homeData.isEmpty) {
      loaderState = LoaderState.noData;
      notifyListeners();
    } else {
      for (HomeData? element in homeData) {
        switch (element?.blockType ?? '') {
          case 'versatile_slider':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeHeaderBanner(
                contentData: element?.content,
              ));
            }
            continue;

          case 'available_emi':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeEmiSlider(
                contentData: element?.content,
              ));
            }
            continue;

          case 'tracking_section_block':
            homeWidgets.add(const HomeGridMenu());
            continue;

          case 'top_catgories_block':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeCategories(
                contentData: element?.content,
              ));
            }
            continue;

          case 'owlcarosel-products':
            if ((element?.products ?? []).isNotEmpty) {
              homeWidgets.add(HomeHorizontalProductList(
                title: element?.title ?? '',
                linkId: element?.link ?? '',
                products: element?.products,
              ));
            }
            continue;

          case 'four_column_images':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeGridTile(
                title: element?.title ?? '',
                linkId: element?.link ?? '',
                contentData: element?.content,
              ));
            }
            continue;

          case 'latest_offers_banner_block_type':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeBannerSlider(
                contentData: element?.content,
              ));
            }
            continue;

          case 'single_image_banner_full_width':
            if (element?.imageUrl != null) {
              homeWidgets.add(HomeSingleBanner(
                imageUrl: element?.imageUrl,
                onTap: (BuildContext context) {
                  NavRoutes.instance.navByType(context, element?.linkType,
                      element?.linkId, element?.categoryDetail);
                },
              ));
            }
            continue;

          case 'single_image_banner':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeSingleBanner(
                onTap: (BuildContext context) {},
              ));
            }
            continue;

          case 'four_image_grid':
            if ((element?.content ?? []).isNotEmpty) {
              homeWidgets.add(HomeBannerGridTile(
                homeData: element,
                linkId: element?.link ?? '',
              ));
            }
            continue;
        }
      }
      loaderState = LoaderState.loaded;
      notifyListeners();
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
