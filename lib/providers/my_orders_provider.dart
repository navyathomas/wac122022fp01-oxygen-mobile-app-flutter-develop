import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class MyOrdersProvider extends ChangeNotifier with ProviderHelperClass {
  int availablePageCount = 0;
  int currentPage = 1;
  bool paginationLoadState = false;
  bool initiallyLoaded = false;
  String? emailAddress;
  MyOrdersModel? myOrdersData;
  MyOrdersModel? myOfflineOrdersData;

  /// GET MY ORDER LIST
  Future<void> getMyOrdersData(
    BuildContext context, {
    bool loaderStateFlag = false,
    bool updateBtnLoadingState = false,
  }) async {
    if (!initiallyLoaded && loaderStateFlag && !updateBtnLoadingState) {
      updateLoadState(LoaderState.loading);
    } else if (updateBtnLoadingState) {
      updateBtnLoaderState(true);
    }
    initiallyLoaded = true;
    try {
      var resp = await serviceConfig.getMyOrders(
          pageSize: 10, currentPage: currentPage);
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        if (updateBtnLoadingState) updateBtnLoaderState(false);
      } else {
        if (resp['customerOrders'] != null) {
          var data = MyOrdersModel.fromJson(resp['customerOrders']);
          _manageMyOrders(data: data, updateNoData: loaderStateFlag);
        } else {
          _manageMyOrders(context: context, updateNoData: loaderStateFlag);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      updatePaginationLoadState(false);
      if (updateBtnLoadingState) updateBtnLoaderState(false);
    }
  }

  /// GET OFFLINE ORDER LIST
  Future<void> getOfflineOrdersData(BuildContext context,
      {bool updateBtnLoadingState = false}) async {
    !updateBtnLoadingState
        ? updateLoadState(LoaderState.loading)
        : updateBtnLoaderState(true);
    try {
      var resp = await serviceConfig.getOfflineOrders();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        if (updateBtnLoadingState) updateBtnLoaderState(false);
      } else {
        if (resp['customerOrdersOffline'] != null) {
          var data = MyOrdersModel.fromJson(resp['customerOrdersOffline']);
          updateOfflineOrders(data);
          if ((data.items ?? []).isEmpty) {
            updateLoadState(LoaderState.noData);
          } else {
            updateLoadState(LoaderState.loaded);
          }

          if (updateBtnLoadingState) updateBtnLoaderState(false);
        } else {
          updateLoadState(LoaderState.error);
          if (updateBtnLoadingState) updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      if (updateBtnLoadingState) updateBtnLoaderState(false);
    }
  }

  ///UPDATE OFFLINE ORDERS
  void updateOfflineOrders(MyOrdersModel? model) {
    myOfflineOrdersData = model;
    notifyListeners();
  }

  /// PROCESS MY ORDERS DATA
  void _manageMyOrders({
    BuildContext? context,
    MyOrdersModel? data,
    dynamic resp,
    bool updateNoData = false,
    bool updateBtnLoadingState = false,
  }) {
    if (data != null) {
      availablePageCount = data.pageInfo?.totalPages ?? 0;
      if ((data.items ?? []).isNotEmpty) {
        if (currentPage == 1) {
          myOrdersData = null;
          myOrdersData = data;
        } else {
          myOrdersData!.copyWith(model: data);
        }
        updateLoadState(LoaderState.loaded);
        updatePaginationLoadState(false);
        if (updateBtnLoadingState) updateBtnLoaderState(true);
      } else {
        if (updateNoData) updateLoadState(LoaderState.noData);
        updatePaginationLoadState(false);
        if (updateBtnLoadingState) updateBtnLoaderState(true);
      }
    } else {
      ErrorModel errorModel = ErrorModel.fromJson(resp);
      if (errorModel.message != null) {
        CommonFunctions.afterInit(
            () => Helpers.flushToast(context!, msg: errorModel.message!));
      }
      updateLoadState(LoaderState.error);
      updatePaginationLoadState(false);
      if (updateBtnLoadingState) updateBtnLoaderState(true);
    }
  }

  /// PAGINATION
  void pagination(
      BuildContext context, ScrollController scrollController) async {
    if (scrollController.position.pixels.toInt() >=
        scrollController.position.maxScrollExtent ~/ 1.3) {
      if (myOrdersData?.pageInfo?.totalPages != null &&
          currentPage < myOrdersData!.pageInfo!.totalPages! &&
          loaderState != LoaderState.loading &&
          !paginationLoadState) {
        currentPage = currentPage + 1;
        updatePaginationLoadState(true);
        await getMyOrdersData(context, loaderStateFlag: false);
      }
    }
  }

  void updatePaginationLoadState(bool value) {
    paginationLoadState = value;
    notifyListeners();
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
    availablePageCount = 0;
    currentPage = 1;
    myOrdersData = null;
    paginationLoadState = false;
    initiallyLoaded = false;
    btnLoaderState = false;
    super.pageDispose();
  }

  /// JOIN PRODUCTS NAMES
  String? getGroupedProductNames(List<Products>? products) {
    if (products != null) {
      String groupedProductName =
          products.map((Products? e) => e?.orderDetails?.name).join(', ');
      return groupedProductName;
    }
    return null;
  }

  String? reFormatCurrentStatusDate(String? string) {
    String pattern = r'^\w\w\w\s\d\d\-\d\d\d\d$';
    RegExp regExp = RegExp(pattern);
    String? returnString;
    if (string != null) {
      if (regExp.hasMatch(string)) {
        var split = string.split(' ');
        var month = split[0];
        var dateSplit = split[1].split('-');
        var date = dateSplit[0];
        var year = dateSplit[1];
        var formatedMonth = _getMonth(month);
        if (formatedMonth != '-1') {
          var formattedString = '$year-$formatedMonth-$date 00:00:00';
          DateTime dateTime = DateTime.parse(formattedString);
          returnString = DateFormat('EEE, dd MMM yyyy').format(dateTime);
        }
      }
    }
    return returnString;
  }

  String _getMonth(String monthData) {
    switch (monthData.toLowerCase()) {
      case 'jan':
        return '01';
      case 'feb':
        return '02';
      case 'mar':
        return '03';
      case 'apr':
        return '04';
      case 'may':
        return '05';
      case 'jun':
        return '06';
      case 'jul':
        return '07';
      case 'aug':
        return '08';
      case 'sep':
        return '09';
      case 'oct':
        return '10';
      case 'nov':
        return '11';
      case 'dec':
        return '12';
      default:
        return '-1';
    }
  }

  Future<void> setEmailAddress() async {
    var userData = await HiveServices.instance.getUserData();
    emailAddress = userData?.email;
  }
}

extension DecodeJsonString on String {
  Map<String, dynamic> getJson() {
    return jsonDecode(this);
  }
}
