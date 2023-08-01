import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/providers/home_provider.dart';
import 'package:oxygen/providers/wishlist_provider.dart';
import 'package:oxygen/repositories/cart_repo.dart';
import 'package:oxygen/services/firebase_dynamic_link_services.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/main_screen/account/account_screen.dart';
import 'package:oxygen/views/main_screen/cart/cart_screen.dart';
import 'package:oxygen/views/main_screen/home/home_screen.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../common/constants.dart';
import '../../generated/assets.dart';
import '../../models/arguments/main_screen_arguments.dart';
import '../../providers/cart_provider.dart';
import '../../services/app_config.dart';
import '../../utils/font_palette.dart';
import '../../widgets/cart_count_widget.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/empty_app_bar.dart';
import '../../widgets/my_items_count_widget.dart';
import 'categories/category_screen.dart';
import 'my_items/my_items_screen.dart';

class MainScreen extends StatefulWidget {
  final MainScreenArguments? mainScreenArguments;

  const MainScreen({Key? key, this.mainScreenArguments}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin<MainScreen> {
  late final ScrollController homeScrollController;
  late final ValueNotifier<int> selectedIndex;
  DateTime? currentBackPressTime;
  late final PageController pageController;
  late final ValueNotifier<bool> isAppBarScrolled;

  final List<String> _bottomNavIcons = [
    Assets.iconsHome,
    Assets.iconsCategories,
    Assets.iconsWishlist,
    Assets.iconsCart,
    Assets.iconsAccount
  ];

  final List<String> _bottomNavSelectedIcons = [
    Assets.iconsHomeSelected,
    Assets.iconsCategoriesSelected,
    Assets.iconsMyItemsSelected,
    Assets.iconsCartSelected,
    Assets.iconsAccountSelected
  ];

  final List<String> _bottomNavLabels = [
    Constants.home,
    Constants.categories,
    Constants.myItems,
    Constants.cart,
    Constants.account,
  ];

  final List<PreferredSizeWidget?> _appBars = [
    EmptyAppBar(
      backgroundColor: ColorPalette.primaryColor,
      darkIcon: Platform.isIOS ? true : false,
    ),
    EmptyAppBar(
      backgroundColor: Colors.white,
      darkIcon: Platform.isIOS ? false : true,
    ),
    EmptyAppBar(
      backgroundColor: Colors.white,
      darkIcon: Platform.isIOS ? false : true,
    ),
    EmptyAppBar(
      backgroundColor: Colors.white,
      darkIcon: Platform.isIOS ? false : true,
    ),
    null
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, _) {
          return Scaffold(
            appBar: _appBars[value],
            floatingActionButton: AnimatedAlign(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                alignment: value == 3
                    ? const Alignment(-1.0, 0.83)
                    : Alignment.bottomLeft,
                child: const WhatsappChatWidget()),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            bottomNavigationBar: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                  systemStatusBarContrastEnforced: true,
                  systemNavigationBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.dark),
              child: BottomNavigationBar(
                currentIndex: value,
                showSelectedLabels: true,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                onTap: (val) {
                  switch (val) {
                    case 0:
                      scrollHomeToTop(homeScrollController);
                      break;
                    case 1:
                      updateSelectedIndex(val, onMainTap: true);
                      break;
                    case 2:
                      if (AppConfig.isAuthorized) {
                        updateSelectedIndex(val, onMainTap: true);
                        if (value != 2) {
                          context.read<WishListProvider>().initData();
                        }
                      } else {
                        HiveServices.instance
                            .saveNavPath(RouteGenerator.routeMainScreen);
                        Navigator.pushNamed(
                                context, RouteGenerator.routeAuthScreen,
                                arguments: true)
                            .then((value) {
                          if (AppConfig.isAuthorized) {
                            updateSelectedIndex(val, onMainTap: true);
                          }
                        });
                      }
                      break;
                    case 3:
                      updateSelectedIndex(val, onMainTap: true);
                      if (value != 3) context.read<CartProvider>().pageInit();
                      break;
                    case 4:
                      updateSelectedIndex(val, onMainTap: true);
                      break;
                  }
                },
                selectedLabelStyle: FontPalette.fE50019_12Regular,
                unselectedLabelStyle: FontPalette.black12Regular,
                items: List.generate(
                  _bottomNavIcons.length,
                  (index) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Stack(
                        children: [
                          (value != index
                                  ? SvgPicture.asset(
                                      _bottomNavIcons[index],
                                      height: 24.w,
                                      width: 24.w,
                                    )
                                  : SvgPicture.asset(
                                      _bottomNavSelectedIcons[index],
                                      height: 24.w,
                                      width: 24.w,
                                    ))
                              .animatedSwitch(),
                          if (index == 2) const MyItemsCountWidget(),
                          if (index == 3) const CartCountWidget()
                        ],
                      ),
                    ),
                    label: _bottomNavLabels[index],
                  ),
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: () => onWillPop(value, homeScrollController),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeScreen(
                    scrollController: homeScrollController,
                    isAppBarScrolled: isAppBarScrolled,
                  ),
                  const CategoryScreen(),
                  MyItemsScreen(
                    onTabSwitch: (val) => updateSelectedIndex(val),
                    enableBackBtn: widget.mainScreenArguments?.enableNavButton,
                  ),
                  CartScreen(
                    onTabSwitch: (val) => updateSelectedIndex(val),
                    enableBackBtn: widget.mainScreenArguments?.enableNavButton,
                  ),
                  AccountScreen(
                    onTabSwitch: (val) => updateSelectedIndex(val),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    homeScrollController = ScrollController();
    isAppBarScrolled = ValueNotifier(false);
    selectedIndex = ValueNotifier(widget.mainScreenArguments?.tabIndex ?? 0);
    pageController = PageController(
        initialPage: widget.mainScreenArguments?.tabIndex ?? 0, keepPage: true);
    scrollListener();
    CommonFunctions.afterInit(() {
      checkRestoreCart();
      context.read<HomeProvider>().getHomeData(context);
      FirebaseDynamicLinkServices.instance.initDynamicLinks(context);
    });
    super.initState();
  }

  void scrollListener() {
    homeScrollController.addListener(() {
      if (homeScrollController.position.pixels > 30.h) {
        isAppBarScrolled.value = true;
      } else {
        isAppBarScrolled.value = false;
      }
    });
  }

  void updateSelectedIndex(int index, {bool onMainTap = false}) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  void scrollHomeToTop(ScrollController homeController) {
    if (selectedIndex.value != 0) {
      updateSelectedIndex(0, onMainTap: true);
    } else {
      if (homeController.position.pixels !=
          homeController.initialScrollOffset) {
        homeController.animateTo(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutExpo);
      }
    }
  }

  Future<bool> onWillPop(int index, ScrollController homeController) async {
    final hasPagePushed = Navigator.of(context).canPop();
    if (hasPagePushed) return true;
    if (index != 0) {
      updateSelectedIndex(0);
      return false;
    } else {
      if (homeController.position.pixels !=
          homeController.initialScrollOffset) {
        homeController.animateTo(0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutExpo);
        return false;
      } else {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          return Future.value(false);
        } else {
          return true;
        }
      }
    }
  }

  Future<void> checkRestoreCart() async {
    CartRepo.checkRestoreCart().then((restoreCartModel) {
      if (restoreCartModel?.customer?.isRedirected ?? false) {
        CommonFunctions.showDialogPopUp(
            context,
            Selector<CartProvider, Tuple2<bool, bool>>(
              selector: (context, provider) =>
                  Tuple2(provider.restoreCartLoader, provider.emptyCartLoader),
              builder: (_, value, child) {
                return CustomAlertDialog(
                  title: Constants.doUWantToRestore,
                  message: restoreCartModel?.customer?.popupMessage ?? '',
                  actionButtonText: Constants.yesAddToCart,
                  cancelButtonText: Constants.noDontAdd,
                  onActionButtonPressed: () async {
                    context.read<CartProvider>().restoreCustomerCart(onPop: () {
                      Navigator.pop(context);
                    });
                  },
                  onCancelButtonPressed: () async {
                    context.read<CartProvider>().restoreCustomerCart(
                        restoreCart: false,
                        onPop: () {
                          Navigator.pop(context);
                        });
                  },
                  isLoading: value.item1,
                  cancelIsLoading: value.item2,
                );
              },
            ),
            barrierDismissible: false);
      }
    });
  }

  @override
  void dispose() {
    homeScrollController.dispose();
    isAppBarScrolled.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
