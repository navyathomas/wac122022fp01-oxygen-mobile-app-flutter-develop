import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/providers/my_profile_provider.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final MyProfileProvider profileProvider;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  @override
  void dispose() {
    profileProvider.resetValues();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    profileProvider = context.read<MyProfileProvider>();
  }

  void _onUpdatePasswoed() {
    profileProvider.invalidCurrentPassword = false;
    if (_formKey.currentState!.validate()) {
      profileProvider
          .changePassword(context, currentPasswordController.text,
              newPasswordController.text)
          .then((value) {
        if (value != null && value) {
          Navigator.pop(context);
        } else {
          _formKey.currentState?.validate();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.changePassword,
        actionList: const [],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Consumer<MyProfileProvider>(
              builder: (_, provider, __) => Column(
                children: [
                  18.verticalSpace,
                  AuthTextField(
                    labelText: Constants.currentPassword,
                    controller: currentPasswordController,
                    enableObscure: true,
                    onChanged: (v) {
                      provider.updateChangePasswordData(currentPassword: v);
                    },
                    validator: (v) {
                      if (provider.invalidCurrentPassword) {
                        return provider.invalidCurrentPasswordMsg;
                      }
                      return null;
                    },
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    labelText: Constants.newPassword,
                    controller: newPasswordController,
                    enableObscure: true,
                    onChanged: (v) {
                      provider.updateChangePasswordData(newPassword: v);
                    },
                    validator: (v) => Validator.validatePassword(v),
                  ),
                  12.verticalSpace,
                  AuthTextField(
                    labelText: Constants.confirmNewPassword,
                    controller: confirmedPasswordController,
                    enableObscure: true,
                    onChanged: (v) {
                      provider.updateChangePasswordData(confirmPassword: v);
                    },
                    validator: (v) {
                      if (newPasswordController.text != v) {
                        return 'Confirm password does not match';
                      }
                      return null;
                    },
                  ),
                  20.5.verticalSpace,
                  Selector<MyProfileProvider, bool>(
                      selector: (_, data) => data.btnLoaderState,
                      builder: (_, btnLoaderState, __) {
                        log('${provider.changePasswordData.enableButton}');
                        return CustomButton(
                          title: Constants.updatePassword,
                          enabled: provider.changePasswordData.enableButton,
                          onPressed: _onUpdatePasswoed,
                          isLoading: btnLoaderState,
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
