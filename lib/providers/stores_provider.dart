import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/stores_data_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class StoresProvider extends ChangeNotifier with ProviderHelperClass {
  int totalPagesAvailable = 0;
  int totalCount = 0;
  int currentPage = 1;
  bool paginationLoading = false;
  double maxScrollExtent = 0.0;
  bool initiallyLoaded = false;
  bool parrentSrolled = false;
  bool districtIsLoaded = false;
  bool filterIsLoading = false;

  List<StoresDataModel> storesList = [];
  List<StoresDataModel> filteredList = [];
  List<String> districtList = [];

  late ScrollController scrollController;

  Future<void> loadDistrictList() async {
    try {
      var resp = await serviceConfig.getDistrictList();
      if (resp['getDistricts'] != null) {
        districtList.clear();
        var districtData = resp['getDistricts'] as List<dynamic>;
        districtList.add(Constants.allLocations);
        for (var e in districtData) {
          String element = e.toString();
          districtList.add(element);
        }
        districtIsLoaded = true;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getStoresList(BuildContext context,
      {String? location,
      bool? allLocations,
      bool? tryAgainFromFailed = false,
      bool updateNoDataState = false}) async {
    if (!initiallyLoaded && !tryAgainFromFailed!) {
      updateLoadState(LoaderState.loading);
    } else if (tryAgainFromFailed!) {
      updateBtnLoaderState(true);
    }
    filteredList.clear();
    initiallyLoaded = true;
    try {
      if (!districtIsLoaded && !tryAgainFromFailed) await loadDistrictList();
      var resp = await serviceConfig.getStores(
          pageSize: 10, currentPage: currentPage, district: location);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        updatePaginationLoader(false);
        updateBtnLoaderState(false);
      } else {
        if (resp['storePage'] != null) {
          if (allLocations == true) storesList.clear();
          var storeData =
              jsonDecode(resp['storePage']['stores']) as List<dynamic>;
          if (storeData.isNotEmpty) {
            for (int i = 0; i < storeData.length; i++) {
              StoresDataModel model = StoresDataModel.fromJson(storeData[i]);
              if (location != null) {
                filteredList.add(model);
              } else {
                storesList.add(model);
              }
            }
            currentPage = resp['storePage']['page_info']['current_page'];
            totalPagesAvailable = resp['storePage']['page_info']['total_pages'];
            updateLoadState(LoaderState.loaded);
            updatePaginationLoader(false);
            updateBtnLoaderState(false);
          } else {
            if (updateNoDataState) updateLoadState(LoaderState.noData);
          }
          updatePaginationLoader(false);
          updateBtnLoaderState(false);
          log(storesList.length.toString());
        } else {
          updateLoadState(LoaderState.error);
          updateBtnLoaderState(false);
          updatePaginationLoader(false);
        }
      }
    } catch (e) {
      log(e.toString());
      updatePaginationLoader(false);
      updateBtnLoaderState(false);
    }
  }

  @override
  void pageInit() {
    scrollController = ScrollController();
    totalPagesAvailable = 0;
    totalCount = 0;
    currentPage = 1;
    paginationLoading = false;
    maxScrollExtent = 0.0;
    initiallyLoaded = false;
    districtIsLoaded = false;
    storesList.clear();
    super.pageInit();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    paginationLoading = false;
    notifyListeners();
  }

  void updatePaginationLoader(bool val) {
    paginationLoading = val;
    notifyListeners();
  }

  void updateScroll(bool value) {
    parrentSrolled = value;
    notifyListeners();
  }

  void updateFilterLoading(bool val) {
    filterIsLoading = val;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  void pagination(BuildContext context, ScrollController scrollController,
      {Key? key}) {
    if (scrollController.position.pixels.toInt() >=
        scrollController.position.maxScrollExtent ~/ 1.3) {
      if (totalPagesAvailable > currentPage &&
          scrollController.position.maxScrollExtent.toInt() !=
              maxScrollExtent.toInt()) {
        currentPage = currentPage + 1;
        maxScrollExtent = scrollController.position.maxScrollExtent;
        if (loaderState != LoaderState.loading && !paginationLoading) {
          updatePaginationLoader(true);
          getStoresList(context, updateNoDataState: false);
        }
      }
    }
  }
}
