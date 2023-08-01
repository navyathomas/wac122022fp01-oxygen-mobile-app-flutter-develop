import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/job_status_detail_model.dart';
import 'package:oxygen/services/helpers.dart';

import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class TrackJobsDetailProvider extends ChangeNotifier with ProviderHelperClass {
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

  JobStatusData? jobStatusData;

  Future<void> getJobStatusDetails({String? jobId}) async {
    if (enableLoaderState) {
      updateLoadState(LoaderState.loading);
    }
    try {
      var resp = await serviceConfig.getJobStatusDetails(jobId: jobId ?? "");
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        if (enableLoaderState) {
          updateLoadState(LoaderState.networkErr);
        }
      } else {
        if (resp != null) {
          jobStatusData = JobStatusData.fromJson(resp);
          notifyListeners();
          if (enableLoaderState) {
            updateLoadState(LoaderState.loaded);
          }
        } else {
          if (enableLoaderState) {
            updateLoadState(LoaderState.noData);
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
