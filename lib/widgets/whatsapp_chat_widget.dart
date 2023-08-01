import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/app_data_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappChatWidget extends StatefulWidget {
  const WhatsappChatWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<WhatsappChatWidget> createState() => _WhatsappChatWidgetState();
}

class _WhatsappChatWidgetState extends State<WhatsappChatWidget>
    with WidgetsBindingObserver {
  ValueNotifier<bool> showKeyBoard = ValueNotifier<bool>(false);

  void checkVisibility() {
    if (WidgetsBinding.instance.window.viewInsets.bottom == 0) {
      showKeyBoard.value = false;
    } else {
      showKeyBoard.value = true;
    }
  }

  @override
  void didChangeMetrics() {
    checkVisibility();
    super.didChangeMetrics();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    showKeyBoard.dispose();
    super.dispose();
  }

  void openWhatsAppChat(String phoneNumber) async {
    final url = 'https://wa.me/$phoneNumber';
    try {
      final canLaunch = await canLaunchUrl(Uri.parse(url));
      if (canLaunch) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Error opening WhatsApp');
      }
    } on PlatformException catch (e) {
      debugPrint('Error opening WhatsApp: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKeyBoard,
      builder: (context, keyboardValue, child) {
        return (keyboardValue
                ? const SizedBox.shrink()
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 50.r,
                        width: 50.r,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: HexColor("#25D366")),
                        child: Center(
                            child: SvgPicture.asset(
                          Assets.iconsWhatsappChat,
                          fit: BoxFit.cover,
                          height: 48.r,
                          width: 48.r,
                        )),
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white.withOpacity(.10),
                            customBorder: const CircleBorder(),
                            onTap: () {
                              final model = context.read<AppDataProvider>();
                              if (model.whatsappModel?.mobileNumber != null) {
                                openWhatsAppChat(
                                    model.whatsappModel!.mobileNumber!);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ))
            .animatedSwitch(reverseDuration: 0);
      },
    );
  }
}
