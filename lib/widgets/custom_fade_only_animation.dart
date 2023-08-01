import 'package:flutter/material.dart';

class CustomFadeOnlyAnimation extends StatefulWidget {
  final Duration? duration;
  final Widget child;

  const CustomFadeOnlyAnimation({
    Key? key,
    required this.child,
    this.duration,
  }) : super(key: key);

  @override
  State<CustomFadeOnlyAnimation> createState() =>
      _CustomFadeOnlyAnimationState();
}

class _CustomFadeOnlyAnimationState extends State<CustomFadeOnlyAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration ?? const Duration(milliseconds: 500),
    vsync: this,
  );

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
