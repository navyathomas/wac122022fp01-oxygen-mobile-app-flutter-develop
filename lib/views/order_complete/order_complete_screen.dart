import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/order_details_response_model.dart';
import 'package:oxygen/providers/payment_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/order_complete/widgets/continue_shopping_button.dart';
import 'package:oxygen/views/order_complete/widgets/date_payment_method_widget.dart';
import 'package:oxygen/views/order_complete/widgets/order_complete_success_widget.dart';
import 'package:oxygen/views/order_complete/widgets/price_details_widget.dart';
import 'package:oxygen/views/order_complete/widgets/product_details_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../services/helpers.dart';

class OrderCompleteScreen extends StatefulWidget {
  const OrderCompleteScreen({Key? key, required this.paymentProvider})
      : super(key: key);
  final PaymentProvider paymentProvider;

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  late PaymentProvider paymentProvider;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  initFunction() {
    paymentProvider = PaymentProvider();
    paymentProvider.updateLoadState(LoaderState.loading);
    CommonFunctions.afterInit(() {
      paymentProvider.getOrderDetails(
          onFailure: () =>
              Helpers.flushToast(context, msg: paymentProvider.errorMessage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: Constants.orderComplete,
          alignCenter: true,
          enableNavBack: false,
          actionList: [
            InkWell(
              highlightColor: Colors.grey.shade200,
              splashColor: Colors.grey.shade300,
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              onTap: () => _navigateToHomePage(context)
                  .clearFilterMap(isFromSort: false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.5.w),
                alignment: Alignment.center,
                child: Text(
                  Constants.close,
                  style: FontPalette.black16Regular
                      .copyWith(color: HexColor('#282C3F')),
                ),
              ),
            )
          ],
        ),
        backgroundColor: HexColor('#F3F3F7'),
        body: SafeArea(
            child: ChangeNotifierProvider.value(
                value: paymentProvider,
                child: Selector<PaymentProvider, LoaderState>(
                  selector: (context, paymentProvider) =>
                      paymentProvider.loaderState,
                  builder: (context, value, child) {
                    return _switchView(value);
                  },
                ))));
  }

  _switchView(LoaderState loaderState) {
    Widget child = const SizedBox.shrink();
    switch (loaderState) {
      case LoaderState.loading:
        debugPrint('loading worked');
        child = const CommonLinearProgress();
        break;
      case LoaderState.loaded:
        debugPrint('loaded worked');
        child = _mainView();
        break;
      case LoaderState.error:
        child = ApiErrorScreens(
          loaderState: LoaderState.error,
          onTryAgain: () => paymentProvider.getOrderDetails(),
        );
        break;
      case LoaderState.networkErr:
        ApiErrorScreens(
          loaderState: LoaderState.networkErr,
          onTryAgain: () => paymentProvider.getOrderDetails(),
        );
        break;
      case LoaderState.noData:
        break;
      case LoaderState.noProducts:
        break;
    }
    return child;
  }

  _mainView() {
    OrderDetailsItems? orderDetailsItems =
        (paymentProvider.orderDetailsData?.customerOrders?.items ?? [])
                .isNotEmpty
            ? paymentProvider.orderDetailsData!.customerOrders!.items![0]
            : null;
    return WillPopScope(
      onWillPop: () => _navigateToHomePage(context),
      child: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              OrderCompleteSuccessWidget(
                orderNumber: orderDetailsItems?.orderNumber ?? '',
              ),
              5.verticalSpace,
              Container(
                  padding: EdgeInsets.only(
                      right: 13.w, top: 19.h, bottom: 11.h, left: 11.w),
                  color: HexColor('#FFFFFF'),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderDetailsItems?.products?.length ?? 0,
                    itemBuilder: (context, index) {
                      return OrderCompleteProductDetailsWidget(
                        orderDetailsProducts: paymentProvider.orderDetailsData
                            ?.customerOrders?.items?[0].products?[index],
                        index: index,
                        length: paymentProvider.orderDetailsData!
                            .customerOrders!.items![0].products!.length,
                      );
                    },
                  )),
              5.verticalSpace,
              DatePaymentMethodWidget(
                paymentMethod:
                    orderDetailsItems?.orderPaymentMethod?.methodTitle ?? '',
              ),
              5.verticalSpace,
              PriceDetailsWidget(
                orderDetailsItems: orderDetailsItems,
                orderDetailsPrices: orderDetailsItems?.prices,
              )
            ],
          ),
        ),
        ContinueShoppingButton(
          onTap: () => _navigateToHomePage(context),
        )
      ]),
    );
  }

  _navigateToHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.routeMainScreen, (route) => false);
  }
}
