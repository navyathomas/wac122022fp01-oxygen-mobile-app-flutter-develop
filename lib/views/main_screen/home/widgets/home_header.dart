import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../../../../generated/assets.dart';

class HomeHeader extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;

  const HomeHeader({Key? key, required this.valueNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: valueNotifier,
        builder: (context, value, _) {
          return AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeInOut,
            duration: const Duration(milliseconds: 400),
            child: value
                ? Container(
                    color: ColorPalette.primaryColor,
                    height: double.maxFinite,
                  )
                : SizedBox(
                    height: double.maxFinite,
                    child: Row(
                      children: [
                        12.horizontalSpace,
                        Expanded(
                          child: SvgPicture.asset(
                            Assets.iconsLogo,
                            alignment: Alignment.centerLeft,
                            height: 42.41.h,
                            width: 110.76.w,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.routeStoresScreen);
                          },
                          icon: SvgPicture.asset(
                            Assets.iconsHomeOutlineWhite,
                            alignment: Alignment.center,
                            height: 18.55.h,
                            width: 21.18.w,
                          ),
                        ),
                        AppConfig.isAuthorized
                            ? ValueListenableBuilder(
                                valueListenable: Hive.box(
                                        HiveServices.instance.generalBoxName)
                                    .listenable(),
                                builder: (_, box, __) {
                                  var count = box.get('notificationCount');
                                  return IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          RouteGenerator
                                              .routeNotificationScreen);
                                    },
                                    icon: SizedBox(
                                      height: 30.h,
                                      width: 28.w,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            Assets.iconsNotificationHome,
                                            alignment: Alignment.center,
                                          ),
                                          count != 0 && count != null
                                              ? Positioned(
                                                  right: 0.5.w,
                                                  top: 0,
                                                  child: Container(
                                                    width: 17.r,
                                                    height: 17.r,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: FittedBox(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Text(
                                                              count < 9
                                                                  ? count
                                                                      .toString()
                                                                  : '9+',
                                                              style: FontPalette
                                                                  .black12Medium
                                                                  .copyWith(
                                                                color: ColorPalette
                                                                    .primaryColor,
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
          );
        });
  }
}
