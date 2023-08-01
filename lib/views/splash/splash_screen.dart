import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';

import '../../generated/assets.dart';
import '../../services/app_config.dart';
import '../../services/firebase_analytics_services.dart';
import '../../utils/color_palette.dart';
import '../../utils/flavour_config.dart';
import 'splash_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Animation<double> imageAnimation;
  late Animation<double> blurAnimation;
  late AnimationController controller;
  late Animation<double> opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: ColorPalette.primaryColor,
            systemNavigationBarIconBrightness: Brightness.light),
        child: SafeArea(
            top: false,
            child: SizedBox.expand(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  AnimatedBuilder(
                      animation: controller,
                      child: Center(
                        child: _SplashSlideAnimation(
                          child: SvgPicture.asset(
                            Assets.iconsLogo,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: imageAnimation.value,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaX: blurAnimation.value,
                                sigmaY: blurAnimation.value,
                                tileMode: TileMode.decal),
                            child: child,
                          ),
                        );
                      }),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      elevation: 0,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.dark,
                        statusBarIconBrightness: Brightness.light,
                        systemNavigationBarIconBrightness: Brightness.light,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    imageAnimation = Tween<double>(begin: 1, end: 2.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInQuint));
    blurAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInQuint));
    opacityAnimation = Tween<double>(begin: 1.0, end: .50).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInQuint));
    WidgetsBinding.instance.addObserver(this);
    final flavour = FlavourConstants.findFlavour;
    AppConfig.baseUrl = flavour.getBaseUrl();
    FirebaseAnalyticsService.instance.openApp();
    SplashHandler.instance.checkNetworkStat(context, mounted, controller);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        SplashHandler.instance.checkForceUpdate(context, mounted, controller);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class _SplashSlideAnimation extends StatefulWidget {
  final Widget child;

  const _SplashSlideAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<_SplashSlideAnimation> createState() => _SplashSlideAnimationState();
}

class _SplashSlideAnimationState extends State<_SplashSlideAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();
    fadeAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    slideAnimation = Tween(begin: -25.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0.0, slideAnimation.value),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
