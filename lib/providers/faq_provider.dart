import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/models/faq_list_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class FaqProvider extends ChangeNotifier with ProviderHelperClass {
  int totalPagesAvailable = 0;
  int currentPage = 1;

  bool paginationLoaderState = false;
  bool filterLoaderState = false;
  bool parrentIsScrolled = false;
  bool initiallyLoaded = false;
  bool queryListIsLoaded = false;

  double maxScrollExtent = 0.0;

  String? filterQuery;

  List<FaQs> faqList = [];
  List<FaQs> filteredFaqList = [];
  List<String> faqQueryList = [];

  Future<void> getFaqQueries() async {
    try {
      var resp = await serviceConfig.getFaqQueries();
      if (resp['faqCategoriesList']['faqCategories'] != null) {
        faqQueryList.clear();
        var queryList =
            resp['faqCategoriesList']['faqCategories'] as List<dynamic>;
        faqQueryList.add('All');
        for (var e in queryList) {
          String element = e['name'].toString();
          faqQueryList.add(element);
        }
        queryListIsLoaded = true;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFaqList(BuildContext context,
      {String? query, bool? all = false}) async {
    _manageLoaderState('initial');
    initiallyLoaded = true;
    try {
      var resp = await serviceConfig.getFaqLists(
          currentPage: currentPage, faqQuery: query);
      if (resp != null && resp is ApiExceptions) {
        _manageLoaderState('network_error');
      } else {
        if (!queryListIsLoaded) await getFaqQueries();
        if (resp['faqsList'] != null) {
          if (all == true) faqList.clear();
          var data = FaqListModel.fromJson(resp['faqsList']);
          if ((data.fAQs ?? []).isEmpty && query == null) {
            _manageLoaderState('no_data');
          } else {
            if (!initiallyLoaded) {
              faqList.clear();
            }
            filteredFaqList.clear();
            if (query == null) {
              faqList.addAll(data.fAQs!);
            } else {
              filteredFaqList.addAll(data.fAQs!);
            }
            totalPagesAvailable = data.pageInfo?.totalPages ?? 0;
            _manageLoaderState('success');
          }
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          _manageLoaderState('error');
        }
      }
    } catch (e) {
      _manageLoaderState('error');
    }
    log(faqList.length.toString());
  }

  void pagination(ScrollController scrollController, BuildContext context) {
    if (scrollController.position.pixels.toInt() >=
        scrollController.position.maxScrollExtent ~/ 1.3) {
      if (totalPagesAvailable > currentPage &&
          scrollController.position.maxScrollExtent.toInt() !=
              maxScrollExtent.toInt()) {
        currentPage = currentPage + 1;
        maxScrollExtent = scrollController.position.maxScrollExtent;
        if (loaderState != LoaderState.loading && !paginationLoaderState) {
          updatePaginationLoader(true);
          getFaqList(context, query: filterQuery);
        }
      }
    }
  }

  void updatePaginationLoader(bool value) {
    paginationLoaderState = value;
    notifyListeners();
  }

  void updateScrollStatus(bool value) {
    parrentIsScrolled = value;
    notifyListeners();
  }

  void updateFilterLoader(bool val) {
    filterLoaderState = val;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void _manageLoaderState(String s) {
    switch (s) {
      case 'initial':
        if (!initiallyLoaded) {
          updateLoadState(LoaderState.loading);
        }
        break;
      case 'network_error':
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
        updatePaginationLoader(false);
        break;
      case 'no_data':
        updateLoadState(LoaderState.noData);
        updatePaginationLoader(false);
        break;
      case 'success':
        updateLoadState(LoaderState.loaded);
        updatePaginationLoader(false);
        break;
      case 'error':
        updateLoadState(LoaderState.error);
        updatePaginationLoader(false);
        break;
    }
  }

  @override
  void pageInit() {
    totalPagesAvailable = 0;
    currentPage = 1;
    paginationLoaderState = false;
    filterLoaderState = false;
    parrentIsScrolled = false;
    initiallyLoaded = false;
    queryListIsLoaded = false;
    maxScrollExtent = 0.0;
    faqList.clear();
    filteredFaqList.clear();
    filterQuery = null;
    super.pageInit();
  }
}
