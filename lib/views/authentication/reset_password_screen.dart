import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/validation_data_model.dart';
import 'package:oxygen/views/authentication/widgets/register_count_down.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../common/common_function.dart';
import '../../common/constants.dart';
import '../../common/validator.dart';
import '../../providers/auth_provider.dart';
import '../../utils/font_palette.dart';
import '../../widgets/custom_btn.dart';
import 'widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final AuthProvider authProvider;
  late final TextEditingController otpController;
  late final TextEditingController newPasswordCtrl;
  late final TextEditingController confirmPasswordCtrl;

  late FocusNode _newPasswordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 38.h, top: 3.h),
                    child: Text(
                      Constants.changePassword,
                      style: FontPalette.black26Medium,
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, provider, _) {
                      return AuthTextField(
                          controller: otpController,
                          validator: (val) => Validator.validateOtp(val,
                              msg: provider.errorMsg),
                          labelText: Constants.enterOtp,
                          textInputType: TextInputType.number,
                          suffix: Selector<AuthProvider, LoaderState>(
                            selector: (context, provider) =>
                                provider.loaderState,
                            builder: (context, value, child) {
                              return AuthCountdown(
                                seconds: 30,
                                isFromResetPassword: true,
                                resendState: value.isLoading,
                              );
                            },
                          ),
                          textInputFormatter: Validator.inputFormatter(
                              InputFormatType.phoneNumber),
                          onFieldSubmitted: (val) => FocusScope.of(context)
                              .requestFocus(_newPasswordFocusNode),
                          maxLength: 4,
                          onChanged: (val) {
                            if (val.length == 4) {
                              FocusScope.of(context)
                                  .requestFocus(_newPasswordFocusNode);
                              authProvider.updateChangePasswordData(otp: val);
                            } else {
                              authProvider.updateChangePasswordData(otp: null);
                            }
                          },
                          textInputAction: TextInputAction.next);
                    },
                  ),
                  12.verticalSpace,
                  AuthTextField(
                      focusNode: _newPasswordFocusNode,
                      controller: newPasswordCtrl,
                      validator: (val) => Validator.validatePassword(val),
                      labelText: Constants.newPassword,
                      onFieldSubmitted: (val) => FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocusNode),
                      onChanged: (val) => authProvider.updateChangePasswordData(
                          newPassword: val),
                      enableObscure: true,
                      textInputAction: TextInputAction.next),
                  12.verticalSpace,
                  AuthTextField(
                    focusNode: _confirmPasswordFocusNode,
                    controller: confirmPasswordCtrl,
                    validator: (val) => Validator.validateConfirmPassword(
                        val, newPasswordCtrl.text),
                    onChanged: (val) => authProvider.updateChangePasswordData(
                        confirmPassword: val),
                    onFieldSubmitted: (val) => updatePassword(),
                    labelText: Constants.confirmNewPassword,
                    enableObscure: true,
                  ),
                  20.verticalSpace,
                  Selector<AuthProvider,
                      Tuple2<LoaderState, ChangePasswordData>>(
                    selector: (context, provider) => Tuple2(
                        provider.resetPasswordLoader,
                        provider.changePasswordData),
                    builder: (context, value, child) {
                      return CustomButton(
                        onPressed: updatePassword,
                        title: Constants.updatePassword,
                        isLoading: value.item1.isLoading,
                        enabled: !value.item2.isNotValid,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    otpController = TextEditingController();
    newPasswordCtrl = TextEditingController();
    confirmPasswordCtrl = TextEditingController();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      bool? res = await authProvider.changeCustomerPasswordOtp(
          context, otpController.text, confirmPasswordCtrl.text);
      if (res ?? false) {
        if (mounted) {
          Navigator.of(context).popUntil((route) {
            return route.settings.name != null
                ? route.settings.name == RouteGenerator.routeAuthScreen
                : true;
          });
        }
      } else {
        _formKey.currentState!.validate();
      }
    }
  }

  void initData() {
    CommonFunctions.afterInit(() {
      context.read<AuthProvider>().forgotPasswordInit();
    });
  }
}
