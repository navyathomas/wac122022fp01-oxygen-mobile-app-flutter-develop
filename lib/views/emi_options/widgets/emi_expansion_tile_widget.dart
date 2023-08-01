import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

class EmiExpansionTileWidget extends StatefulWidget {
  const EmiExpansionTileWidget({
    super.key,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.image,
    this.title,
    this.backgroundColor,
    this.expandedWidget,
  });

  final String? image;
  final String? title;
  final Color? backgroundColor;
  final ValueChanged<bool>? onExpansionChanged;
  final bool initiallyExpanded;
  final bool maintainState;
  final Widget? expandedWidget;

  @override
  State<EmiExpansionTileWidget> createState() => _EmiExpansionTileWidgetState();
}

class _EmiExpansionTileWidgetState extends State<EmiExpansionTileWidget>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: Icon(
        Icons.expand_more,
        color: HexColor("#7B7E8E"),
      ),
    );
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    return _buildIcon(context);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: _handleTap,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                color: widget.backgroundColor ?? Colors.grey.shade200,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CommonCachedNetworkImageFixed(
                                image: widget.image,
                                height: constraints.maxWidth * .1222,
                                width: constraints.maxWidth * .1222),
                            14.horizontalSpace,
                            Expanded(
                              child: Text(
                                widget.title ?? "",
                                style: FontPalette.black14Regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.horizontalSpace,
                      _buildTrailingIcon(context)!
                    ],
                  );
                }),
              ),
              if (!_isExpanded)
                Container(
                  height: 1.r,
                  margin: EdgeInsets.symmetric(horizontal: 13.w),
                  color: HexColor("#F3F3F7"),
                ),
            ],
          ),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: widget.expandedWidget,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
