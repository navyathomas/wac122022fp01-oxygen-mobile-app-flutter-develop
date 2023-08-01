import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/faq_list_model.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';

class FaqDetailView extends StatelessWidget {
  const FaqDetailView({super.key, this.faq});

  final FaQs? faq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.helpAndFaqs,
        actionList: const [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            18.verticalSpace,
            Text(
              faq?.question ?? '',
              style: FontPalette.black18Medium,
            ),
            12.73.verticalSpace,
            Text(
              faq?.answer ?? '',
              style: FontPalette.f282C3F_14Regular.copyWith(height: 1.7),
            )
          ],
        ),
      ),
    );
  }
}
