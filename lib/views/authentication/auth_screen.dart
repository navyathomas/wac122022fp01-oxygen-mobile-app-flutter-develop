import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/views/authentication/widgets/auth_footer_tile.dart';
import 'package:oxygen/views/authentication/widgets/auth_header_tile.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/views/authentication/widgets/number_prefix_tile.dart';
import 'package:oxygen/widgets/empty_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../widgets/custom_btn.dart';

class AuthScreen extends StatefulWidget {
  final bool fromGuestUser;

  const AuthScreen({Key? key, this.fromGuestUser = false}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey<FormState> _formKey;
  late final AuthProvider authProvider;
  late final FocusNode focusNode;
  late final TextEditingController authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EmptyAppBar(
        backgroundColor: Colors.white,
        darkIcon: Platform.isIOS ? false : true,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            systemStatusBarContrastEnforced: true,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 31.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthHeaderTile(
                            onSkip: onSkipTap,
                            fromGuestUser: widget.fromGuestUser),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 38.h, bottom: 20.h, left: 13.w, right: 13.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Selector<AuthProvider, bool>(
                                  selector: (context, provider) =>
                                      provider.isNumber,
                                  builder: (context, value, child) {
                                    return AuthTextField(
                                      focusNode: focusNode,
                                      validator: (val) =>
                                          authProvider.validateAuthInput(val),
                                      onFieldSubmitted: (val) => _continue(),
                                      onChanged: (val) =>
                                          authProvider.validateNumberInput(val),
                                      maxLength: value ? 10 : null,
                                      prefix: WidgetExtension.crossSwitch(
                                          first: const NumberPrefixTile(),
                                          value: value),
                                      labelText: Constants.enterMobileOrEmail,
                                      textInputFormatter:
                                          Validator.inputFormatter(
                                              InputFormatType.email),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.w),
                          child: Selector<AuthProvider, Tuple2<bool, String>>(
                            selector: (context, provider) => Tuple2(
                                provider.btnLoaderState, provider.authInput),
                            builder: (context, value, child) {
                              return CustomButton(
                                onPressed: _continue,
                                enabled: value.item2.isNotEmpty,
                                isLoading: value.item1,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const AuthFooterTile(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    focusNode = FocusNode();
    authController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    authProvider = context.read<AuthProvider>();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    authController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthProvider>().updateOtpErrorMsg('');
      bool? userExist = await authProvider.checkCustomerAlreadyExists();
      if (userExist != null) {
        userExist ? navToOtpScreen() : navToRegisterScreen();
      }
    }
  }

  void navToOtpScreen() {
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeAuthOTPVerification)
          .then((value) => FocusScope.of(context).requestFocus(focusNode));
    }
  }

  void navToRegisterScreen() {
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeRegistrationScreen)
          .then((value) => FocusScope.of(context).requestFocus(focusNode));
    }
  }

  void initData() {
    CommonFunctions.afterInit(() {
      authProvider.pageInit();
    });
  }

  Future<void> onSkipTap() async {
    if (AppConfig.cartId.notEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.routeMainScreenSlide, (route) => false);
    } else {
      context.circularLoaderPopUp;
      String cartId =
          await context.read<AuthProvider>().getEmptyCart(enableToast: true);
      if (cartId.isNotEmpty && mounted) {
        context.rootPop;
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMainScreenSlide, (route) => false);
      } else {
        context.rootPop;
      }
    }
  }
}
