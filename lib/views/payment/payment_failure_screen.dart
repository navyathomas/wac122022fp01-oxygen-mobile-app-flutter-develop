import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/extensions.dart';
import '../../common/route_generator.dart';
import '../../repositories/cart_repo.dart';
import '../error_screens/custom_error_screens.dart';

class PaymentFailureScreen extends StatefulWidget {
  const PaymentFailureScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFailureScreen> createState() => _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailureScreen> {
  late final ValueNotifier<bool> loaderState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(
                context, RouteGenerator.routeFaqAndHelpScreen),
            child: Text(
              Constants.help,
              style: FontPalette.f282C3F_16Regular,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () => onWillPop(),
        child: SafeArea(
            child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: loaderState,
                builder: (context, value, _) {
                  return WidgetExtension.crossSwitch(
                      first: const CommonLinearProgress(), value: value);
                }),
            const Expanded(
                child: CustomErrorScreen(
                    errorType: CustomErrorType.paymentFailed)),
            Padding(
              padding: EdgeInsets.only(
                  left: 13.w, right: 13.w, bottom: 15.h, top: 10.h),
              child: CustomButton(
                height: 45.h,
                title: Constants.tryAgain,
                onPressed: () async {
                  await _onBackPress();
                  if (mounted) {
                    NavRoutes.instance
                        .popUntil(context, RouteGenerator.routeMainScreen);
                  }
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    loaderState = ValueNotifier(false);
    super.initState();
  }

  Future<void> _onBackPress() async {
    loaderState.value = true;
    await CartRepo.restoreCustomerCart();
    if (mounted) context.read<CartProvider>().getCartDataList();
    loaderState.value = false;
  }

  Future<bool> onWillPop() async {
    if (loaderState.value) return false;
    await _onBackPress();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.routeMainScreen, (route) => false);
    }
    return false;
  }
}
