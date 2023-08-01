import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';

extension Log on Object {
  void log({String name = ''}) => devtools.log(toString(), name: name);
}

extension FlavourTypeExtension on String {
  String getBaseUrl() {
    switch (this) {
      case 'dev':
        return 'https://oxygen-test.webc.in/';
      case 'stage':
        return 'https://oxygen-test.webc.in/';
      case 'prod':
        return 'https://oxygendigitalshop.com/';
      default:
        return 'https://oxygen-test.webc.in/';
    }
  }

  String getFlavourName() {
    switch (this) {
      case 'dev':
        return 'Development';
      case 'stage':
        return 'Staging';
      case 'prod':
        return 'Production';
      default:
        return 'Production';
    }
  }
}

extension WidgetExtension on Widget {
  Widget animatedSwitch({
    Curve? curvesIn,
    Curve? curvesOut,
    int duration = 200,
    int reverseDuration = 200,
  }) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      reverseDuration: Duration(milliseconds: reverseDuration),
      switchInCurve: curvesIn ?? Curves.linear,
      switchOutCurve: curvesOut ?? Curves.linear,
      child: this,
    );
  }

  static Widget crossSwitch(
      {required Widget first,
      Widget second = const SizedBox.shrink(),
      required bool value,
      Curve curvesIn = Curves.linear,
      Curve curvesOut = Curves.linear}) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      crossFadeState:
          value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstCurve: curvesIn,
      secondCurve: curvesOut,
    );
  }
}

extension InkWellExtension on InkWell {
  InkWell removeSplash({Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      splashColor: color,
      highlightColor: color,
      child: child,
    );
  }
}

extension LoaderExtension on LoaderState {
  bool get isLoading => this == LoaderState.loading;
}

extension TranslateWidgetVertically on Widget {
  Widget translateWidgetVertically({double value = 0}) {
    return Transform.translate(
      offset: Offset(0.0, value),
      child: this,
    );
  }
}

extension TranslateWidgetHorizontally on Widget {
  Widget translateWidgetHorizontally({double value = 0}) {
    return Transform.translate(
      offset: Offset(value, 0.0),
      child: this,
    );
  }
}

extension ConvertToSliver on Widget {
  Widget convertToSliver() {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}

extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }

  int cacheSize(double size) {
    return (size * MediaQuery.of(this).devicePixelRatio).round();
  }

  void get rootPop => Navigator.of(this, rootNavigator: true).pop();

  Future get circularLoaderPopUp => showGeneralDialog(
        context: this,
        barrierColor: Colors.black.withOpacity(0.3),
        barrierDismissible: false,
        barrierLabel: "",
        useRootNavigator: true,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) {
          return WillPopScope(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                ],
              ),
            ),
            onWillPop: () async {
              Navigator.pop(this);
              return false;
            },
          );
        },
      );

  double validateScale({double defaultVal = 0.0}) {
    double value = MediaQuery.of(this).textScaleFactor;
    double pixelRatio = ScreenUtil().pixelRatio ?? 0.0;
    0;
    if (value <= 1.0) {
      defaultVal = defaultVal;
    } else if (value >= 1.3) {
      defaultVal = value - 0.2;
    } else if (value >= 1.1) {
      defaultVal = value - 0.1;
    }
    if (pixelRatio <= 3.0) {
      defaultVal = defaultVal + 0;
    } else if (value >= 3.15) {
      defaultVal = defaultVal + 0.6;
    } else if (value >= 1.1) {
      defaultVal = defaultVal + 0.8;
    }
    return defaultVal;
  }
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text addEllipsis({int maxLine = 1}) {
    return Text(
      (data ?? '').trim(),
      style: style,
      strutStyle: strutStyle,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension StringExtension on String? {
  bool get notEmpty => (this ?? '').isNotEmpty;

  bool get empty => (this ?? '').isNotEmpty;
}

extension ListExtension on List? {
  bool get notEmpty => (this ?? []).isNotEmpty;
}

extension AddShimmer on Widget {
  Widget addShimmer({Color? baseColor, Color? highlightColor}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.shimmerBaseColor,
      highlightColor: ColorPalette.shimmerHighlightColor,
      child: this,
    );
  }
}

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    } else {
      return false;
    }
  }
}

extension Currency on String {
  String get addCurrency => (isNotEmpty) ? "${Constants.currency}$this" : "";
}

extension IntExtension on int? {
  String get toRupee {
    if (this == null) return '0';
    String value = NumberFormat("#,##0", "en_IN").format(this);
    return "${Constants.currency}$value";
  }
}

extension DoubleExtension on double? {
  String get toRupee {
    if (this == null) return '0.0';
    String value = NumberFormat("#,##0.00", "en_IN").format(this);
    return "${Constants.currency}$value";
  }
}

extension RemoveDecimalExtension on String? {
  String get removeDecimal {
    if (this == null || (this?.isEmpty ?? true)) return "";
    if (this?.contains(".") ?? false) {
      return this?.substring(0, this?.indexOf(".") ?? 0) ?? "";
    } else {
      return this ?? "";
    }
  }
}

extension PaddingExtension on Widget {
  Widget bottomPadding({double? padding}) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 0.0),
      child: this,
    );
  }

  Widget topPadding({double? padding}) {
    return Padding(
      padding: EdgeInsets.only(top: padding ?? 0.0),
      child: this,
    );
  }

  Widget leftPadding({double? padding}) {
    return Padding(
      padding: EdgeInsets.only(left: padding ?? 0.0),
      child: this,
    );
  }

  Widget rightPadding({double? padding}) {
    return Padding(
      padding: EdgeInsets.only(right: padding ?? 0.0),
      child: this,
    );
  }
}
