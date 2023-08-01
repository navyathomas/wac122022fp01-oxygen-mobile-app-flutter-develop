import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/my_order_details_arguments.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/order_detail/widgets/order_detail_delivery_address_widget.dart';
import 'package:oxygen/views/order_detail/widgets/order_detail_price_details_widget.dart';
import 'package:oxygen/views/order_detail/widgets/order_detail_top_widget.dart';
import 'package:oxygen/views/order_detail/widgets/order_detail_tracking_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, required this.myOrderDetailsArguments})
      : super(key: key);

  final MyOrderDetailsArguments myOrderDetailsArguments;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.myOrderDetailsArguments.myOrdersProvider,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: const WhatsappChatWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: Constants.orderDetail,
          actionList: [
            TextButton(
              onPressed: () => Navigator.pushNamed(
                  context, RouteGenerator.routeFaqAndHelpScreen),
              child: const Text(Constants.help),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                OrderDetailTopWidget(
                  products: widget.myOrderDetailsArguments.products,
                  status: widget.myOrderDetailsArguments.status,
                  id: widget.myOrderDetailsArguments.id,
                ),
                OrderDetailTrackingWidget(
                  status: widget.myOrderDetailsArguments.status,
                  currentStatus: widget.myOrderDetailsArguments.currentStatus,
                  orderProcess: widget.myOrderDetailsArguments.orderProcess,
                  createdAt: widget.myOrderDetailsArguments.createdAt,
                  orderNumber: widget.myOrderDetailsArguments.orderNumber,
                  paymentMethod: widget.myOrderDetailsArguments.paymentMethod,
                ),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                OrderDetailDeliveryAddressWidget(
                  address: widget.myOrderDetailsArguments.address,
                ),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                OrderDetailPriceDetailsWidget(
                  excludingTax: widget.myOrderDetailsArguments.excludingTax,
                  includingTax: widget.myOrderDetailsArguments.includingTax,
                  gst: widget.myOrderDetailsArguments.gst,
                  grandTotal: widget.myOrderDetailsArguments.grandTotal,
                  discount: widget.myOrderDetailsArguments.discount,
                  shippingFee: widget.myOrderDetailsArguments.shippingFee,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
