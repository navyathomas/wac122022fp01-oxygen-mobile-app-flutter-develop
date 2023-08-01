import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/bajaj_emi/widgets/count_down_emi.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class FlowFour extends StatefulWidget {
  const FlowFour({
    Key? key,
  }) : super(key: key);

  @override
  State<FlowFour> createState() => _FlowFourState();
}

class _FlowFourState extends State<FlowFour> {
  PinTheme defaultTheme(double width) => PinTheme(
        width: width,
        height: width,
        textStyle: FontPalette.black20Medium,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          border: Border.all(color: HexColor('#DBDBDB')),
        ),
      );

  Future<void> onComplete(String otp) async {
    FocusScope.of(context).unfocus();
    final model = context.read<BajajEmiProvider>();
    model.transactionRefNumber = null;
    bool res = await model.verifyBajajEmiOtp(
        cardNumber: model.cardNumber ?? "",
        schemeId: model.selectedScheme ?? "",
        otp: otp);
    if (res) {
      model.pageController.jumpToPage(4);
      model.changeLinearProgressValue(5);
    }
  }

  void onResendTap() {
    final model = context.read<BajajEmiProvider>();
    model.otpController.clear();
    model.generateBajajEmiOtp(
        cardNumber: model.cardNumber ?? "",
        city: model.customerBillingSearch?.city ?? "",
        intercity: model.customerBillingSearch?.intercity ?? false,
        schemeId: model.selectedScheme ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<BajajEmiProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            Text(Constants.enterOtp, style: FontPalette.black20Medium),
            10.verticalSpace,
            Text(Constants.sentVerificationCodeNumber,
                style: FontPalette.f7E818C_16Regular),
            43.verticalSpace,
            LayoutBuilder(builder: (context, constraints) {
              double width = constraints.maxWidth * .12;
              return Center(
                child: Selector<BajajEmiProvider, String>(
                    selector: (context, provider) => provider.otpErrorMsg,
                    builder: (context, value, child) {
                      return Pinput(
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        controller: model.otpController,
                        autofocus: true,
                        length: 6,
                        defaultPinTheme: defaultTheme(width),
                        focusedPinTheme: defaultTheme(width).copyDecorationWith(
                            border: Border.all(color: HexColor('#282C3F'))),
                        errorPinTheme: defaultTheme(width).copyDecorationWith(
                            border: Border.all(color: HexColor('#E50019'))),
                        submittedPinTheme: defaultTheme(width),
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        forceErrorState: value.isNotEmpty,
                        onChanged: (val) {
                          context
                              .read<BajajEmiProvider>()
                              .updateOtpErrorMsg('');
                        },
                        inputFormatters: Validator.inputFormatter(
                                InputFormatType.phoneNumber) ??
                            [],
                        onCompleted: onComplete,
                      );
                    }),
              );
            }),
            Selector<BajajEmiProvider, String>(
              selector: (context, provider) => provider.otpErrorMsg,
              builder: (context, value, child) {
                return (value.isNotEmpty
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 7.h),
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
              child: Selector<BajajEmiProvider, LoaderState>(
                selector: (context, provider) => provider.loaderState,
                builder: (context, value, child) {
                  return (value.isLoading
                          ? ThreeBounce(
                              color: ColorPalette.primaryColor,
                              size: 30.r,
                            )
                          : CountDownEmi(
                              seconds: 30,
                              currentMicroSeconds: model.currentMicroSeconds,
                              onTap: onResendTap,
                            ))
                      .animatedSwitch();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
