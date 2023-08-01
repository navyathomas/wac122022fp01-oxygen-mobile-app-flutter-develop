import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/widgets/cart_count_widget.dart';

import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../models/arguments/main_screen_arguments.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';
import 'my_items_count_widget.dart';

class CommonAppBar extends AppBar {
  final String? pageTitle;
  final bool enableNavBack;
  final double? elevationVal;
  final Widget? titleWidget;
  final BuildContext buildContext;
  final List<Widget>? actionList;
  final bool disableWish;
  final bool alignCenter;
  final PreferredSizeWidget? preferredSizeBottom;
  final Function()? onBackPressed;
  final Function()? onActionButtonSearchOnPressed;
  CommonAppBar(
      {Key? key,
      this.pageTitle,
      this.enableNavBack = true,
      this.elevationVal,
      required this.buildContext,
      this.titleWidget,
      this.actionList,
      this.alignCenter = false,
      this.disableWish = false,
      this.preferredSizeBottom,
      this.onBackPressed,
      this.onActionButtonSearchOnPressed})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          bottom: preferredSizeBottom ??
              PreferredSize(
                  preferredSize: Size.fromHeight(0.h),
                  child: Container(
                    color: HexColor('#E6E6E6'),
                    height: 1.h,
                  )),
          backgroundColor: Colors.white,
          elevation: elevationVal ?? 0,
          centerTitle: alignCenter || actionList != null && actionList.isEmpty,
          leading: enableNavBack
              ? IconButton(
                  onPressed: onBackPressed ??
                      () => Navigator.of(buildContext).maybePop(),
                  icon: SvgPicture.asset(
                    Assets.iconsArrowLeft,
                    height: 14.h,
                    width: 14.w,
                  ))
              : const SizedBox.shrink(),
          // leadingWidth: 35.w,
          shadowColor: HexColor('#D9E3E3'),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark),
          titleSpacing: 0,
          title: titleWidget ??
              Text(
                pageTitle ?? '',
                style: FontPalette.black18Medium
                    .copyWith(color: HexColor('#282C3F')),
              ),
          automaticallyImplyLeading: enableNavBack,
          actions: actionList ??
              [
                _ActionButton(
                  onPressed: onActionButtonSearchOnPressed ??
                      () => Navigator.pushNamed(
                          buildContext, RouteGenerator.routeSearchScreen),
                  icon: Assets.iconsSearch,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _ActionButton(
                      onPressed: () {
                        if (AppConfig.isAuthorized) {
                          Navigator.pushNamed(
                              buildContext, RouteGenerator.routeMainScreen,
                              arguments: MainScreenArguments(
                                  tabIndex: 2, enableNavButton: true));
                        } else {
                          HiveServices.instance.saveNavArgs(2);
                          Navigator.pushNamed(
                              buildContext, RouteGenerator.routeAuthScreen,
                              arguments: true);
                        }
                      },
                      size: 24.r,
                      onTop: MyItemsCountWidget(
                        offset: Offset(5.w, -5.h),
                      ),
                      icon: Assets.iconsWishlist,
                    ),
                  ],
                ),
                _ActionButton(
                  onPressed: () => Navigator.pushNamed(
                      buildContext, RouteGenerator.routeMainScreen,
                      arguments: MainScreenArguments(
                          tabIndex: 3, enableNavButton: true)),
                  onTop: CartCountWidget(
                    offset: Offset(5.w, -5.h),
                  ),
                  icon: Assets.iconsCart,
                )
              ],
        );
}

class CommonSliverAppBar extends SliverAppBar {
  final String? pageTitle;
  final bool enableNavBack;
  final double? elevationVal;
  final Widget? titleWidget;
  final BuildContext buildContext;
  final List<Widget>? actionList;
  final bool disableWish;
  final PreferredSizeWidget? preferredSizeBottom;

  CommonSliverAppBar({
    Key? key,
    this.pageTitle,
    this.enableNavBack = true,
    this.elevationVal,
    required this.buildContext,
    this.titleWidget,
    this.actionList,
    this.disableWish = false,
    this.preferredSizeBottom,
  }) : super(
          key: key,
          floating: true,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          automaticallyImplyLeading: enableNavBack,
          actions: actionList,
        );
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String icon;
  final double? size;
  final Widget? onTop;

  const _ActionButton(
      {Key? key, this.onPressed, required this.icon, this.onTop, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: size ?? 20.r,
            child: SvgPicture.asset(icon),
          ),
          if (onTop != null) onTop!
        ],
      ),
    );
  }
}
