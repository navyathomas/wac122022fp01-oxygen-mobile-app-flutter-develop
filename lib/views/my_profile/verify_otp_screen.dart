import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/models/arguments/delete_account_argument.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/providers/delete_account_otp_provider.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/feedback_screen/feedback_screen.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class MyProfileVerifyOtpScreen extends StatefulWidget {
  const MyProfileVerifyOtpScreen({super.key, required this.arguments});

  final DeleteCustomerAccountArguments arguments;

  @override
  State<MyProfileVerifyOtpScreen> createState() =>
      _MyProfileVerifyOtpScreenState();
}

class _MyProfileVerifyOtpScreenState extends State<MyProfileVerifyOtpScreen> {
  late final TextEditingController _inputController;
  late final DeleteAccountOtpProvider deleteAccountOtpProvider;
  Timer? _timer;

  // int timeRemaining = 30;
  ValueNotifier<int> timeRemaining = ValueNotifier<int>(30);

  // bool isTimerFinished = false;
  ValueNotifier<bool> isTimerFinished = ValueNotifier<bool>(false);

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
  void initState() {
    deleteAccountOtpProvider = DeleteAccountOtpProvider();
    _inputController = TextEditingController();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _startTimer() {
    isTimerFinished.value = false;
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    if (timeRemaining.value != 0) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (timeRemaining.value <= 0) {
            timer.cancel();
            timeRemaining.value = 30;
            isTimerFinished.value = true;
          } else {
            timeRemaining.value = timeRemaining.value - 1;
          }
        },
      );
    }
  }

  void onComplete(String v) async {
    if (mounted) {
      await deleteAccountOtpProvider
          .deleteCustomerAccount(context,
              data: widget.arguments, otp: _inputController.text)
          .then((value) {
        if (value == true) {
          context.read<AuthProvider>().logoutUser(onResponse: (val) async {
            if (val) {
              await HiveServices.instance.clearBoxData();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.routeMainScreen, (route) => false);
              }
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: deleteAccountOtpProvider,
      child: Scaffold(
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
                        5.verticalSpace,
                        Row(
                          children: [
                            Text(
                              widget.arguments.email,
                              style: FontPalette.f282C3F_16Bold,
                            )
                          ],
                        ),
                        43.27.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                double width =
                                    190.w < (constraints.maxWidth - 40.w)
                                        ? 190.w / 4
                                        : ((constraints.maxWidth - 40.w) / 4);
                                return Selector<DeleteAccountOtpProvider,
                                    String>(
                                  selector: (context, provider) =>
                                      provider.otpErrorMessage,
                                  builder: (context, value, child) {
                                    return Pinput(
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
                                          .read<DeleteAccountOtpProvider>()
                                          .updateDeleteAccountOtpErrorMessage(
                                              ''),
                                      onCompleted: onComplete,
                                      inputFormatters: Validator.inputFormatter(
                                              InputFormatType.phoneNumber) ??
                                          [],
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        Selector<DeleteAccountOtpProvider, String>(
                          selector: (_, provider) => provider.otpErrorMessage,
                          builder: (context, value, child) {
                            return (value.isNotEmpty
                                    ? Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.h),
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style:
                                                  FontPalette.fE50019_12Regular,
                                            ),
                                          ),
                                          11.8.verticalSpace
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          const SizedBox.shrink(),
                                          40.verticalSpace
                                        ],
                                      ))
                                .animatedSwitch();
                          },
                        ),
                        Consumer<DeleteAccountOtpProvider>(
                          builder: (_, p, ___) => SizedBox(
                              child: (p.btnLoaderState
                                  ? ThreeBounce(
                                      color: ColorPalette.primaryColor,
                                      size: 30.r,
                                    )
                                  : (Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Constants.didntReceiveOtp,
                                          style: FontPalette.f7B7E8E_16Regular,
                                        ),
                                        3.horizontalSpace,
                                        ValueListenableBuilder(
                                            valueListenable:
                                                MultiValueListenables([
                                              timeRemaining,
                                              isTimerFinished
                                            ]),
                                            builder: (_, __, ___) {
                                              if (timeRemaining.value > 0 &&
                                                  !isTimerFinished.value) {
                                                return Text(
                                                  '00:${timeRemaining.value < 10 ? '0${timeRemaining.value}' : timeRemaining.value}',
                                                  style: FontPalette
                                                      .fE50019_16Medium,
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () async {
                                                    await deleteAccountOtpProvider
                                                        .reSendDeleteAccountOtp(
                                                            email: widget
                                                                .arguments
                                                                .email)
                                                        .then((value) =>
                                                            _startTimer());
                                                  },
                                                  child: Text(
                                                    Constants.resend,
                                                    style: FontPalette
                                                        .fE50019_16Medium,
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    )))),
                        ).animatedSwitch()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
