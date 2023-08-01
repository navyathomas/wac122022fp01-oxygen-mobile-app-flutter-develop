import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/custom_scroll_behaviour.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/notification_method_channel.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:provider/provider.dart';

import 'common/multi_provider_list.dart';
import 'common/route_generator.dart';
import 'firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await HiveServices.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  NotificationMethodChannel.instance.configureChannel();
  runZonedGuarded(() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'Oxygen Digital',
              scrollBehavior: const CustomScrollBehaviour(),
              debugShowCheckedModeBanner: false,
              theme: ColorPalette.themeData,
              onGenerateRoute: RouteGenerator.instance.generateRoute,
            );
          }),
    );
  }
}
