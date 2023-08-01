import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/notification_list_data_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item});

  final NotificationItem? item;

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      return InkWell(
        onTap: () => NavRoutes.instance
            .navByType(context, item?.linkType, item?.linkId, ''),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: HexColor('#E6E6E6'),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(Assets.iconsMyOrderWhite),
                    ),
                  ),
                ),
                18.horizontalSpace,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    14.verticalSpace,
                    Text(
                      item?.name ?? '',
                      style: FontPalette.black16Medium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.verticalSpace,
                    SizedBox(
                      child: Text(
                        item?.shortDescription ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FontPalette.f7B7E8E_14Regular,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      item?.date ?? '',
                      style: FontPalette.fADADAD_13Regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    12.verticalSpace
                  ],
                ))
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
