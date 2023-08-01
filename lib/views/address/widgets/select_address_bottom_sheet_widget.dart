import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/payment_arguments.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

class SelectAddressBottomSheetWidget extends StatelessWidget {
  const SelectAddressBottomSheetWidget(
      {Key? key, required this.selectAddressProvider})
      : super(key: key);
  final SelectAddressProvider selectAddressProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: selectAddressProvider,
      child: Container(
        height: 73.h,
        decoration: CommonStyles.bottomDecoration,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Selector<SelectAddressProvider, bool>(
              selector: (context, selectAddressProvider) =>
                  selectAddressProvider.btnLoaderState,
              builder: (context, value, child) {
                return CustomButton(
                  enabled: (selectAddressProvider.shippingAddressId != -1),
                  height: 45.h,
                  onPressed: ((selectAddressProvider.shippingAddressId != -1))
                      ? () => onTapFunction(context)
                      : null,
                  isLoading: value,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  onTapFunction(BuildContext context) {
    selectAddressProvider.setShippingAddress(
        selectAddressProvider.shippingAddressId.toString(),
        onSuccess: () {
          selectAddressProvider.setBillingAddress(
              selectAddressProvider.billingAddressId.toString(),
              onSuccess: () {
                Navigator.pushNamed(context, RouteGenerator.routePaymentScreen,
                    arguments: PaymentArguments(
                        selectAddressProvider: selectAddressProvider));
              },
              onFailure: () => Helpers.flushToast(context,
                  msg: selectAddressProvider.errorMessage));
        },
        onFailure: () => Helpers.flushToast(context,
            msg: selectAddressProvider.errorMessage));
  }
}
