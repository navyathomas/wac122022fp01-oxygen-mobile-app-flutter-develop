import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key? key, this.backgroundColor, this.darkIcon = true})
      : super(key: key);
  final Color? backgroundColor;
  final bool darkIcon;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness:
              darkIcon ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              darkIcon ? Brightness.dark : Brightness.light,
          statusBarColor: backgroundColor ?? Colors.transparent,
          statusBarBrightness: darkIcon ? Brightness.dark : Brightness.light),
      child: Container(
        color: backgroundColor ?? Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
