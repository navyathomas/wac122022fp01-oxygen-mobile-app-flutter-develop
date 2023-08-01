import 'dart:async';
import 'dart:developer' as devTool;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/compare_products_model.dart';
import 'package:oxygen/models/mobile_force_update_model.dart';
import 'package:oxygen/providers/app_data_provider.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/repositories/app_data_repo.dart';
import 'package:oxygen/repositories/authentication_repo.dart';
import 'package:oxygen/repositories/bajaj_emi_repo.dart';
import 'package:oxygen/repositories/compare_repo.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/shared_preference_helper.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common_function.dart';
import '../../common/constants.dart';
import '../../services/app_config.dart';
import '../../services/gql_client.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';
import '../../widgets/custom_alert_dialog.dart';

class SplashHandler {
  static const platform = MethodChannel('com.oxygendigitalshop.app');
  static SplashHandler? _instance;

  static SplashHandler get instance {
    _instance ??= SplashHandler();
    return _instance!;
  }

  String forceUpdateRoute = 'force_update';

  List<CompareProducts> localCompareProductList = [];

  Future<void> checkNetworkStat(
      BuildContext context, bool mounted, AnimationController ctrl) async {
    final network = await Helpers.isInternetAvailable(enableToast: false);
    if (network) {
      if (!mounted) return;
      _fetchInitialData(context, mounted, ctrl);
      //_fetchCompareListData();
      if (Platform.isAndroid) await _updateNotificationCount();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Expanded(
                child: Text(Constants.noNetworkDesc,
                    style: FontPalette.primary13Regular),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  onPressed: () async {
                    final network =
                        await Helpers.isInternetAvailable(enableToast: false);
                    if (network) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _fetchInitialData(context, mounted, ctrl);
                    }
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: ColorPalette.primaryColor,
                  ))
            ],
          ),
          duration: const Duration(days: 1),
          backgroundColor: Colors.white,
        ));
      }
    }
  }

  void _fetchInitialData(
      BuildContext context, bool mounted, AnimationController ctrl) {
    GraphQLClientConfiguration.instance
        .config(initial: true)
        .then((bool value) async {
      if (value) {
        await HiveServices.instance.deleteNavPath();
        if (mounted) await checkForceUpdate(context, mounted, ctrl);
        CommonFunctions.afterInit(() {
          context.read<AppDataProvider>().getWhatsappChatConfiguration();
        });
      }
    });
  }

  Future<void> _checkLoginStat(
      BuildContext context, bool mounted, AnimationController ctrl) async {
    SharedPreferencesHelper.getLoginStatus().then((value) async {
      if (value) {
        devTool.log("logged in", name: 'SPLASH');
        _fetchCartId(context, mounted, ctrl);
      } else {
        devTool.log("not logged in", name: 'SPLASH');
        if (mounted) {
          context.read<AuthProvider>().getCartId().then((value) async {
            await AppDataRepo.getCartData();
            await HiveServices.instance.clearWishListProductBox();
            await _getCompareProduct();
            ctrl.forward();
            ctrl.addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed && mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.routeAuthScreen, (route) => false);
              }
            });
          });
        }
      }
    });
  }

  Future<void> _fetchCartId(
      BuildContext context, bool mounted, AnimationController ctrl) async {
    String cartId = await context.read<AuthProvider>().getCartId();
    if (cartId.isNotEmpty) {
      devTool.log(cartId, name: 'CART ID');
      final userToken = await SharedPreferencesHelper.getAuthToken();
      if (userToken.isNotEmpty) AppConfig.accessToken = "Bearer $userToken";
      await AuthenticationRepo.validateRefreshToken();
      await BajajEmiRepo.unsetBajajEmiDetails();
      await AppDataRepo.getAppData();
      await _getCompareProduct();
      ctrl.forward();
      ctrl.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.routeMainScreen, (route) => false);
        }
      });
    } else {
      await AuthenticationRepo.getEmptyCart();
      await BajajEmiRepo.unsetBajajEmiDetails();
      await AppDataRepo.getAppData();
      await _getCompareProduct();
      ctrl.forward();
      ctrl.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.routeAuthScreen, (route) => false);
        }
      });
    }
  }

  _getCompareProduct() async {
    await CompareRepo.getCompareProducts();
  }

  Future<void> checkForceUpdate(
      BuildContext context, bool mounted, AnimationController ctrl) async {
    if (mounted) {
      await _checkForceUpdate(context, onUpdate: (bool val) {
        Navigator.popUntil(context, (route) {
          if (route.settings.name != forceUpdateRoute) {
            showUpdateAlert(context, forceUpdate: val, onCancel: (bool val) {
              _checkLoginStat(context, mounted, ctrl);
            }, onUpdate: (bool val) {
              Navigator.pop(context);
              CommonFunctions.launchAppStore();
            });
          }
          return true;
        });
      }, onContinue: (bool val) {
        _checkLoginStat(context, mounted, ctrl);
      });
    }
  }

  Future<void> _checkForceUpdate(BuildContext context,
      {required Function(bool) onUpdate,
      required Function(bool) onContinue}) async {
    UpdateState state = await context.read<AppDataProvider>().checkAppUpdate();
    state == UpdateState.showForceUpdate ? onUpdate(true) : onContinue(true);
  }

  Future<void> _updateNotificationCount() async {
    SharedPreferencesHelper.getLoginStatus().then((value) async {
      if (value) {
        final prefs = await SharedPreferences.getInstance();
        final countFromPref = prefs.getInt('oxygenNotificationCount');
        final countFromHive =
            await HiveServices.instance.getNotificationCount();
        await HiveServices.instance
            .saveNotificationCount((countFromPref ?? 0) + (countFromHive ?? 0));
      }
    });
    try {
      await platform.invokeMethod('Oxygen#Notifications');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void showUpdateAlert(BuildContext context,
      {bool forceUpdate = false,
      required Function(bool) onCancel,
      required Function(bool) onUpdate}) {
    CommonFunctions.showDialogPopUp(
        context,
        CustomAlertDialog(
          title: Constants.appUpdateAvailable,
          message: Constants.plsUpdateForBetter,
          actionButtonText: Constants.update,
          cancelButtonText: Constants.mayBeLater,
          height: forceUpdate ? 200.h : 275.h,
          enableCloseBtn: false,
          disableCancelBtn: forceUpdate,
          onActionButtonPressed: () async {
            onUpdate(true);
          },
          onCancelButtonPressed: () async {
            Navigator.pop(context);
            onCancel(true);
          },
          isLoading: false,
        ),
        routeName: forceUpdateRoute,
        barrierDismissible: false);
  }
}
