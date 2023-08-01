import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/notification_list_data_model.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class NotificationListProvider extends ChangeNotifier with ProviderHelperClass {
  NotificationListDataModel? notificationListDataModel;

  Future<void> getNotificationList({bool retry = false}) async {
    try {
      if (!retry) {
        updateLoadState(LoaderState.loading);
      } else {
        updateBtnLoaderState(true);
      }
      var resp = await serviceConfig.getNotificationList();
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        updateBtnLoaderState(false);
      } else {
        if (resp['wacNotificationsList'] != null) {
          log(resp.toString());
          notificationListDataModel =
              NotificationListDataModel.fromJson(resp['wacNotificationsList']);
          if (notificationListDataModel?.items != null &&
              (notificationListDataModel?.items ?? []).isNotEmpty) {
            updateLoadState(LoaderState.loaded);
            updateBtnLoaderState(false);
          } else {
            updateLoadState(LoaderState.noData);
            updateBtnLoaderState(false);
          }
        } else {
          updateLoadState(LoaderState.error);
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      updateBtnLoaderState(false);
      log(e.toString());
    }
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

  /// Hnadle notifications
  Future<void> addNotificationCount() async {
    int? nCount = await HiveServices.instance.getNotificationCount();
    if (nCount != null) {
      await HiveServices.instance.saveNotificationCount(nCount + 1);
      log('Notification count ${nCount + 1}');
    } else {
      await HiveServices.instance.saveNotificationCount(1);
    }
  }

  Future<void> subtractNotificationCount() async {
    int? nCount = await HiveServices.instance.getNotificationCount();
    if (nCount != null) {
      await HiveServices.instance.saveNotificationCount(nCount - 1);
    }
  }

  Future<void> clearNotificationCount() async {
    await HiveServices.instance.saveNotificationCount(0);
    OneSignal.shared.clearOneSignalNotifications();
  }

  Future<void> handleNotificationTap(
      BuildContext context, Map<String, dynamic>? additionalData) async {
    log(additionalData.toString());
    if (additionalData != null) {
      log(additionalData['link_type']);
      switch (additionalData['link_type']) {
        case 'product':
          NavRoutes.instance.navByType(
            context,
            additionalData['link_type'],
            additionalData['link_id'],
            '',
          );
          break;
        case 'category':
          NavRoutes.instance.navByType(
            context,
            additionalData['link_type'],
            additionalData['link_id'],
            '',
          );
          break;
        case 'category-detail':
          NavRoutes.instance.navByType(
            context,
            additionalData['link_type'],
            additionalData['link_id'],
            '',
          );
          break;
        case 'order':
          Navigator.pushNamed(context, RouteGenerator.routeMyOrdersScreen);
          break;
      }
    }
  }
}
