import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/customer_address_model.dart';
import 'package:oxygen/providers/address_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/address/add_address_screen.dart';
import 'package:oxygen/widgets/custom_alert_dialog.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

class SelectAddressRowCardWidget extends StatelessWidget {
  const SelectAddressRowCardWidget(
      {Key? key, this.address, this.index, required this.ctx})
      : super(key: key);

  final Addresses? address;
  final int? index;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      child: InkWell(
        onTap: () {
          addressProvider.selectedAddressIndex = index ?? 0;
          addressProvider.notifyListeners();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRadioButton(
              isSelected: index == addressProvider.selectedAddressIndex,
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${address?.firstname} ${address?.lastname}',
                          style: FontPalette.black16Regular,
                        ),
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
                          (address?.addresstype ?? '') == '1'
                              ? Constants.work
                              : Constants.home,
                          style: FontPalette.black12Medium,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    '${addressProvider.setAddressFromList(address?.street)} ',
                    overflow: TextOverflow.ellipsis,
                    style: FontPalette.f7E818C_14Regular,
                  ),
                  Text(
                    (address?.telephone?.startsWith('+91') ?? false)
                        ? '${Constants.mobile}:${address?.telephone?.substring(3)}\n${Constants.email}:${addressProvider.customerEmailAddress} '
                        : '${Constants.mobile}:${address?.telephone}\n${Constants.email}:${addressProvider.customerEmailAddress} ',
                    style: FontPalette.f7E818C_14Regular,
                  ),
                  12.verticalSpace,
                  (index == addressProvider.selectedAddressIndex)
                      ? Row(
                          children: [
                            Flexible(
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () => showDialog(
                                    context: ctx,
                                    barrierColor:
                                        HexColor('#282C3F').withOpacity(0.46),
                                    builder: (_) =>
                                        Selector<AddressProvider, LoaderState>(
                                      selector: (_, provider) =>
                                          provider.loaderState,
                                      builder: (_, loaderState, __) =>
                                          CustomAlertDialog(
                                        title: Constants.removeAddress,
                                        message:
                                            Constants.areYouSureToDeleteAddress,
                                        actionButtonText: Constants.delete,
                                        cancelButtonText:
                                            Constants.cancel.toUpperCase(),
                                        onActionButtonPressed: () {
                                          addressProvider
                                              .removeCustomerAddress(
                                                  ctx, address!.id!)
                                              .then((_) {
                                            Navigator.pop(ctx);
                                          });
                                        },
                                        onCancelButtonPressed: () =>
                                            Navigator.pop(ctx),
                                        isLoading:
                                            loaderState == LoaderState.loading,
                                      ),
                                    ),
                                  ),
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
          addresses: address,
          update: true,
        ),
      ),
    );
  }
}
