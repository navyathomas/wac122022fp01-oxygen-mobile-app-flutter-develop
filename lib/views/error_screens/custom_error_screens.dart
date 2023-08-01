import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/views/error_screens/widgets/custom_error_widget.dart';

import '../../widgets/custom_sliding_fade_animation.dart';

class CustomErrorScreen extends StatefulWidget {
  const CustomErrorScreen(
      {super.key, required this.errorType, this.onButtonPressed});

  final CustomErrorType errorType;
  final Function()? onButtonPressed;

  @override
  State<CustomErrorScreen> createState() => _CustomErrorScreenState();
}

class _CustomErrorScreenState extends State<CustomErrorScreen> {
  String _setPageTitle() {
    String pageTitle = '';
    switch (widget.errorType) {
      case CustomErrorType.myItemsEmpty:
        pageTitle = Constants.myItems;
        break;
      case CustomErrorType.myCartEmpty:
        pageTitle = Constants.myCart;
        break;
      case CustomErrorType.paymentFailed:
        pageTitle = Constants.orderComplete;
        break;
      case CustomErrorType.noOrders:
        pageTitle = Constants.myOrders;
        break;
      case CustomErrorType.searchNoData:
        pageTitle = Constants.searchForProducts;
        break;
    }
    return pageTitle;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sw(),
      child: CustomSlidingFadeAnimation(
        slideDuration: const Duration(milliseconds: 300),
        child: ErrorScreenWidget(
          type: widget.errorType,
          onButtonPressed: widget.onButtonPressed,
        ),
      ),
    );
  }
}
