import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class HomeGridMenu extends StatelessWidget {
  const HomeGridMenu({Key? key}) : super(key: key);

  void configureCheckAndNavigate(BuildContext context, String route) {
    if (AppConfig.isAuthorized) {
      Navigator.of(context).pushNamed(route);
    } else {
      HiveServices.instance.saveNavPath(RouteGenerator.routeMainScreen);
      Navigator.pushNamed(context, RouteGenerator.routeAuthScreen,
              arguments: true)
          .then((value) {
        if (AppConfig.isAuthorized) {
          Navigator.of(context).pushNamed(route);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13.w, right: 13.w, top: 18.h),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionButton(
                  onTap: () {
                    configureCheckAndNavigate(
                        context, RouteGenerator.routeServiceRequest);
                  },
                  icon: Assets.iconsServiceRequestRed,
                  title: Constants.serviceRequest,
                ),
                11.horizontalSpace,
                _OptionButton(
                  onTap: () {
                    configureCheckAndNavigate(
                        context, RouteGenerator.routeTrackJobScreen);
                  },
                  icon: Assets.iconsServiceTrackingRed,
                  title: Constants.serviceTracking,
                ),
              ],
            ),
          ),
          11.verticalSpace,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionButton(
                  onTap: () {
                    configureCheckAndNavigate(
                        context, RouteGenerator.routeMyOrdersScreen);
                  },
                  icon: Assets.iconsDeliveryTrackingRed,
                  title: Constants.deliveryTracking,
                ),
                11.horizontalSpace,
                _OptionButton(
                  onTap: () {
                    configureCheckAndNavigate(
                        context, RouteGenerator.routeLoyaltyScreen);
                  },
                  icon: Assets.iconsLoyaltyPointRed,
                  title: Constants.loyaltyPoints,
                ),
              ],
            ),
          ),
        ],
      ),
    ).convertToSliver();
  }
}

class _OptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String title;
  const _OptionButton(
      {Key? key, required this.onTap, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: HexColor('#E3E3E3'))),
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.only(left: 5.5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 30.w,
                  width: 30.w,
                ),
                7.horizontalSpace,
                Flexible(
                  child: Text(
                    title,
                    style: FontPalette.black13Regular,
                  ).addEllipsis(maxLine: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
