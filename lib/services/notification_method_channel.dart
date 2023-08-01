import 'package:flutter/services.dart';
import 'package:oxygen/providers/notification_list_provider.dart';
import 'package:oxygen/services/app_config.dart';

class NotificationMethodChannel {
  static const channelName = 'Oxygen#Notifications';
  late MethodChannel methodChannel;

  static final NotificationMethodChannel instance =
      NotificationMethodChannel._init();

  NotificationMethodChannel._init();

  void configureChannel() {
    methodChannel = const MethodChannel(channelName);
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case "Oxygen#Notifications":
        if (AppConfig.isAuthorized) {
          await NotificationListProvider().addNotificationCount();
        }
        break;
      default:
        throw MissingPluginException();
    }
  }
}
