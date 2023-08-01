import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/address/widgets/select_address_billing_widget.dart';
import 'package:oxygen/views/address/widgets/select_address_bottom_sheet_widget.dart';
import 'package:oxygen/views/address/widgets/select_address_shipping_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../services/helpers.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  late SelectAddressProvider selectAddressProvider;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  initFunction() {
    selectAddressProvider = SelectAddressProvider();
    selectAddressProvider.getCustomerAddressList(
        onFailure: () => Helpers.flushToast(context,
            msg: selectAddressProvider.errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: selectAddressProvider,
      child: Consumer<SelectAddressProvider>(
        builder: (context, value, child) {
          return Scaffold(
            floatingActionButton:
                const WhatsappChatWidget().bottomPadding(padding: 75),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            appBar: CommonAppBar(
              buildContext: context,
              pageTitle: Constants.selectAddress,
              actionList: const [],
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: selectAddressProvider.loaderState == LoaderState.loading
                  ? const CommonLinearProgress()
                  : Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SelectAddressShippingWidget(
                              addressDetailsList:
                                  selectAddressProvider.addressList,
                              emailAddress:
                                  selectAddressProvider.customerEmail ?? '',
                              selectAddressProvider: selectAddressProvider,
                              isUseSameBillingAddress:
                                  selectAddressProvider.isUseSameBillingAddress,
                              onCheckBoxTap: () => selectAddressProvider
                                  .updateIsSameBillingAddress(
                                      !selectAddressProvider
                                          .isUseSameBillingAddress),
                            ).convertToSliver(),
                            Divider(
                              height: 5.h,
                              thickness: 5.h,
                              color: HexColor("#F3F3F7"),
                            ).convertToSliver(),
                            if (!selectAddressProvider.isUseSameBillingAddress)
                              SelectAddressBillingWidget(
                                billingAddressDetailsList:
                                    selectAddressProvider.addressList,
                                emailAddress:
                                    selectAddressProvider.customerEmail ?? '',
                                selectAddressProvider: selectAddressProvider,
                              ).convertToSliver(),
                            73.verticalSpace.convertToSliver(),
                          ],
                        ),
                        selectAddressProvider.loaderState == LoaderState.loading
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: SelectAddressBottomSheetWidget(
                                    selectAddressProvider:
                                        selectAddressProvider),
                              )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
