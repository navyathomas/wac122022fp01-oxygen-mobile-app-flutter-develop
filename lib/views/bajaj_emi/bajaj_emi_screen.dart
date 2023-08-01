import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/views/bajaj_emi/widgets/flow_five.dart';
import 'package:oxygen/views/bajaj_emi/widgets/flow_four.dart';
import 'package:oxygen/views/bajaj_emi/widgets/flow_one.dart';
import 'package:oxygen/views/bajaj_emi/widgets/flow_three.dart';
import 'package:oxygen/views/bajaj_emi/widgets/flow_two.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/select_address_provider.dart';

class BajajEmiScreen extends StatefulWidget {
  final SelectAddressProvider selectAddressProvider;

  const BajajEmiScreen({
    Key? key,
    required this.selectAddressProvider,
  }) : super(key: key);

  @override
  State<BajajEmiScreen> createState() => _BajajEmiScreenState();
}

class _BajajEmiScreenState extends State<BajajEmiScreen> {
  late List<Widget> widgets;

  BajajEmiProvider? emiProvider;

  @override
  void initState() {
    super.initState();
    emiProvider = BajajEmiProvider();
    widgets = [
      const FlowOne(),
      const FlowTwo(),
      const FlowThree(),
      const FlowFour(),
      FlowFive(selectAddressProvider: widget.selectAddressProvider),
    ];
  }

  @override
  void dispose() {
    emiProvider?.dispose();
    super.dispose();
  }

  Future<bool> _handleBack() async {
    final currentPage = emiProvider?.pageController.page?.toInt();
    if (currentPage != null) {
      if (currentPage > 0) {
        if (currentPage == 4) {
          emiProvider?.pageController.jumpToPage(2);
          emiProvider?.changeLinearProgressValue(3.0);
          return false;
        } else {
          emiProvider?.pageController.jumpToPage(currentPage - 1);
          emiProvider?.changeLinearProgressValue(currentPage.toDouble());
          return false;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: emiProvider,
      child: WillPopScope(
        onWillPop: _handleBack,
        child: Scaffold(
          floatingActionButton:
              const WhatsappChatWidget().bottomPadding(padding: 75),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          appBar: CommonAppBar(
            buildContext: context,
            pageTitle: Constants.bajajEmiOption,
            actionList: const [],
          ),
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<BajajEmiProvider, double>(
                  selector: (context, provider) => provider.linearProgressValue,
                  builder: (context, value, child) {
                    return TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: value,
                      ),
                      builder: (context, value, _) => SizedBox(
                          height: 2.h,
                          child: LinearProgressIndicator(value: value)),
                    );
                  }),
              Expanded(
                child: PageView.builder(
                  controller: emiProvider?.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    return widgets.elementAt(index);
                  },
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
