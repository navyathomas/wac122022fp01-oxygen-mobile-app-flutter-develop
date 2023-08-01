import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/local_products.dart';
import 'package:provider/provider.dart';

import '../common/route_generator.dart';
import '../generated/assets.dart';
import '../providers/wishlist_provider.dart';
import '../services/app_config.dart';
import '../services/hive_services.dart';

class FavoriteIconWidget extends StatefulWidget {
  final double? size;
  final bool isWishListed;
  final String sku;
  final Box<LocalProducts> box;
  final String navPath;
  final String? name;

  const FavoriteIconWidget(
      {Key? key,
      this.size,
      required this.isWishListed,
      required this.sku,
      required this.box,
      this.name,
      required this.navPath})
      : super(key: key);

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double?> _sizeAnimation;
  late final ValueNotifier<bool> isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
    _sizeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _sizeAnimation =
        Tween<double>(begin: 0.7, end: 1.0).animate(_sizeController);
    statusListener();
  }

  void statusListener() {
    _sizeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _sizeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _sizeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, value, _) {
        return Material(
          color: Colors.white.withOpacity(.80),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onWishListTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox.square(
                dimension: widget.size ?? 18.r,
                child: (!value
                        ? SvgPicture.asset(widget.isWishListed
                            ? Assets.iconsFavouriteFilled
                            : Assets.iconsFavourite)
                        : AnimatedBuilder(
                            animation: _sizeAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _sizeAnimation.value,
                              child: SvgPicture.asset(
                                Assets.iconsFavouriteFilled,
                              ),
                            ),
                          ))
                    .animatedSwitch(),
              ),
            ),
          ),
        );
      },
    );
  }

  void onWishListTap() {
    if (AppConfig.isAuthorized) {
      _updateWishList();
    } else {
      HiveServices.instance.saveNavPath(widget.navPath);
      Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
              arguments: true)
          .then((value) {
        if (AppConfig.isAuthorized) {
          _updateWishList();
        }
      });
    }
  }

  void _updateWishList() {
    isLoading.value = true;
    _sizeController.forward();
    context
        .read<WishListProvider>()
        .updateWishListByInput(context,
            box: widget.box, sku: widget.sku, name: widget.name)
        .then((value) {
      isLoading.value = false;
      _sizeController.stop();
    });
  }
}
