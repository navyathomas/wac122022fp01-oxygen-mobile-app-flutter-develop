import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/main_screen/account/widgets/account_screen_header.dart';
import 'package:oxygen/views/main_screen/account/widgets/account_tile_widget.dart';
import 'package:oxygen/widgets/custom_alert_dialog.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_data_provider.dart';
import '../../../utils/font_palette.dart';

class AccountScreen extends StatefulWidget {
  final Function(int) onTabSwitch;

  const AccountScreen({Key? key, required this.onTabSwitch}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with WidgetsBindingObserver {
  ValueNotifier<bool> isUserLoggedIn = ValueNotifier<bool>(false);

  @override
  void initState() {
    _setUserAuthenticatedValue();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        context.read<AppDataProvider>().checkAppUpdate();
      }
    }
  }

  void _setUserAuthenticatedValue() {
    setState(() {
      isUserLoggedIn.value = AppConfig.isAuthorized;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#FFFFFF'),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white,
            statusBarBrightness:
                Platform.isIOS ? Brightness.light : Brightness.dark),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder<Box>(
              valueListenable:
                  Hive.box(HiveServices.instance.generalBoxName).listenable(),
              builder: (_, box, ___) {
                return AccountScreenHeader(
                  isAuthorized: isUserLoggedIn.value,
                  customer: box.get(HiveServices.instance.authUserData),
                  onClick: _profileNavigation,
                );
              },
            ),
            Divider(
              height: 5.h,
              thickness: 5.h,
              color: HexColor('#F3F3F7'),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: isUserLoggedIn,
                builder: (_, __, ___) {
                  var list = isUserLoggedIn.value
                      ? authAccountTileList
                      : nonAuthAccountTileList;
                  return CustomSlidingFadeAnimation(
                    onlyFadeAnimation: true,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const _UpdateAlertContainer(),
                          ...List.generate(
                              isUserLoggedIn.value
                                  ? authAccountTileList.length
                                  : nonAuthAccountTileList.length,
                              (index) => AccountTileWidget(
                                    title: list[index].title,
                                    icon: list[index].icon,
                                    loginButton: list[index].isLoginButton,
                                    notificationTile:
                                        list[index].notificationTile,
                                    first: index == 0 ? true : false,
                                    onClick: () {
                                      if (list[index].isLoginButton!) {
                                        HiveServices.instance.saveNavArgs(0);
                                        Navigator.pushNamed(context,
                                                RouteGenerator.routeAuthScreen,
                                                arguments: true)
                                            .then((_) async {
                                          _setUserAuthenticatedValue();
                                          setState(() {});
                                        });
                                      } else {
                                        if (list[index].route == "logout") {
                                          onLogoutTap();
                                        } else {
                                          Navigator.pushNamed(
                                              context,
                                              list[index].route ??
                                                  RouteGenerator.routeError);
                                        }
                                      }
                                    },
                                  ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final authAccountTileList = <AccountScreenTileItem>[
    AccountScreenTileItem(
      title: Constants.myOrders,
      icon: Assets.iconsMyOrder,
      route: RouteGenerator.routeMyOrdersScreen,
    ),
    AccountScreenTileItem(
      title: Constants.latestOffers,
      icon: Assets.iconsLatestOffers,
      route: RouteGenerator.routeLatestOffersScreen,
    ),
    AccountScreenTileItem(
      title: Constants.address,
      icon: Assets.iconsLocationPin,
      route: RouteGenerator.routeSavedAddressScreen,
    ),
    AccountScreenTileItem(
      title: Constants.stores,
      icon: Assets.iconsStores,
      route: RouteGenerator.routeStoresScreen,
    ),
    AccountScreenTileItem(
        title: Constants.notifications,
        icon: Assets.iconsNotifications,
        route: RouteGenerator.routeNotificationScreen,
        notificationTile: true),
    // AccountScreenTileItem(
    //   title: Constants.trackJobs,
    //   icon: Assets.iconsTrackJobs,
    // ),
    AccountScreenTileItem(
      title: Constants.contactUs,
      icon: Assets.iconsContactusPhone,
      route: RouteGenerator.routeContactUsScreen,
    ),
    AccountScreenTileItem(
        title: Constants.loyalty,
        icon: Assets.iconsLoyaltyBadge,
        route: RouteGenerator.routeLoyaltyScreen),
    AccountScreenTileItem(
      title: Constants.serviceTracking,
      icon: Assets.iconsServiceTrackingBlack,
      route: RouteGenerator.routeTrackJobScreen,
    ),
    AccountScreenTileItem(
      title: Constants.serviceRequest,
      icon: Assets.iconsServiceRequest,
      route: RouteGenerator.routeServiceRequest,

    ),
    AccountScreenTileItem(
      title: Constants.leaveFeedback,
      icon: Assets.iconsFeedback,
      route: RouteGenerator.routeLeaveFeedbackSceen,
    ),
    AccountScreenTileItem(
      title: Constants.helpAndFaqs,
      icon: Assets.iconsHelpAndFaq,
      route: RouteGenerator.routeFaqAndHelpScreen,
    ),
    AccountScreenTileItem(
      title: Constants.termsAndConditions,
      icon: Assets.iconsTermsAndCondition,
      route: RouteGenerator.routeTermsAndConditionScreen,
    ),
    AccountScreenTileItem(
      title: Constants.privacyPolicy,
      icon: Assets.iconsPrivacyPolicy,
      route: RouteGenerator.routePrivacyPolicyScreen,
    ),
    AccountScreenTileItem(
        title: Constants.logout, icon: Assets.iconsLogout, route: "logout"),
  ];

  final nonAuthAccountTileList = <AccountScreenTileItem>[
    AccountScreenTileItem(
      title: Constants.signupOrLogin,
      isLoginButton: true,
      icon: '',
      route: '',
    ),
    AccountScreenTileItem(
      title: Constants.latestOffers,
      icon: Assets.iconsLatestOffers,
      route: RouteGenerator.routeLatestOffersScreen,
    ),

    AccountScreenTileItem(
      title: Constants.stores,
      icon: Assets.iconsStores,
      route: RouteGenerator.routeStoresScreen,
    ),
    // AccountScreenTileItem(
    //   title: Constants.trackJobs,
    //   icon: Assets.iconsTrackJobs,
    // ),
    AccountScreenTileItem(
      title: Constants.contactUs,
      icon: Assets.iconsContactusPhone,
      route: RouteGenerator.routeContactUsScreen,
    ),

    AccountScreenTileItem(
      title: Constants.helpAndFaqs,
      icon: Assets.iconsHelpAndFaq,
      route: RouteGenerator.routeFaqAndHelpScreen,
    ),
    AccountScreenTileItem(
      title: Constants.termsAndConditions,
      icon: Assets.iconsTermsAndCondition,
      route: RouteGenerator.routeTermsAndConditionScreen,
    ),
    AccountScreenTileItem(
      title: Constants.privacyPolicy,
      icon: Assets.iconsPrivacyPolicy,
      route: RouteGenerator.routePrivacyPolicyScreen,
    ),
  ];

  void _profileNavigation() async {
    if (isUserLoggedIn.value) {
      await Navigator.pushNamed(context, RouteGenerator.routeMyProfileScreen);
    }
  }

  void onLogoutTap() {
    CommonFunctions.showDialogPopUp(
        context,
        Selector<AuthProvider, bool>(
          selector: (context, provider) => provider.btnLoaderState,
          builder: (context, value, child) {
            return CustomAlertDialog(
              title: Constants.areUSure,
              message: Constants.doUWantToLogout,
              actionButtonText: Constants.logout.toUpperCase(),
              cancelButtonText: Constants.cancel.toUpperCase(),
              onActionButtonPressed: () {
                context.read<AuthProvider>().logoutUser(
                    onResponse: (val) async {
                  if (val) {
                    await HiveServices.instance.clearBoxData();
                    await HiveServices.instance.clearRecentlySearchedList();
                    if (mounted) Navigator.pop(context);
                    widget.onTabSwitch(0);
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
              onCancelButtonPressed: () {
                Navigator.pop(context);
              },
              isLoading: value,
            );
          },
        ),
        barrierDismissible: false);
  }
}

class AccountScreenTileItem {
  final bool? isLoginButton;
  final String title;
  final String icon;
  final String? route;
  final bool? notificationTile;

  AccountScreenTileItem({
    this.isLoginButton = false,
    required this.title,
    required this.icon,
    this.route,
    this.notificationTile = false,
  });
}

class _UpdateAlertContainer extends StatelessWidget {
  const _UpdateAlertContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataProvider, bool>(
      selector: (context, provider) => provider.enableAppUpdateTile,
      builder: (context, value, child) {
        if (!value) return const SizedBox.shrink();
        return ColoredBox(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                color: HexColor('#E6E6E6').withOpacity(0.5),
                border: Border.all(color: HexColor('#E6E6E6'))),
            width: double.maxFinite,
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, top: 15.h, bottom: 5.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        17.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Constants.updateMessage,
                                    style: FontPalette.black14Regular,
                                  ),
                                  Transform.translate(
                                    offset: Offset(-6.w, 0),
                                    child: TextButton(
                                        onPressed: () {
                                          context
                                              .read<AppDataProvider>()
                                              .setEnableAppUpdateTile(false);
                                          CommonFunctions.launchAppStore();
                                        },
                                        child: Text(
                                          'UPDATE NOW',
                                          style: FontPalette.fE50019_16Medium,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        3.verticalSpace
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<AppDataProvider>()
                          .setEnableAppUpdateTile(false);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
        );
      },
    );
  }
}
