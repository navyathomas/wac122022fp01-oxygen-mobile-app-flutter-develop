import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../common/common_function.dart';
import '../../common/nav_routes.dart';
import '../../models/arguments/main_screen_arguments.dart';
import '../../services/hive_services.dart';
import '../../utils/color_palette.dart';
import '../../utils/font_palette.dart';
import '../../widgets/three_bounce.dart';
import 'widgets/count_down.dart';

class AuthOtpScreen extends StatefulWidget {
  final NavFrom? navFrom;

  const AuthOtpScreen({Key? key, this.navFrom = NavFrom.navFromLogin})
      : super(key: key);

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  late final TextEditingController _inputController;
  late ValueNotifier<int> currentMicroSeconds;

  PinTheme defaultTheme(double width) => PinTheme(
        width: width,
        height: width,
        textStyle: FontPalette.black20Medium,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: HexColor('#DBDBDB')),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 42.5.w,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.7.h, top: 3.h),
                        child: Text(
                          Constants.enterOtp,
                          style: FontPalette.black26Medium,
                        ),
                      ),
                      Text(
                        Constants.enterOtpToVerifyCode,
                        style: FontPalette.f7E818C_16Regular,
                      ),
                      Row(
                        children: [
                          Selector<AuthProvider, String>(
                            selector: (context, provider) =>
                                provider.auhInputData,
                            builder: (context, value, child) {
                              return Text(
                                value,
                                style: FontPalette.f282C3F_16Bold,
                              );
                            },
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 7.h),
                              child: Text(
                                Constants.change,
                                style: FontPalette.f179614_16Regular,
                              ),
                            ),
                          ).removeSplash(),
                        ],
                      ),
                      43.27.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              double width =
                                  190.w < (constraints.maxWidth - 40.w)
                                      ? 190.w / 4
                                      : ((constraints.maxWidth - 40.w) / 4);
                              return Selector<AuthProvider, String>(
                                selector: (context, provider) =>
                                    provider.otpErrorMsg,
                                builder: (context, value, child) {
                                  return Pinput(
                                    androidSmsAutofillMethod:
                                        AndroidSmsAutofillMethod
                                            .smsUserConsentApi,
                                    controller: _inputController,
                                    autofocus: true,
                                    defaultPinTheme: defaultTheme(width),
                                    focusedPinTheme: defaultTheme(width)
                                        .copyDecorationWith(
                                            border: Border.all(
                                                color: HexColor('#282C3F'))),
                                    errorPinTheme: defaultTheme(width)
                                        .copyDecorationWith(
                                            border: Border.all(
                                                color: HexColor('#E50019'))),
                                    submittedPinTheme: defaultTheme(width),
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    forceErrorState: value.isNotEmpty,
                                    onChanged: (val) => context
                                        .read<AuthProvider>()
                                        .updateOtpErrorMsg(''),
                                    inputFormatters: Validator.inputFormatter(
                                            InputFormatType.phoneNumber) ??
                                        [],
                                    onCompleted: onComplete,
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      Selector<AuthProvider, String>(
                        selector: (context, provider) => provider.otpErrorMsg,
                        builder: (context, value, child) {
                          return (value.isNotEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.h),
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: FontPalette.fE50019_12Regular,
                                      ),
                                    )
                                  : const SizedBox.shrink())
                              .animatedSwitch();
                        },
                      ),
                      SizedBox(
                        height: 80.h,
                        child: Selector<AuthProvider, LoaderState>(
                          selector: (context, provider) => provider.loaderState,
                          builder: (context, value, child) {
                            return (value.isLoading
                                    ? ThreeBounce(
                                        color: ColorPalette.primaryColor,
                                        size: 30.r,
                                      )
                                    : Countdown(
                                        seconds: 30,
                                        currentMicroSeconds:
                                            currentMicroSeconds,
                                        onTap: onResendTap,
                                      ))
                                .animatedSwitch();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: navToAuthPasswordScreen,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(
                  Constants.usePassword,
                  style: FontPalette.black16Medium,
                ),
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _inputController = TextEditingController();
    currentMicroSeconds = ValueNotifier(30 * 1000000);
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void onResendTap() {
    context.read<AuthProvider>().requestLoginOtp(resend: true);
  }

  Future<void> onComplete(String otp) async {
    FocusScope.of(context).unfocus();
    bool? res =
        await context.read<AuthProvider>().loginUsingOtp(_inputController.text);
    if (res ?? false) {
      navToMainScreen();
    }
  }

  void navToAuthPasswordScreen() {
    FocusScope.of(context).unfocus();
    if (mounted) {
      Navigator.pushReplacementNamed(
          context, RouteGenerator.routeAuthPasswordScreen);
    }
  }

  Future<void> navToMainScreen() async {
    String? path = await HiveServices.instance.getNavPath();
    if (path != null && path.isNotEmpty) {
      if (mounted) NavRoutes.instance.popUntil(context, path);
    } else {
      int args = await HiveServices.instance.getNavArgs();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreen, (route) => false,
            arguments: MainScreenArguments(tabIndex: args));
      }
    }
  }

  void initData() {
    CommonFunctions.afterInit(() {
      context.read<AuthProvider>().otpInit();
    });
  }
}
