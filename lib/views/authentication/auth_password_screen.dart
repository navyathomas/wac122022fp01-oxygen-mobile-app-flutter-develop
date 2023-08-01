import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../common/common_function.dart';
import '../../common/nav_routes.dart';
import '../../common/route_generator.dart';
import '../../models/arguments/main_screen_arguments.dart';
import '../../services/helpers.dart';
import '../../services/hive_services.dart';
import '../../utils/font_palette.dart';
import '../../widgets/custom_btn.dart';

class AuthPasswordScreen extends StatefulWidget {
  const AuthPasswordScreen({Key? key}) : super(key: key);

  @override
  State<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends State<AuthPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final AuthProvider authProvider;
  late final TextEditingController passwordController;

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 38.h, top: 3.h),
                          child: Text(
                            Constants.password,
                            style: FontPalette.black26Medium,
                          ),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                            return AuthTextField(
                              autofocus: true,
                              controller: passwordController,
                              onChanged: (val) =>
                                  authProvider.updateInputPassword(val),
                              validator: (val) => Validator.validatePassword(
                                  val,
                                  msg: provider.invalidPasswordMsg),
                              onFieldSubmitted: (val) => _continue(),
                              labelText: Constants.password,
                              enableObscure: true,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: navToForgotPasswordScreen,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h, bottom: 12.h, left: 12.w),
                                child: Text(
                                  Constants.forgotPasswordQn,
                                  style: FontPalette.black13Regular,
                                ),
                              ),
                            ).removeSplash(),
                          ],
                        ),
                        6.verticalSpace,
                        Selector<AuthProvider, Tuple2<LoaderState, String>>(
                          selector: (context, provider) => Tuple2(
                              provider.loaderState, provider.inputPassword),
                          builder: (context, value, child) {
                            return CustomButton(
                              onPressed: _continue,
                              enabled: value.item2.isNotEmpty,
                              isLoading: value.item1.isLoading,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: navToAuthOtpScreen,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(
                  Constants.useCode,
                  style: FontPalette.black16Medium,
                ),
              ),
            ),
            30.verticalSpace
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    authProvider.updatePasswordValidator();
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      bool? res = await authProvider.loginUsingPassword(
          context, passwordController.text);
      if (res ?? false) {
        navToMainScreen();
      } else {
        _formKey.currentState!.validate();
      }
    }
  }

  void navToAuthOtpScreen() {
    FocusScope.of(context).unfocus();
    context.read<AuthProvider>()
      ..updateOtpErrorMsg('')
      ..requestLoginOtp(onError: (val) {
        Helpers.successToast(val);
      });
    if (mounted) {
      Navigator.pushReplacementNamed(
          context, RouteGenerator.routeAuthOTPVerification);
    }
  }

  void navToForgotPasswordScreen() {
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeForgotPassword);
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
      context.read<AuthProvider>().loginPasswordInit();
    });
  }
}
