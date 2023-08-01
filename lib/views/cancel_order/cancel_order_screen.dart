import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/cancel_order/widgets/cancel_order_reason_widget.dart';
import 'package:oxygen/views/cancel_order/widgets/cancel_order_top_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';

class CancelOrderScreen extends StatelessWidget {
  const CancelOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.cancelOrder,
        actionList: const [],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CancelOrderTopWidget(),
            Divider(
              height: 5.h,
              thickness: 5.h,
              color: HexColor("#F3F3F7"),
            ),
            const Expanded(child: CancelOrderReasonWidget())
          ],
        ),
      ),
    );
  }
}
