import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/address/widgets/add_address_button.dart';
import 'package:oxygen/views/address/widgets/select_address_tile.dart';
import 'package:oxygen/widgets/custom_check_box.dart';
import 'package:provider/provider.dart';

import '../../../models/customer_address_model.dart';
import '../../../widgets/custom_alert_dialog.dart';

class SelectAddressShippingWidget extends StatelessWidget {
  const SelectAddressShippingWidget(
      {Key? key,
      required this.addressDetailsList,
      required this.emailAddress,
      required this.selectAddressProvider,
      required this.isUseSameBillingAddress,
      required this.onCheckBoxTap})
      : super(key: key);
  final List<Addresses> addressDetailsList;
  final String emailAddress;
  final SelectAddressProvider selectAddressProvider;
  final bool isUseSameBillingAddress;
  final Function()? onCheckBoxTap;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: selectAddressProvider,
      child: Consumer<SelectAddressProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    Constants.shippingAddress,
                    style: FontPalette.black16Medium,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addressDetailsList.notEmpty
                      ? addressDetailsList.length
                      : 0,
                  itemBuilder: (context, index) => SelectAddressTile(
                    addressDetail: addressDetailsList[index],
                    context: context,
                    isSelected:
                        selectAddressProvider.selectedShippingIndex == index
                            ? true
                            : false,
                    isLoading: selectAddressProvider.isDeleteAddressLoading
                        ? true
                        : false,
                    emailAddress: emailAddress,
                    onTap: () => selectAddressProvider
                      ..updateSelectedShippingIndex(index)
                      ..updateSelectedShippingAddressId(
                          addressDetailsList[index].id ?? 0)
                      ..updateIsSameBillingAddress(
                          value.isUseSameBillingAddress),
                    onRemoveTap: () {
                      showDialog(
                          context: context,
                          barrierColor: HexColor('#282C3F').withOpacity(0.46),
                          builder: (_) => CustomAlertDialog(
                                title: Constants.removeAddress,
                                message: Constants.areYouSureToDeleteAddress,
                                actionButtonText: Constants.delete,
                                cancelButtonText:
                                    Constants.cancel.toUpperCase(),
                                onActionButtonPressed: () {
                                  selectAddressProvider.removeCustomerAddress(
                                      addressDetailsList[index].id ?? 0,
                                      onSuccess: () {
                                    selectAddressProvider
                                        .getCustomerAddressList()
                                        .then((value) {
                                      if (selectAddressProvider
                                          .addressList.notEmpty) {
                                        selectAddressProvider
                                            .updateSelectedShippingIndex(0);
                                      }
                                    });
                                    Navigator.pop(context);
                                  }, onFailure: () {
                                    CommonFunctions.afterInit(() =>
                                        Helpers.flushToast(context,
                                            msg: selectAddressProvider
                                                .errorMessage));
                                    Navigator.pop(context);
                                  });
                                },
                                onCancelButtonPressed: () =>
                                    Navigator.pop(context),
                                isLoading: selectAddressProvider
                                    .isDeleteAddressLoading,
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
                  padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 20.h),
                  child: AddAddressButton(onTap: () {
                    Navigator.pushNamed(
                            context, RouteGenerator.routeAddAddressScreen)
                        .then((value) =>
                            selectAddressProvider.getCustomerAddressList());
                  }),
                ),
                if (addressDetailsList.notEmpty) 21.verticalSpace,
                if (addressDetailsList.notEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: InkWell(
                      onTap: onCheckBoxTap,
                      child: Row(
                        children: [
                          CustomCheckBox(
                            isSelected: isUseSameBillingAddress,
                          ),
                          8.horizontalSpace,
                          Flexible(
                            child: Text(
                              Constants.useSameAsBillingAddress,
                              style: FontPalette.black16Medium,
                            ),
                          )
                        ],
                      ),
                    ).removeSplash(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
