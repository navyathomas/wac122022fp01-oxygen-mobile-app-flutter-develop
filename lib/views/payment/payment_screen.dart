import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/payment_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/payment/widgets/payment_bottom_widget.dart';
import 'package:oxygen/views/payment/widgets/payment_method_view.dart';
import 'package:oxygen/views/payment/widgets/payment_price_details_widget.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/arguments/payment_arguments.dart';
import '../../widgets/common_appbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
    required this.paymentArguments,
  }) : super(key: key);
  final PaymentArguments paymentArguments;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentProvider paymentProvider;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  initFunction() async {
    paymentProvider = PaymentProvider();
    CommonFunctions.afterInit(() async {
      paymentProvider.getAvailablePaymentModes(
          navFromBajaj: widget.paymentArguments.navFromBajaj);
      paymentProvider.updateShippingMethodCode(
          shippingMethodCode: widget.paymentArguments.selectAddressProvider
                  .availableShippingMethods[0].methodCode ??
              '',
          shippingCarrierMode: widget.paymentArguments.selectAddressProvider
                  .availableShippingMethods[0].carrierCode ??
              '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: paymentProvider,
      child: Scaffold(
          floatingActionButton:
              const WhatsappChatWidget().bottomPadding(padding: 75),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          appBar: CommonAppBar(
            onBackPressed: () => _onBackPressed(),
            buildContext: context,
            pageTitle: Constants.payment,
            actionList: const [],
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Consumer<PaymentProvider>(
              builder: (context, value, child) {
                return _switchView(paymentProvider);
              },
            ),
          )),
    );
  }

  _switchView(PaymentProvider paymentProvider) {
    Widget child = const SizedBox.shrink();
    switch (paymentProvider.loaderState) {
      case LoaderState.loaded:
        child = _mainView();
        break;
      case LoaderState.loading:
        child = const CommonLinearProgress();
        break;
      case LoaderState.error:
        child = ApiErrorScreens(
          loaderState: LoaderState.error,
          onTryAgain: initFunction,
        );
        break;
      case LoaderState.networkErr:
        child = ApiErrorScreens(
          loaderState: LoaderState.networkErr,
          onTryAgain: initFunction,
        );
        break;
      case LoaderState.noData:
        child = ApiErrorScreens(
          loaderState: LoaderState.noData,
          onTryAgain: initFunction,
        );
        break;
      case LoaderState.noProducts:
        child = ApiErrorScreens(
          loaderState: LoaderState.noProducts,
          onTryAgain: initFunction,
        );
        break;
    }
    return child;
  }

  _mainView() {
    return Stack(children: [
      WillPopScope(
        onWillPop: () => _onBackPressed(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12.w),
              //   color: HexColor('#FFFFFF'),
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         18.verticalSpace,
              //         Text(
              //           Constants.selectShippingMethod,
              //           style: FontPalette.black16Medium,
              //         ),
              //         25.verticalSpace,
              //         ShippingMethodView(
              //             paymentProvider: paymentProvider,
              //             selectAddressProvider:
              //                 widget.selectAddressProvider),
              //       ]),
              // ),
              //Divider(
              //                 height: 5.h,
              //                 thickness: 5.h,
              //                 color: HexColor("#F3F3F7"),
              //               ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                color: HexColor('#FFFFFF'),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.verticalSpace,
                      Text(
                        Constants.selectPaymentMethod,
                        style: FontPalette.black16Medium,
                      ),
                      5.verticalSpace,
                      PaymentMethodView(paymentProvider: paymentProvider)
                    ]),
              ),
              Divider(
                height: 5.h,
                thickness: 5.h,
                color: HexColor("#F3F3F7"),
              ),
              PaymentPriceDetailsWidget(
                  cartDataModel: context.read<CartProvider>().cartDataModel)
            ],
          ),
        ),
      ),
      PaymentBottomWidget(
          cartDataModel: context.read<CartProvider>().cartDataModel,
          isLoading: paymentProvider.btnLoaderState,
          paymentProvider: paymentProvider,
          enableBtn: paymentProvider.selectedPaymentMethod.isNotEmpty,
          onTap: () => paymentProvider.proceedCheckout(context, paymentProvider,
              widget.paymentArguments.selectAddressProvider))
    ]);
  }

  _onBackPressed() {
    if (paymentProvider.btnLoaderState) {
      paymentProvider.updateErrorMessage('Processing order data...');
      CommonFunctions.afterInit(
          () => Helpers.flushToast(context, msg: paymentProvider.errorMessage));
    } else {
      Navigator.pop(context);
    }
  }
}
