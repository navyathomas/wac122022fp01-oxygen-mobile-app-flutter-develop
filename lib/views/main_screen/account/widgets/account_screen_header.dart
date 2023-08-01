import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class AccountScreenHeader extends StatelessWidget {
  const AccountScreenHeader(
      {super.key, required this.isAuthorized, this.onClick, this.customer});

  final AuthCustomer? customer;
  final bool isAuthorized;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: HexColor('#F3F3F7'),
      highlightColor: Colors.transparent,
      onTap: isAuthorized ? onClick : null,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 22, bottom: 20, left: 13, right: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isAuthorized
                ? Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 48.r,
                          height: 48.r,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              customer?.firstname?[0] ?? '?',
                              style: FontPalette.white16Medium,
                            ),
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${customer?.firstname ?? ''} ${customer?.lastname ?? ''}',
                                style: FontPalette.black18Medium,
                              ),
                              1.35.verticalSpace,
                              Text(
                                customer?.email ?? '',
                                style: FontPalette.f7B7E8E_14Regular,
                              ),
                            ],
                          ),
                        ),
                        15.horizontalSpace,
                      ],
                    ),
                  )
                : Row(
                    children: [
                      SvgPicture.asset(
                        Assets.imagesGuestUser,
                        width: 48.r,
                        height: 48.r,
                      ),
                      15.horizontalSpace,
                      Text(
                        Constants.guestUser,
                        style: FontPalette.black18Medium,
                      )
                    ],
                  ),
            isAuthorized
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: HexColor('#7B7E8E'),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
