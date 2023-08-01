import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/order_complete_arguments.dart';
import 'package:oxygen/models/arguments/payment_web_view_arguments.dart';
import 'package:oxygen/models/order_details_response_model.dart';
import 'package:oxygen/models/order_response_model.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/repositories/app_data_repo.dart';
import 'package:oxygen/repositories/authentication_repo.dart';
import 'package:oxygen/repositories/bajaj_emi_repo.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:provider/provider.dart';

import '../common/constants.dart';
import '../models/error_model.dart';
import '../models/payment_modes_model.dart';
import '../services/helpers.dart';
import '../services/service_config.dart';

class PaymentProvider extends ChangeNotifier with ProviderHelperClass {
  bool isSelected = false;

  // PaymentMethodData? paymentMethodResponse;
  PaymentModesModel? paymentModesModel;

  //String selectedPaymentMode = '';
  int selectedShippingMethodIndex = 0;

  // List<AvailablePaymentMethods> availablePaymentModes = [];
  String errorMessage = '';
  String selectedPaymentMethod = '';
  String? methodCode;
  String? carrierCode;
  OrderData? orderResponse;
  String? contentBase64;
  OrderDetailsData? orderDetailsData;
  bool _disposed = false;
  static const String onlinePayment = 'online_payment';
  static const String cod = 'cashondelivery';
  static const String payWithBajaj = 'bajajemi';

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

/*  Future<void> getPaymentMethods(
      {Function? onSuccess,
      Function? onFailure,
      bool navFromBajaj = false}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getPaymentMethods();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null) {
          paymentMethodResponse = PaymentMethodData.fromJson(resp);
          availablePaymentModes =
              paymentMethodResponse?.cart?.availablePaymentModes ?? [];
          if (navFromBajaj) {
            availablePaymentModes = availablePaymentModes
                .where((element) =>
                    (element.code ?? '').toLowerCase() == payNowKey)
                .toList();
          }
          if (availablePaymentModes.isNotEmpty) {
            updateSelectedPaymentMode(availablePaymentModes[0].code ?? '');
          }
          if ((paymentMethodResponse?.cart?.availablePaymentMethods ?? [])
              .isNotEmpty) {
            updateSelectedPaymentMethod(
                paymentMethodResponse?.cart?.availablePaymentMethods![0].code ??
                    '');
          }
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }*/

  Future<void> getAvailablePaymentModes(
      {Function? onSuccess,
      Function? onFailure,
      bool navFromBajaj = false}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getAvailablePaymentModes();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null) {
          paymentModesModel = PaymentModesModel.fromJson(resp);
          if (navFromBajaj &&
              paymentModesModel?.getMobileAppPaymentModes != null) {
            List<GetMobileAppPaymentModes>? availablePaymentModes =
                paymentModesModel?.getMobileAppPaymentModes!
                    .where((element) =>
                        (element.type ?? '').toLowerCase() == onlinePayment)
                    .toList();
            paymentModesModel = PaymentModesModel(
                getMobileAppPaymentModes: availablePaymentModes);
            notifyListeners();
          }
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  Future<bool> setPaymentMethod() async {
    bool resFlag = false;
    try {
      var resp = await serviceConfig.setPaymentMethod(selectedPaymentMethod);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        resFlag = false;
      } else {
        if (resp['setPaymentMethodOnCart'] != null) {
          resFlag = true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            resFlag = false;
          }
        }
      }
    } catch (e) {
      resFlag = false;
    }
    return resFlag;
  }

  Future<void> proceedCheckout(
      BuildContext context,
      PaymentProvider paymentProvider,
      SelectAddressProvider selectAddressProvider) async {
    switch (selectedPaymentMethod) {
      case cod:
        proceedPayOnline(
            onFailure: (bool val) {},
            onSuccess: (OrderData data) {
              Navigator.pushNamed(
                  context, RouteGenerator.routeOrderCompleteScreen,
                  arguments:
                      OrderCompleteArguments(paymentProvider: paymentProvider));
            });
        break;

      case payWithBajaj:
        Navigator.pushNamed(context, RouteGenerator.routeBajajEmi,
                arguments: selectAddressProvider)
            .then((value) async {
          updateLoadState(LoaderState.loading);
          await BajajEmiRepo.unsetBajajEmiDetails();
          await Future.microtask(
              () => context.read<CartProvider>().getCartDataList());
          paymentProvider.getAvailablePaymentModes(navFromBajaj: false);
          paymentProvider.updateShippingMethodCode(
              shippingMethodCode: selectAddressProvider
                      .availableShippingMethods[0].methodCode ??
                  '',
              shippingCarrierMode: selectAddressProvider
                      .availableShippingMethods[0].carrierCode ??
                  '');
        });
        break;

      default:
        proceedPayOnline(
            onFailure: (bool val) {},
            onSuccess: (OrderData data) {
              String actionUrl =
                  orderResponse?.placeOrder?.order?.actionUrlMob ?? '';
              Navigator.pushNamed(context, RouteGenerator.routePaymentWebView,
                      arguments: PaymentWebViewArguments(
                          actionUrl: actionUrl,
                          paymentProvider: paymentProvider))
                  .then((value) {
                if (value.runtimeType == int) {
                  if (value == 1) {
                    Navigator.pushReplacementNamed(
                        context, RouteGenerator.routeOrderCompleteScreen,
                        arguments: OrderCompleteArguments(
                            paymentProvider: paymentProvider));
                  } else if (value == 0) {
                    Navigator.pushReplacementNamed(
                      context,
                      RouteGenerator.routePaymentError,
                    );
                  }
                }
              });
            });
    }
  }

  Future<void> proceedPayOnline(
      {required Function(OrderData) onSuccess,
      required Function(bool) onFailure}) async {
    updateBtnLoaderState(true);
    final shippingRes = await setShippingMethod();
    if (!shippingRes) {
      updateBtnLoaderState(false);
      return;
    }
    final paymentRes = await setPaymentMethod();
    if (!paymentRes) {
      updateBtnLoaderState(false);
      return;
    }
    final placeOrderRes = await placeOrder();
    if (placeOrderRes == null) {
      updateBtnLoaderState(false);
      onFailure(true);
      return;
    }
    await AuthenticationRepo.createCustomerCart(cacheCart: true);
    await AppDataRepo.getAppData();
    updateBtnLoaderState(false);
    onSuccess(placeOrderRes);
  }

  Future<bool> setShippingMethod() async {
    bool resFlag = false;
    try {
      var resp = await serviceConfig.setShippingMethod(
          carrierCode ?? '', methodCode ?? '');
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        resFlag = false;
      } else {
        if (resp['setShippingMethodsOnCart'] != null) {
          resFlag = true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            resFlag = false;
          }
        }
      }
    } catch (e) {
      resFlag = false;
    }
    return resFlag;
  }

  Future<OrderData?> placeOrder() async {
    OrderData? orderData;
    try {
      var resp = await serviceConfig.placeOrder();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['placeOrder'] != null) {
          orderResponse = OrderData.fromJson(resp);
          orderData = orderResponse;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
          } else {
            errorMessage = 'Oops...! Order Not Completed';
          }
          Helpers.successToast(errorMessage);
        }
      }
    } catch (e) {
      orderData = null;
    }
    return orderData;
  }

  Future<void> completePayment(BuildContext context,
      {Function? webViewFunction, Function? orderSuccessFlowSuccess}) async {
    updateBtnLoaderState(true);
    if (selectedPaymentMethod == 'cashondelivery') {
      orderSuccessFlow(context, onSuccess: orderSuccessFlowSuccess);
    } else {
      CommonFunctions.afterInit(() {
        if (webViewFunction != null) webViewFunction();
        updateBtnLoaderState(false);
      });
    }
  }

  orderSuccessFlow(BuildContext context, {Function? onSuccess}) {
    if (onSuccess != null) onSuccess();
    // AuthenticationRepo.createCustomerCart(cacheCart: true).then((value) async {
    //   if (value.notEmpty) {
    //     await AppDataRepo.getAppData();
    //     CommonFunctions.afterInit(() {
    //       //Helpers.flushToast(context, msg: 'Order successfully completed....!');
    //       Navigator.pushNamed(context, RouteGenerator.routeOrderCompleteScreen,arguments: OrderCompleteArguments(paymentProvider: paymentProvider));
    //     });
    //   } else {
    //     restoreCustomerCart();
    //   }
    //   updateBtnLoaderState(false);
    // });
  }

  Future<void> getOrderDetails({Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getOrderDetails();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null && resp['customerOrders'] != null) {
          orderDetailsData = OrderDetailsData.fromJson(resp);
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  updateSelectedPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  updateSelectedShippingMethodIndex(int index) {
    selectedShippingMethodIndex = index;
    notifyListeners();
  }

  /* updateSelectedPaymentMode(String code) {
    selectedPaymentMode = code;
    notifyListeners();
  }*/

/*
  void setChildAsSelected(String code) {
    if (selectedPaymentMode.toLowerCase() == payNowKey) {
      if ((paymentMethodResponse?.cart?.availablePaymentMethods ?? [])
          .isNotEmpty) {
        updateSelectedPaymentMethod(
            paymentMethodResponse?.cart?.availablePaymentMethods![0].code ??
                '');
      }
    } else {
      updateSelectedPaymentMethod(code);
    }
  }
*/

  updateShippingMethodCode(
      {required String shippingMethodCode,
      required String shippingCarrierMode}) {
    methodCode = shippingMethodCode;
    carrierCode = shippingCarrierMode;
    notifyListeners();
  }

  updateErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }
}
