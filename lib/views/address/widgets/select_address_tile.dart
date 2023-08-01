import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/customer_address_model.dart';

import '../../../common/constants.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio_button.dart';
import '../add_address_screen.dart';

class SelectAddressTile extends StatelessWidget {
  const SelectAddressTile({
    Key? key,
    required this.addressDetail,
    required this.context,
    required this.isSelected,
    required this.isLoading,
    this.emailAddress,
    this.onTap,
    this.onRemoveTap,
  }) : super(key: key);
  final Addresses addressDetail;
  final String? emailAddress;
  final Function()? onTap;
  final BuildContext context;
  final bool isSelected;
  final Function()? onRemoveTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRadioButton(
              isSelected: isSelected,
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${addressDetail.firstname} ${addressDetail.lastname}',
                        style: FontPalette.black16Regular,
                      ),
                      10.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: HexColor("#E6E6E6"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          (addressDetail.addresstype ?? '') == '1'
                              ? Constants.work
                              : Constants.home,
                          style: FontPalette.black12Medium,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    addressDetail.street.notEmpty
                        ? addressDetail.street!.join(' ')
                        : '',
                    style: FontPalette.f7E818C_14Regular,
                    strutStyle: StrutStyle(height: 1.2.h),
                  ),
                  3.verticalSpace,
                  Text(
                    (addressDetail.telephone?.startsWith('+91') ?? false)
                        ? '${Constants.mobile}:${addressDetail.telephone?.substring(3)}'
                        : '${Constants.mobile}:${addressDetail.telephone}',
                    style: FontPalette.f7E818C_14Regular,
                  ),
                  3.verticalSpace,
                  (emailAddress ?? '').isNotEmpty
                      ? Text(
                          '${Constants.email}:${emailAddress ?? ''} ',
                          style: FontPalette.f7E818C_14Regular,
                        )
                      : const SizedBox.shrink(),
                  isSelected ? 9.verticalSpace : 0.verticalSpace,
                  isSelected
                      ? Row(
                          children: [
                            Flexible(
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: onRemoveTap,
                                  // onTap: () => showDialog(
                                  //   context: context,
                                  //   barrierColor:
                                  //       HexColor('#282C3F').withOpacity(0.46),
                                  //   builder: (_) => CustomAlertDialog(
                                  //     title: Constants.removeAddress,
                                  //     message:
                                  //         Constants.areYouSureToDeleteAddress,
                                  //     actionButtonText: Constants.delete,
                                  //     cancelButtonText:
                                  //         Constants.cancel.toUpperCase(),
                                  //     onActionButtonPressed: onRemoveTap,
                                  //     onCancelButtonPressed: () =>
                                  //         Navigator.pop(context),
                                  //     isLoading: isLoading,
                                  //   ),
                                  // ),
                                  child: Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Align(
                                      widthFactor: 1,
                                      child: Text(
                                        Constants.remove.toUpperCase(),
                                        maxLines: 1,
                                        style: FontPalette.black13Medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            8.horizontalSpace,
                            Flexible(
                              child: Material(
                                color: Colors.black,
                                child: InkWell(
                                  onTap: () => _navigate(context),
                                  child: Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Align(
                                      widthFactor: 1,
                                      child: Text(
                                        Constants.edit.toUpperCase(),
                                        maxLines: 1,
                                        style: FontPalette.white13Medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      ).removeSplash(),
    );
  }

  void _navigate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          addresses: addressDetail,
          update: true,
        ),
      ),
    );
  }
}
