import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/contact_us_data_model.dart';
import 'package:oxygen/providers/contact_us_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/contact_us_screen/widgets/contact_us_tile.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  double? defaultStatusBarHeight;
  late final ContactUsProvider contactUsProvider;

  Widget buildContactusView(ContactUsDataModel? model) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            final addressList = model?.address ?? <Address>[];
            return ContactUsTileWidget(
              heading: addressList[index].title ?? '',
              text: addressList[index].content ?? '',
              onTap: () {
                double? lat = double.tryParse(contactUsProvider
                    .contactUsDataModel?.locationData?[0].latitude);
                double? long = double.tryParse(contactUsProvider
                    .contactUsDataModel?.locationData?[0].longitude);
                if (lat != null && long != null) {
                  openDirection(lat, long);
                }
              },
            );
          },
          itemCount: model?.address?.length ?? 0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            final emailList = model?.email ?? <Email>[];
            return ContactUsTileWidget(
              heading: emailList[index].title ?? '',
              textWidget: Text(
                emailList[index].content ?? '',
                style: FontPalette.f282C3F_14Medium,
              ),
              onTap: () => mailTo(emailList[index].content ?? ''),
            );
          },
          itemCount: model?.email?.length ?? 0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            final showroomList = model?.showroom ?? <Showroom>[];
            return ContactUsTileWidget(
              heading: showroomList[index].title ?? '',
              hasPhoneNumber: showroomList[index].call != null,
              phoneNumber: showroomList[index].call,
              text: showroomList[index].hour,
              onTap: () => showroomList[index].call != null
                  ? callTo(showroomList[index].call ?? '')
                  : null,
            );
          },
          itemCount: model?.showroom?.length ?? 0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            final supportList = model?.support ?? <Support>[];
            return ContactUsTileWidget(
              heading: supportList[index].title ?? '',
              hasPhoneNumber: supportList[index].call != null,
              phoneNumber: supportList[index].call,
              text: supportList[index].hour,
              onTap: () => supportList[index].call != null
                  ? callTo(supportList[index].call ?? '')
                  : null,
            );
          },
          itemCount: model?.support?.length ?? 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: contactUsProvider,
      child: Scaffold(
        floatingActionButton: const WhatsappChatWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top == 0
                      ? (defaultStatusBarHeight ?? 0.0)
                      : MediaQuery.of(context).viewPadding.top),
              child: Container(
                height: kToolbarHeight,
                width: context.sw(),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.75,
                      color: HexColor('#E6E6E6'),
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: -5.w,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: SvgPicture.asset(
                          Assets.iconsArrowLeft,
                          height: 14.h,
                          width: 14.w,
                        ),
                      ),
                    ),
                    Text(
                      Constants.contactUs,
                      style: FontPalette.black18Medium
                          .copyWith(color: HexColor('#282C3F')),
                    ),
                  ],
                ),
              ),
            ),
            Selector<ContactUsProvider,
                Tuple2<LoaderState, ContactUsDataModel?>>(
              selector: (_, provider) =>
                  Tuple2(provider.loaderState, provider.contactUsDataModel),
              builder: (_, data, __) {
                switch (data.item1) {
                  case LoaderState.loaded:
                    return CustomSlidingFadeAnimation(
                      slideDuration: const Duration(milliseconds: 250),
                      child: buildContactusView(data.item2),
                    );
                  case LoaderState.loading:
                    return const CommonLinearProgress();
                  case LoaderState.error:
                    return Consumer<ContactUsProvider>(
                        builder: (_, p, __) => CustomSlidingFadeAnimation(
                              slideDuration: const Duration(milliseconds: 250),
                              child: ApiErrorScreens(
                                loaderState: data.item1,
                                btnLoader: p.btnLoaderState,
                                onTryAgain: () =>
                                    p.getContactUsData(tryAgain: true),
                              ),
                            ));
                  case LoaderState.networkErr:
                    return Consumer<ContactUsProvider>(
                        builder: (_, p, __) => CustomSlidingFadeAnimation(
                              slideDuration: const Duration(milliseconds: 250),
                              child: ApiErrorScreens(
                                loaderState: data.item1,
                                btnLoader: p.btnLoaderState,
                                onTryAgain: () =>
                                    p.getContactUsData(tryAgain: true),
                              ),
                            ));
                  case LoaderState.noData:
                    return const SizedBox.shrink();
                  case LoaderState.noProducts:
                    return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    contactUsProvider = ContactUsProvider();
    CommonFunctions.afterInit(() async {
      defaultStatusBarHeight = MediaQuery.of(context).viewPadding.top;
      await contactUsProvider.getContactUsData();
    });
  }

  Future<void> openDirection(double? lat, long) async {
    var fallbackUrl = 'geo:$lat,$long';
    var url = Platform.isAndroid
        ? 'google.navigation:q=$lat,$long&mode=d'
        : 'https://maps.apple.com/?q=$lat,$long';
    try {
      bool launched = await launchUrl(Uri.parse(url));
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  Future<void> mailTo(String mail, {String? subject, String? body}) async {
    Uri uri =
        Uri.parse("mailto:$mail?subject=${subject ?? ''}&body=${body ?? ''}");
    await launchUrl(uri);
  }

  Future<void> callTo(String phone) async {
    String phoneNumber = Uri.encodeComponent(phone);
    Uri uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri);
  }
}
