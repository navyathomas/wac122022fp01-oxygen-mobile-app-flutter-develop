import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/service_listing_model.dart';
import 'package:oxygen/models/track_jobs_listing_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class TrackJobsProvider extends ChangeNotifier with ProviderHelperClass {
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

  bool enableLoaderState = false;

  List<ServiceList?>? serviceList;
  List<TrackJobsList?>? trackJobsList;

  Future<void> getServiceList() async {
    if (enableLoaderState) {
      updateLoadState(LoaderState.loading);
    }
    try {
      var resp = await serviceConfig.getServiceList();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        if (enableLoaderState) {
          updateLoadState(LoaderState.networkErr);
        }
      } else {
        if (resp["servicelisting"] != null) {
          ServiceListingData? data = ServiceListingData.fromJson(resp);
          if (data.serviceListing?.isEmpty ?? true) {
            if (enableLoaderState) {
              updateLoadState(LoaderState.noData);
            }
          } else {
            serviceList = data.serviceListing;
            notifyListeners();
            if (enableLoaderState) {
              updateLoadState(LoaderState.loaded);
            }
          }
        } else {
          if (enableLoaderState) {
            updateLoadState(LoaderState.error);
          }
        }
      }
    } catch (e) {
      if (enableLoaderState) {
        updateLoadState(LoaderState.error);
      }
    }
  }

  Future<void> getTrackJobList() async {
    if (enableLoaderState) {
      updateLoadState(LoaderState.loading);
    }
    try {
      var resp = await serviceConfig.getTrackJobList();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        if (enableLoaderState) {
          updateLoadState(LoaderState.networkErr);
        }
      } else {
        if (resp["customer"] != null) {
          TrackJobsData? data = TrackJobsData.fromJson(resp);
          if (data.customer?.trackJobsList?.isEmpty ?? true) {
            if (enableLoaderState) {
              updateLoadState(LoaderState.noData);
            }
          } else {
            trackJobsList = data.customer?.trackJobsList;
            notifyListeners();
            if (enableLoaderState) {
              updateLoadState(LoaderState.loaded);
            }
          }
        }
      }
    } catch (e) {
      if (enableLoaderState) {
        updateLoadState(LoaderState.error);
      }
    }
  }
}
