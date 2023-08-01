import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/loyalty_point_model.dart';
import 'package:oxygen/providers/loyalty_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/loyalty/widgets/loyalty_bill_point_view.dart';
import 'package:oxygen/views/loyalty/widgets/loyalty_bill_tile.dart';
import 'package:oxygen/views/loyalty/widgets/loyalty_product_point_view.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/jumping_dots.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';

import '../../common/constants.dart';
import '../../widgets/custom_sliding_fade_animation.dart';
import '../error_screens/api_error_screens.dart';
import '../error_screens/custom_error_screens.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({Key? key}) : super(key: key);

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  late final LoyaltyProvider loyaltyProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.loyalty,
        actionList: const [],
      ),
      body: ChangeNotifierProvider.value(
        value: loyaltyProvider,
        child: Column(
          children: [
            Selector<LoyaltyProvider, int?>(
              selector: (context, provider) => provider.totalRewards,
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.fromSize(
                      size: Size.fromHeight(context.sw(size: 0.17)),
                      child: SvgPicture.asset(
                        Assets.imagesLoyaltyBg,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.5.w, right: 22.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              Constants.totalLoyaltyPoints,
                              style: FontPalette.white20Medium,
                            ),
                          ),
                          (value == null
                                  ? const JumpingDots()
                                  : Row(
                                      children: [
                                        SvgPicture.asset(
                                          Assets.iconsLoyaltyCoin,
                                        ),
                                        6.7.horizontalSpace,
                                        Text(
                                          '$value',
                                          style: FontPalette.fF2DA81_26Medium,
                                        )
                                      ],
                                    ))
                              .animatedSwitch()
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            Expanded(
                child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Material(
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: HexColor('#E6E6E6'),
                    child: TabBar(
                        unselectedLabelStyle: FontPalette.black16Medium,
                        labelStyle: FontPalette.black16Medium,
                        labelColor: Colors.black,
                        indicatorColor: ColorPalette.primaryColor,
                        unselectedLabelColor: Colors.black,
                        labelPadding: EdgeInsets.only(top: 6.h),
                        tabs: const [
                          Tab(
                            text: Constants.productPoints,
                          ),
                          Tab(
                            text: Constants.billPoints,
                          )
                        ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        LoyaltyProductPointView(
                          onRefresh: () async {
                            await loyaltyProvider.getLoyaltyProductPoints();
                          },
                        ),
                        LoyaltyBillPointView(
                          onRefresh: () async {
                            await loyaltyProvider.getLoyaltyBillPoints();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    loyaltyProvider = LoyaltyProvider();
    CommonFunctions.afterInit(() {
      loyaltyProvider
        ..getLoyaltyTotalPoints()
        ..getLoyaltyProductPoints()
        ..getLoyaltyBillPoints();
    });
    super.initState();
  }

  @override
  void dispose() {
    loyaltyProvider.dispose();
    super.dispose();
  }
}
