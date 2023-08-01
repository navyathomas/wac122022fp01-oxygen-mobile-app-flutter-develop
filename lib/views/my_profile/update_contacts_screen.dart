import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/models/customer_profile_model.dart';
import 'package:oxygen/providers/update_contacts_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';

class UpdateContactScreen extends StatefulWidget {
  const UpdateContactScreen({super.key, this.profileModel});

  final CustomerProfileModel? profileModel;

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  /// Provider instance
  late final UpdateContactsProvider updateContactsProvider;

  /// Text controllers
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileOtpController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();

  /// Form - keys
  late final GlobalKey<FormState> mobileNumberFormKey;
  late final GlobalKey<FormState> emailFormKey;
  late final GlobalKey<FormState> mobileOtpFormKey;
  late final GlobalKey<FormState> emailOtpFormKey;

  /// Resend timers
  Timer? mobileOtpTimer;
  Timer? emailOtpTimer;

  ValueNotifier<int> mobileOtpTimeRemaining = ValueNotifier<int>(30);
  ValueNotifier<int> emailOtpTimeRemaining = ValueNotifier<int>(30);

  bool isMobileOtpTimerFinished = true;
  bool isEmailOtpTimerFinished = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => updateContactsProvider,
      child: Scaffold(
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: Constants.changeEmailAndMobile,
          actionList: const [],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Consumer<UpdateContactsProvider>(
            builder: (_, provider, __) => Column(
              children: [
                26.verticalSpace,
                Column(
                  children: [
                    Form(
                      key: mobileNumberFormKey,
                      child: AuthTextField(
                        isEditable: provider.mobileFeildIsEditable,
                        maxLength: 10,
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        labelText: Constants.mobileNumber,
                        controller: mobileController,
                        validator: (_) => Validator.validateMobile(
                            mobileController.text,
                            msg: provider.mobileFieldErrorMsg,
                            maxLength: 10),
                        onChanged: (_) => provider.updateDataChanges('mobile',
                            mobile: mobileController.text),
                        suffix: (provider.mobileTextIsChanged
                                ? (!provider.mobileNumberLoaderState
                                    ? TextButton(
                                        onPressed: onVerifyMobileNumber,
                                        child: Text(
                                            provider.mobileFeildIsEditable
                                                ? Constants.verify
                                                : Constants.change),
                                      )
                                    : SizedBox(
                                        width: 30.w,
                                        child: ThreeBounce(
                                          size: 10.r,
                                          color: ColorPalette.primaryColor,
                                        ),
                                      ))
                                : updateContactsProvider.mobileNumberIsVerified
                                    ? Icon(Icons.check_circle,
                                        size: 20.r, color: HexColor('#1CAF65'))
                                    : null)
                            ?.animatedSwitch(duration: 500),
                      ),
                    ),
                    (provider.mobileOtpFieldVisibility
                            ? Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Form(
                                  key: mobileOtpFormKey,
                                  child: AuthTextField(
                                    maxLength: 4,
                                    textInputType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    labelText: Constants.otp,
                                    controller: mobileOtpController,
                                    validator: (_) => Validator.validateOtp(
                                      mobileOtpController.text,
                                      msg: updateContactsProvider
                                          .mobileOtpErrorMsg,
                                    ),
                                    onChanged: (v) =>
                                        updateContactsProvider.mobileOtp = v,
                                    suffix: ValueListenableBuilder(
                                      valueListenable: mobileOtpTimeRemaining,
                                      builder: (_, time, __) => TextButton(
                                        onPressed: isMobileOtpTimerFinished
                                            ? resendMobileOtp
                                            : null,
                                        child: !provider
                                                .mobileOtpFieldLoaderStete
                                            ? Text(
                                                isMobileOtpTimerFinished
                                                    ? Constants.resend
                                                    : '00:${mobileOtpTimeRemaining.value < 10 ? '0${mobileOtpTimeRemaining.value}' : mobileOtpTimeRemaining.value}',
                                              )
                                            : SizedBox(
                                                width: 30.w,
                                                child: ThreeBounce(
                                                  size: 10.r,
                                                  color:
                                                      ColorPalette.primaryColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink())
                        .animatedSwitch(duration: 250, reverseDuration: 0)
                  ],
                ),
                12.verticalSpace,
                Column(
                  children: [
                    Form(
                      key: emailFormKey,
                      child: AuthTextField(
                        textInputFormatter: [LowerCaseTextFormatter()],
                        isEditable: provider.emailFieldIsEditable,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        labelText: Constants.email,
                        controller: emailController,
                        onChanged: (_) => provider.updateDataChanges('email',
                            email: emailController.text),
                        validator: (_) => Validator.validateEmail(
                            emailController.text,
                            msg: provider.emailFieldErrorMsg),
                        suffix: (provider.emailTextIsChanged
                            ? (!provider.emailLoaderState
                                ? TextButton(
                                    onPressed: onVerifyEmailAddress,
                                    child: Text(
                                      provider.emailFieldIsEditable
                                          ? Constants.verify
                                          : Constants.change,
                                    ),
                                  )
                                : SizedBox(
                                    width: 30.w,
                                    child: ThreeBounce(
                                      size: 10.r,
                                      color: ColorPalette.primaryColor,
                                    ),
                                  ))
                            : updateContactsProvider.emailIsVerified
                                ? Icon(
                                    Icons.check_circle,
                                    size: 20.r,
                                    color: HexColor('#1CAF65'),
                                  )
                                : null),
                      ),
                    ),
                    (provider.emailOtpFieldVisibility
                            ? Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: Form(
                                  key: emailOtpFormKey,
                                  child: AuthTextField(
                                    maxLength: 4,
                                    textInputType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    labelText: Constants.otp,
                                    controller: emailOtpController,
                                    validator: (_) => Validator.validateOtp(
                                        emailOtpController.text,
                                        msg: updateContactsProvider
                                            .emailOtpErrorMsg),
                                    onChanged: (v) =>
                                        updateContactsProvider.emailOtp = v,
                                    suffix: ValueListenableBuilder(
                                      valueListenable: emailOtpTimeRemaining,
                                      builder: (_, timer, __) => TextButton(
                                        onPressed: isEmailOtpTimerFinished
                                            ? resendEmail
                                            : null,
                                        child: !updateContactsProvider
                                                .emailOtpFieldLoaderState
                                            ? Text(
                                                isEmailOtpTimerFinished
                                                    ? Constants.resend
                                                    : '00:${emailOtpTimeRemaining.value < 10 ? '0${emailOtpTimeRemaining.value}' : emailOtpTimeRemaining.value}',
                                              )
                                            : SizedBox(
                                                width: 30.w,
                                                child: ThreeBounce(
                                                  size: 10.r,
                                                  color:
                                                      ColorPalette.primaryColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink())
                        .animatedSwitch(duration: 250, reverseDuration: 0)
                  ],
                ),
                const Expanded(child: SizedBox()),
                Consumer<UpdateContactsProvider>(
                  builder: (_, provider, __) => CustomButton(
                    title: Constants.saveAndUpdate,
                    enabled: updateContactsProvider.emailOtpFieldVisibility ||
                        updateContactsProvider.mobileOtpFieldVisibility,
                    onPressed: () => _onSaveAndUpdate(context),
                  ),
                ),
                30.verticalSpace
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    updateContactsProvider = UpdateContactsProvider();
    mobileNumberFormKey = GlobalKey<FormState>();
    emailFormKey = GlobalKey<FormState>();
    mobileOtpFormKey = GlobalKey<FormState>();
    emailOtpFormKey = GlobalKey<FormState>();
    presetValues();
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    mobileOtpController.dispose();
    emailOtpController.dispose();
    mobileOtpTimeRemaining.dispose();
    emailOtpTimeRemaining.dispose();
    if (mobileOtpTimer?.isActive ?? false) mobileOtpTimer?.cancel();
    if (emailOtpTimer?.isActive ?? false) emailOtpTimer?.cancel();
    super.dispose();
  }

  void resendMobileOtp() {
    updateContactsProvider.resendOtp(context, type: 'mobile').then((value) {
      if (value == true) {
        startMobileOtpTimer();
      }
    });
  }

  void resendEmail() {
    updateContactsProvider.resendOtp(context, type: 'email').then((value) {
      if (value == true) {
        startEmailOtpTimer();
      }
    });
  }

  void onVerifyMobileNumber() async {
    mobileOtpController.clear();
    updateContactsProvider.mobileFieldErrorMsg = null;
    FocusScope.of(context).unfocus();
    mobileOtpTimer?.cancel();
    mobileOtpTimeRemaining.value = 30;
    if (mobileNumberFormKey.currentState!.validate()) {
      updateContactsProvider.mobileOtpSendTo = mobileController.text;
      await updateContactsProvider
          .customerUpdateSendOtp(context, type: 'mobile')
          .then((value) {
        if (value == true) {
          startMobileOtpTimer();
        } else {
          mobileNumberFormKey.currentState!.validate();
        }
      });
    }
  }

  void onVerifyEmailAddress() async {
    emailOtpController.clear();
    updateContactsProvider.emailFieldErrorMsg = null;
    FocusScope.of(context).unfocus();
    emailOtpTimer?.cancel();
    emailOtpTimeRemaining.value = 30;
    if (emailFormKey.currentState!.validate()) {
      updateContactsProvider.emailOtpSendTo = emailController.text;
      await updateContactsProvider
          .customerUpdateSendOtp(context, type: 'email')
          .then((value) {
        if (value == true) {
          startEmailOtpTimer();
        } else {
          emailFormKey.currentState!.validate();
        }
      });
    }
  }

  void _onSaveAndUpdate(BuildContext context) {
    updateContactsProvider.mobileOtpErrorMsg = null;
    updateContactsProvider.emailOtpErrorMsg = null;
    if ((updateContactsProvider.mobileOtpFieldVisibility
            ? mobileOtpFormKey.currentState!.validate()
            : true) &&
        (updateContactsProvider.emailOtpFieldVisibility
            ? emailOtpFormKey.currentState!.validate()
            : true)) {
      FocusScope.of(context).unfocus();
      updateContactsProvider.updateCustomerContacts(context).then((value) {
        if (value != null) {
          if (value['mobile'] == false) {
            mobileOtpFormKey.currentState?.validate();
          }
          if (value['email'] == false) {
            emailOtpFormKey.currentState?.validate();
          }
        }
        if (updateContactsProvider.mobileNumberIsVerified) {
          mobileOtpController.clear();
        }
        if (updateContactsProvider.emailIsVerified) {
          emailOtpController.clear();
        }
      });
    }
  }

  void presetValues() {
    if (widget.profileModel != null) {
      updateContactsProvider.setInitialData(widget.profileModel);
      mobileController.text =
          ((widget.profileModel?.mobileNumber ?? '').startsWith('+91')
                  ? widget.profileModel?.mobileNumber?.substring(3)
                  : widget.profileModel?.mobileNumber) ??
              '';
      emailController.text = widget.profileModel?.email ?? '';
    }
  }

  void startMobileOtpTimer() {
    isMobileOtpTimerFinished = false;
    if (mobileOtpTimer?.isActive == true) {
      mobileOtpTimer!.cancel();
    }
    if (mobileOtpTimeRemaining.value != 0) {
      mobileOtpTimer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (mobileOtpTimeRemaining.value <= 0) {
            timer.cancel();
            mobileOtpTimeRemaining.value = 30;
            isMobileOtpTimerFinished = true;
          } else {
            mobileOtpTimeRemaining.value = mobileOtpTimeRemaining.value - 1;
          }
        },
      );
    }
  }

  void startEmailOtpTimer() {
    isEmailOtpTimerFinished = false;
    if (emailOtpTimer?.isActive == true) {
      emailOtpTimer!.cancel();
    }
    if (emailOtpTimeRemaining.value != 0) {
      emailOtpTimer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (emailOtpTimeRemaining.value <= 0) {
            timer.cancel();
            emailOtpTimeRemaining.value = 30;
            isEmailOtpTimerFinished = true;
          } else {
            emailOtpTimeRemaining.value = emailOtpTimeRemaining.value - 1;
          }
        },
      );
    }
  }
}
