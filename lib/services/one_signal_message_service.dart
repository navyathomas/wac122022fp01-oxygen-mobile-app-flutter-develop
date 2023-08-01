import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oxygen/providers/notification_list_provider.dart';

class NotificationServices {
  static NotificationServices? _instance;

  static NotificationServices get instance {
    _instance ??= NotificationServices();
    return _instance!;
  }

  oneSignalInitialization(BuildContext context) async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("231077e1-e645-4110-a4d4-8c93bb155c79");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notifi`cation prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) async {
      debugPrint('Notification Recieved');
      event.complete(event.notification);
    });

    // OneSignal.shared.

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      debugPrint('Notification Opened ${result.notification.additionalData}');
      await NotificationListProvider()
          .handleNotificationTap(context, result.notification.additionalData);
      await NotificationListProvider().subtractNotificationCount();
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }
}
