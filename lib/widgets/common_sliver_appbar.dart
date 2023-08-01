import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';
import '../utils/font_palette.dart';

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
          bottom: preferredSizeBottom ??
              PreferredSize(
                  preferredSize: Size.fromHeight(0.h),
                  child: Container(
                    color: HexColor('#E6E6E6'),
                    height: 1.h,
                  )),
          backgroundColor: Colors.white,
          elevation: elevationVal ?? 0,
          leading: enableNavBack
              ? IconButton(
                  onPressed: () => Navigator.of(buildContext).maybePop(),
                  icon: SvgPicture.asset(
                    Assets.iconsArrowLeft,
                    height: 14.h,
                    width: 14.w,
                  ))
              : const SizedBox.shrink(),
          leadingWidth: 35.w,
          shadowColor: HexColor('#D9E3E3'),
          centerTitle: true,
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
          actions: actionList,
        );
}
