import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class AccountTileWidget extends StatelessWidget {
  const AccountTileWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onClick,
    this.first = false,
    this.loginButton = false,
    this.notificationTile = false,
  });

  final bool? first;
  final bool? loginButton;
  final String title;
  final String icon;
  final bool? notificationTile;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: HexColor('#F3F3F7'),
      highlightColor: Colors.transparent,
      onTap: onClick ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Container(
          width: context.sw(),
          height: 65,
          decoration: BoxDecoration(
            border: first!
                ? null
                : Border(
                    top: BorderSide(
                      width: 1.h,
                      color: HexColor('#E6E6E6'),
                    ),
                  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  !loginButton!
                      ? SvgPicture.asset(
                          icon,
                          width: 18,
                          color: HexColor('#272C41'),
                        )
                      : const SizedBox.shrink(),
                  !loginButton!
                      ? 13.8.horizontalSpace
                      : const SizedBox.shrink(),
                  Text(
                    title,
                    style: !loginButton!
                        ? FontPalette.f282C3F_16Medium
                        : FontPalette.f282C3F_16Medium.copyWith(
                            color: HexColor('#FD0000'),
                          ),
                  )
                ],
              ),
              Row(
                children: [
                  notificationTile!
                      ? ValueListenableBuilder(
                          valueListenable:
                              Hive.box(HiveServices.instance.generalBoxName)
                                  .listenable(),
                          builder: (_, box, __) {
                            var count = box.get('notificationCount');
                            return count != null && count != 0
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: ColorPalette.primaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 2.h),
                                      child: Text(
                                        count.toString(),
                                        style: FontPalette.white14Medium
                                            .copyWith(fontSize: 12.sp),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        )
                      : const SizedBox.shrink(),
                  10.horizontalSpace,
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: HexColor(!loginButton! ? '#7B7E8E' : '#FD0000'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
