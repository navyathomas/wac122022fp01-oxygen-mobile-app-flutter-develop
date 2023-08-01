import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/emi_plans_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/emi_options/widgets/emi_expanded_widget.dart';
import 'package:oxygen/views/emi_options/widgets/emi_expansion_tile_widget.dart';
import 'package:oxygen/views/emi_options/widgets/emi_options_top_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import '../../common/constants.dart';

class EmiOptionsScreen extends StatefulWidget {
  final Item? item;
  final EmiPlansData? emiPlans;
  final Future<void> Function() onRefresh;
  const EmiOptionsScreen(
      {Key? key, this.item, this.emiPlans, required this.onRefresh})
      : super(key: key);

  @override
  State<EmiOptionsScreen> createState() => _EmiOptionsScreenState();
}

class _EmiOptionsScreenState extends State<EmiOptionsScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.emiOptions,
        actionList: const [],
      ),
      body: SafeArea(
        child: Builder(builder: (context) {
          if (widget.emiPlans?.getBankEmiByProductSku == null ||
              (widget.emiPlans?.getBankEmiByProductSku?.isEmpty ?? true)) {
            return const CommonLinearProgress();
          } else {
            final emiPlans = widget.emiPlans;
            final tabLength = emiPlans?.getBankEmiByProductSku?.length;
            tabController = TabController(length: tabLength ?? 0, vsync: this);
            return Column(
              children: [
                EmiOptionsTopWidget(item: widget.item),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: tabLength ?? 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.white,
                          elevation: 1,
                          shadowColor: HexColor('#E6E6E6'),
                          child: TabBar(
                            controller: tabController,
                            unselectedLabelStyle: FontPalette.black16Medium,
                            labelStyle: FontPalette.black16Medium,
                            isScrollable: true,
                            labelColor: Colors.black,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  width: 3, color: ColorPalette.primaryColor),
                            ),
                            unselectedLabelColor: Colors.black,
                            labelPadding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 12.w),
                            tabs: List.generate(tabLength ?? 0, (index) {
                              final tabItem = emiPlans?.getBankEmiByProductSku
                                  ?.elementAt(index);
                              return Text(
                                tabItem?.title ?? "",
                                style: FontPalette.black14Medium
                                    .copyWith(fontWeight: FontWeight.w600),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: List.generate(tabLength ?? 0, (index) {
                              final tabItem = emiPlans?.getBankEmiByProductSku
                                  ?.elementAt(index);
                              return RefreshIndicator(
                                onRefresh: widget.onRefresh,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  itemCount: tabItem?.bank?.length,
                                  itemBuilder: (context, viewIndex) {
                                    final item = emiPlans
                                        ?.getBankEmiByProductSku
                                        ?.elementAt(index)
                                        ?.bank
                                        ?.elementAt(viewIndex);
                                    return EmiExpansionTileWidget(
                                      backgroundColor: Colors.white,
                                      title: item?.name,
                                      image: item?.logo,
                                      expandedWidget:
                                          EmiExpandedWidget(plans: item?.plans),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
