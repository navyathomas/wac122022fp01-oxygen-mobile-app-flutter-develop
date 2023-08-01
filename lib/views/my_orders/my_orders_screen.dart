import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/arguments/my_order_details_arguments.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/error_screens/custom_error_screens.dart';
import 'package:oxygen/views/my_orders/widgets/my_orders_product_widget.dart';
import 'package:oxygen/views/my_orders/widgets/offline_orders_view.dart';
import 'package:oxygen/views/my_orders/widgets/online_purchase_view.dart';
import 'package:oxygen/views/order_detail/order_detail_screen.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../common/route_generator.dart';
import '../../utils/font_palette.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late final MyOrdersProvider myOrdersOnlineProvider;
  late final MyOrdersProvider myOrdersOfflineProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.myOrders,
        actionList: const [],
      ),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: myOrdersOnlineProvider,
          child: ChangeNotifierProvider.value(
            value: myOrdersOfflineProvider,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: HexColor('#E6E6E6')))),
                    child: TabBar(
                        unselectedLabelStyle: FontPalette.black16Medium,
                        labelStyle: FontPalette.black16Medium,
                        labelColor: Colors.black,
                        indicatorColor: ColorPalette.primaryColor,
                        unselectedLabelColor: Colors.black,
                        labelPadding: EdgeInsets.only(top: 3.h),
                        tabs: const [
                          Tab(
                            text: Constants.onlinePurchase,
                          ),
                          Tab(
                            text: Constants.offlinePurchase,
                          )
                        ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        OnlinePurchase(
                          myOrdersProvider: myOrdersOnlineProvider,
                        ),
                        OfflineOrdersView(
                          myOrdersProvider: myOrdersOfflineProvider,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    myOrdersOnlineProvider = MyOrdersProvider();
    myOrdersOfflineProvider = MyOrdersProvider();
    super.initState();
  }

  @override
  void dispose() {
    myOrdersOnlineProvider.dispose();
    myOrdersOfflineProvider.dispose();
    super.dispose();
  }
}
