import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/address/widgets/add_address_button.dart';
import 'package:oxygen/views/address/widgets/select_address_tile.dart';

import '../../../common/common_function.dart';
import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/customer_address_model.dart';
import '../../../widgets/custom_alert_dialog.dart';

class SelectAddressBillingWidget extends StatelessWidget {
  const SelectAddressBillingWidget(
      {Key? key,
      required this.billingAddressDetailsList,
      required this.emailAddress,
      required this.selectAddressProvider})
      : super(key: key);
  final List<Addresses> billingAddressDetailsList;
  final String emailAddress;
  final SelectAddressProvider selectAddressProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              Constants.billingAddress,
              style: FontPalette.black16Medium,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: billingAddressDetailsList.notEmpty
                ? billingAddressDetailsList.length
                : 0,
            itemBuilder: (context, index) => SelectAddressTile(
              addressDetail: billingAddressDetailsList[index],
              context: context,
              isSelected:
                  selectAddressProvider.selectedBillingAddressIndex == index
                      ? true
                      : false,
              isLoading: selectAddressProvider.isDeleteAddressLoading,
              emailAddress: emailAddress,
              onTap: () {
                selectAddressProvider.updateSelectedBillingAddressIndex(index);
              },
              onRemoveTap: () {
                showDialog(
                    context: context,
                    barrierColor: HexColor('#282C3F').withOpacity(0.46),
                    builder: (_) => CustomAlertDialog(
                          title: Constants.removeAddress,
                          message: Constants.areYouSureToDeleteAddress,
                          actionButtonText: Constants.delete,
                          cancelButtonText: Constants.cancel.toUpperCase(),
                          onActionButtonPressed: () {
                            selectAddressProvider.removeCustomerAddress(
                                billingAddressDetailsList[index].id ?? 0,
                                onSuccess: () {
                              selectAddressProvider.getCustomerAddressList();
                              Navigator.pop(context);
                            }, onFailure: () {
                              CommonFunctions.afterInit(() =>
                                  Helpers.flushToast(context,
                                      msg: selectAddressProvider.errorMessage));
                              Navigator.pop(context);
                            });
                          },
                          onCancelButtonPressed: () => Navigator.pop(context),
                          isLoading:
                              selectAddressProvider.isDeleteAddressLoading ==
                                      true
                                  ? true
                                  : false,
                        ));

                // Navigator.pop(context);
              },
            ),
            separatorBuilder: (context, index) => Divider(
              height: 1.h,
              thickness: 1.h,
              color: HexColor("#F3F3F7"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: AddAddressButton(onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeAddAddressScreen)
                  .then((value) =>
                      selectAddressProvider.getCustomerAddressList());
            }),
          ),
        ],
      ),
    );
  }
}
