import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/stores_data_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailsTile extends StatelessWidget {
  StoreDetailsTile(
      {Key? key, this.storeModel, this.onDirectionClick, required this.index})
      : super(key: key);

  final StoresDataModel? storeModel;
  final int index;
  Future<void> Function({double? lat, double? long})? onDirectionClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: 12.5.w,
              right: 12.5.w,
              top: index != 0 ? 18.h : 8.h,
              bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeModel?.heading ?? '',
                style: FontPalette.black18Medium,
              ),
              7.verticalSpace,
              Text(
                storeModel?.street ?? '',
                style: FontPalette.black14Regular.copyWith(
                  height: 1.6,
                  color: HexColor('#7E818C'),
                ),
              ),
              2.verticalSpace,
              Row(
                children: [
                  Text('${Constants.mobile}:',
                      style: FontPalette.black14Regular
                          .copyWith(color: HexColor('#7E818C'), height: 1.6)),
                  3.horizontalSpace,
                  InkWell(
                    splashColor: ColorPalette.primaryShadowColor,
                    onTap: storeModel?.mobile != null
                        ? () => callTo(storeModel!.mobile!)
                        : null,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(storeModel?.mobile ?? '',
                          style: FontPalette.black14Medium),
                    ),
                  ),
                ],
              ),
              2.verticalSpace,
              Row(
                children: [
                  Text('${Constants.email}:',
                      style: FontPalette.black14Regular
                          .copyWith(color: HexColor('#7E818C'), height: 1.6)),
                  3.horizontalSpace,
                  InkWell(
                    onTap: storeModel?.email != null
                        ? () => mailTo(storeModel!.email!)
                        : null,
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Text(storeModel?.email ?? '',
                          style: FontPalette.black14Medium),
                    ),
                  )
                ],
              ),
              15.verticalSpace,
              Text(
                Constants.storeHrs,
                style: FontPalette.black16Medium,
              ),
              9.verticalSpace,
              Row(
                children: [
                  Text(Constants.today,
                      style: FontPalette.black14Regular
                          .copyWith(color: HexColor('#7E818C'))),
                  3.horizontalSpace,
                  Expanded(
                    child: Text('10:00 AM - 9:00 PM',
                        style: FontPalette.black14Medium),
                  )
                ],
              ),
              5.verticalSpace,
              InkWell(
                onTap: () async => await onDirectionClick?.call(
                    lat: storeModel?.latitude, long: storeModel?.longitude),
                child: Container(
                  width: 160.w,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.iconsDirection,
                          height: 17.h,
                          width: 17.w,
                        ),
                        8.horizontalSpace,
                        Text(
                          Constants.direction,
                          style: FontPalette.black16Medium
                              .copyWith(color: HexColor('#E50019')),
                        )
                      ],
                    ),
                  ),
                ),
              ).removeSplash()
            ],
          ),
        ),
        CustomDivider(
          height: 5.h,
          thickness: 5.h,
        )
      ],
    );
  }

  Future<void> mailTo(String mail, {String? subject, String? body}) async {
    Uri uri =
        Uri.parse("mailto:$mail?subject=${subject ?? ''}&body=${body ?? ''}");
    await launchUrl(uri);
  }

  Future<void> callTo(String phone) async {
    String phoneNumber = Uri.encodeComponent(phone);
    Uri uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri);
  }
}
