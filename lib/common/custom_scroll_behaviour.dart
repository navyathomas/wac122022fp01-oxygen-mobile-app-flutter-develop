import 'package:flutter/material.dart';

class CustomScrollBehaviour extends ScrollBehavior {
  final Color? overscrollColor;

  const CustomScrollBehaviour({this.overscrollColor});

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return child;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      default:
        return GlowingOverscrollIndicator(
          axisDirection: axisDirection,
          color: overscrollColor ?? Colors.grey,
          child: child,
        );
    }
  }
}
