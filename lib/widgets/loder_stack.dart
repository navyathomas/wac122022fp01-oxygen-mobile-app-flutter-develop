import 'package:flutter/material.dart';
import 'package:oxygen/common/extensions.dart';

class LoaderStack extends StatelessWidget {
  const LoaderStack(
      {Key? key, required this.loading, required this.child, this.splashColor})
      : super(key: key);

  final bool loading;
  final Widget child;
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          (loading
                  ? Container(
                      width: context.sw(),
                      height: context.sh(),
                      color: splashColor ?? Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink())
              .animatedSwitch(),
        ],
      ),
    );
  }
}

class TranparentLoaderStack extends StatelessWidget {
  const TranparentLoaderStack(
      {Key? key, required this.loading, required this.child})
      : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
      ],
    );
  }
}
