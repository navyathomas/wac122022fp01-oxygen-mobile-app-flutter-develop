import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/loyalty_point_model.dart';
import 'package:oxygen/services/provider_helper_class.dart';

import '../services/helpers.dart';
import '../services/service_config.dart';

class LoyaltyProvider extends ChangeNotifier with ProviderHelperClass {
  WacLoyaltyProductPoint? loyaltyProductPoint;
  WacLoyaltyBillPoint? loyaltyBillPoint;
  int? totalRewards;

  LoaderState billPointLoadState = LoaderState.loaded;

  Future<void> getLoyaltyProductPoints() async {
    updateLoadState(LoaderState.loading);
    try {
      var response = await serviceConfig.getLoyaltyProductPoints();
      if (response != null && response is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
      } else {
        if (response['WacLoyalityProduct'] != null) {
          WacLoyaltyProductPoint loyaltyProductModel =
              WacLoyaltyProductPoint.fromJson(response);
          loyaltyProductPoint = loyaltyProductModel;
          if ((loyaltyProductPoint?.wacLoyaltyPoint ?? []).isEmpty) {
            updateLoadState(LoaderState.noData);
          } else {
            updateLoadState(LoaderState.loaded);
          }
        } else {
          updateLoadState(LoaderState.noData);
        }
      }
    } catch (_) {
      updateLoadState(LoaderState.error);
    }
  }

  Future<void> getLoyaltyBillPoints() async {
    updateBillLoadState(LoaderState.loading);
    try {
      var response = await serviceConfig.getLoyaltyBillPoints();
      if (response != null && response is ApiExceptions) {
        updateBillLoadState(LoaderState.networkErr);
      } else {
        if (response['WacLoyalityBilling'] != null) {
          WacLoyaltyBillPoint loyaltyBillModel =
              WacLoyaltyBillPoint.fromJson(response);
          loyaltyBillPoint = loyaltyBillModel;
          if ((loyaltyBillPoint?.wacLoyaltyPoint ?? []).isEmpty) {
            updateBillLoadState(LoaderState.noData);
          } else {
            updateBillLoadState(LoaderState.loaded);
          }
        } else {
          updateBillLoadState(LoaderState.noData);
        }
      }
    } catch (_) {
      updateBillLoadState(LoaderState.error);
    }
  }

  Future<void> getLoyaltyTotalPoints() async {
    try {
      var response = await serviceConfig.getTotalLoyaltyPoint();
      if (response != null && response is ApiExceptions) {
        return;
      } else {
        if (response != null && response["customer"] != null) {
          totalRewards = Helpers.convertToInt(
              response["customer"]["total_rewards"],
              defValue: 00);
          notifyListeners();
        } else {
          totalRewards = 00;
          notifyListeners();
        }
      }
    } catch (_) {
      totalRewards = 00;
      notifyListeners();
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateBillLoadState(LoaderState state) {
    billPointLoadState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    loyaltyProductPoint = null;
    loyaltyBillPoint = null;
    notifyListeners();
    super.dispose();
  }
}
