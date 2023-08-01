import 'package:flutter/material.dart';

class CustomSlidingFadeAnimation extends StatefulWidget {
  final Widget child;
  final bool onlyFadeAnimation;
  final double? slideOffset;
  final Duration? fadeDuration;
  final Duration? slideDuration;
  final Curve? fadeCurve;
  final Curve? slideCurve;

  const CustomSlidingFadeAnimation({
    Key? key,
    required this.child,
    this.slideOffset,
    this.onlyFadeAnimation = false,
    this.fadeDuration,
    this.slideDuration,
    this.fadeCurve,
    this.slideCurve,
  }) : super(key: key);

  @override
  State<CustomSlidingFadeAnimation> createState() =>
      _CustomSlidingFadeAnimationState();
}

class _CustomSlidingFadeAnimationState extends State<CustomSlidingFadeAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController = AnimationController(
    duration: widget.fadeDuration ?? const Duration(milliseconds: 500),
    vsync: this,
  );

  late final AnimationController _slideController = AnimationController(
    duration: widget.slideDuration ?? const Duration(milliseconds: 500),
    vsync: this,
  );

  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();
    fadeAnimation = Tween(begin: widget.onlyFadeAnimation ? 1.0 : 0.2, end: 1.0)
        .animate(CurvedAnimation(
            parent: _fadeController, curve: widget.fadeCurve ?? Curves.linear));
    slideAnimation = Tween(begin: widget.slideOffset ?? -20.0, end: 0.0)
        .animate(CurvedAnimation(
            parent: _slideController,
            curve: widget.slideCurve ?? Curves.linear));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onlyFadeAnimation) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: widget.child,
      );
    }
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
