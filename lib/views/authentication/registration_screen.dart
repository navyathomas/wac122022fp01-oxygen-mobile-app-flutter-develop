import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/common/validator.dart';
import 'package:oxygen/models/validation_data_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/views/authentication/widgets/number_prefix_tile.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../common/common_function.dart';
import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/arguments/main_screen_arguments.dart';
import '../../providers/auth_provider.dart';
import '../../utils/font_palette.dart';
import '../../widgets/custom_btn.dart';
import 'widgets/register_count_down.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final GlobalKey<FormState> _formKey;
  late final AuthProvider authProvider;

  late final TextEditingController _otpController;
  late final TextEditingController _fNController;
  late final TextEditingController _lNController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final ScrollController scrollController;
  late final ValueNotifier<bool> isScrolled;

  late FocusNode _otpFocusNode;
  late FocusNode _fNFocusNode;
  late FocusNode _lNFocusNode;
  late FocusNode _phoneNumberFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isScrolled,
        builder: (context, value, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leadingWidth: 42.5.w,
              shadowColor: ColorPalette.shimmerHighlightColor,
              elevation: value ? 1.0 : 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 38.h, top: 3.h),
                                child: Text(
                                  Constants.createNewAccount,
                                  style: FontPalette.black26Medium,
                                ),
                              ),
                              Selector<AuthProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isNumber,
                                builder: (context, value, child) {
                                  return AuthTextField(
                                      focusNode: _phoneNumberFocusNode,
                                      controller: _phoneNumberController,
                                      isEditable: !authProvider.isNumber,
                                      validator: (val) =>
                                          Validator.validateMobile(
                                              _phoneNumberController.text,
                                              maxLength: 10),
                                      labelText: Constants.mobileNumber,
                                      maxLength: 10,
                                      prefix: const NumberPrefixTile(),
                                      suffix: value
                                          ? _ChangeBtn(
                                              onTap: () => NavRoutes.instance
                                                  .popUntil(
                                                      context,
                                                      RouteGenerator
                                                          .routeAuthScreen),
                                            )
                                          : null,
                                      textInputFormatter:
                                          Validator.inputFormatter(
                                              InputFormatType.phoneNumber),
                                      onFieldSubmitted: (val) =>
                                          FocusScope.of(context)
                                              .requestFocus(_otpFocusNode),
                                      onChanged: (val) {
                                        if (val.length == 10) {
                                          FocusScope.of(context)
                                              .requestFocus(_otpFocusNode);
                                          authProvider.updateRegisterScreenData(
                                              mobileNumber: val);
                                        } else {
                                          authProvider.updateRegisterScreenData(
                                              mobileNumber: null);
                                        }
                                      },
                                      textInputAction: TextInputAction.next);
                                },
                              ),
                              14.verticalSpace,
                              AuthTextField(
                                  controller: _otpController,
                                  focusNode: _otpFocusNode,
                                  validator: (val) =>
                                      Validator.validateOtp(val),
                                  labelText: Constants.enterOtp,
                                  textInputType: TextInputType.number,
                                  suffix: const AuthCountdown(
                                    seconds: 30,
                                  ),
                                  textInputFormatter: Validator.inputFormatter(
                                      InputFormatType.phoneNumber),
                                  onFieldSubmitted: (val) =>
                                      FocusScope.of(context)
                                          .requestFocus(_fNFocusNode),
                                  maxLength: 4,
                                  onChanged: (val) {
                                    if (val.length == 4) {
                                      FocusScope.of(context)
                                          .requestFocus(_fNFocusNode);
                                      authProvider.updateRegisterScreenData(
                                          otp: val);
                                    } else {
                                      authProvider.updateRegisterScreenData(
                                          otp: null);
                                    }
                                  },
                                  textInputAction: TextInputAction.next),

                              ///ToDO: handle error view of otp here
                              14.verticalSpace,
                              AuthTextField(
                                controller: _fNController,
                                focusNode: _fNFocusNode,
                                validator: (val) => Validator.validateName(val),
                                labelText: Constants.firstName,
                                textInputFormatter: Validator.inputFormatter(
                                    InputFormatType.name),
                                onFieldSubmitted: (val) =>
                                    FocusScope.of(context)
                                        .requestFocus(_lNFocusNode),
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) => authProvider
                                    .updateRegisterScreenData(firstName: val),
                              ),
                              14.verticalSpace,
                              AuthTextField(
                                  controller: _lNController,
                                  focusNode: _lNFocusNode,
                                  validator: (val) =>
                                      Validator.validateLastName(val),
                                  labelText: Constants.lastName,
                                  textInputFormatter: Validator.inputFormatter(
                                      InputFormatType.name),
                                  onFieldSubmitted: (val) =>
                                      authProvider.isNumber
                                          ? FocusScope.of(context)
                                              .requestFocus(_emailFocusNode)
                                          : FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode),
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (val) => authProvider
                                      .updateRegisterScreenData(lastName: val),
                                  textInputAction: TextInputAction.next),
                              14.verticalSpace,
                              Selector<AuthProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isNumber,
                                builder: (context, value, child) {
                                  return AuthTextField(
                                      focusNode: _emailFocusNode,
                                      controller: _emailController,
                                      isEditable: authProvider.isNumber,
                                      validator: (val) =>
                                          Validator.validateEmail(
                                              _emailController.text),
                                      suffix: !value
                                          ? _ChangeBtn(
                                              onTap: () => NavRoutes.instance
                                                  .popUntil(
                                                      context,
                                                      RouteGenerator
                                                          .routeAuthScreen),
                                            )
                                          : null,
                                      labelText: Constants.emailAddress,
                                      textInputFormatter:
                                          Validator.inputFormatter(
                                              InputFormatType.email),
                                      onChanged: (val) => authProvider
                                          .updateRegisterScreenData(email: val),
                                      onFieldSubmitted: (val) =>
                                          FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode),
                                      textInputAction: TextInputAction.next);
                                },
                              ),
                              14.verticalSpace,
                              AuthTextField(
                                focusNode: _passwordFocusNode,
                                controller: _passwordController,
                                enableObscure: true,
                                validator: (val) =>
                                    Validator.validatePassword(val),
                                onChanged: (val) => authProvider
                                    .updateRegisterScreenData(password: val),
                                labelText: Constants.password,
                              ),
                              Selector<AuthProvider, String>(
                                selector: (context, provider) =>
                                    provider.errorMsg,
                                builder: (context, value, child) {
                                  return WidgetExtension.crossSwitch(
                                      first: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Text(
                                          value,
                                          style: FontPalette.fE50019_12Regular,
                                        ),
                                      ),
                                      value: value.isNotEmpty);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 40.h),
                    child: Selector<AuthProvider,
                        Tuple2<LoaderState, RegisterScreenData>>(
                      selector: (context, provider) => Tuple2(
                          provider.loaderState, provider.registerScreenData),
                      builder: (context, value, child) {
                        return CustomButton(
                          onPressed: _continue,
                          enabled: !value.item2.isNotValid,
                          isLoading: value.item1.isLoading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    authProvider = context.read<AuthProvider>();
    _otpController = TextEditingController();
    _fNController = TextEditingController();
    _lNController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _otpFocusNode = FocusNode();
    _fNFocusNode = FocusNode();
    _lNFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    scrollController = ScrollController();
    isScrolled = ValueNotifier(false);
    _addScrollListener();
    _prefillData();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _lNController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _otpFocusNode.dispose();
    _fNFocusNode.dispose();
    _lNFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    scrollController.dispose();
    isScrolled.dispose();
    super.dispose();
  }

  void _addScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 0) {
        isScrolled.value = true;
      } else {
        isScrolled.value = false;
      }
    });
  }

  void _prefillData() {
    if (authProvider.isNumber) {
      _phoneNumberController.text = authProvider.authInput;
    } else {
      _emailController.text = authProvider.authInput;
    }
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      bool? res = await authProvider.registerUser(
          firstName: _fNController.text,
          lastName: _lNController.text,
          mobileNumber: _phoneNumberController.text,
          emailAddress: _emailController.text,
          password: _passwordController.text,
          otp: _otpController.text);
      if (res ?? false) {
        Helpers.successToast(Constants.registrationSuccessfullyMsg);
        navToMainScreen();
      }
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
      authProvider.registrationInit();
    });
  }
}

class _ChangeBtn extends StatelessWidget {
  final VoidCallback? onTap;

  const _ChangeBtn({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Text(
              Constants.change,
              style: FontPalette.fE50019_16Medium,
            ),
          ),
        ],
      ),
    );
  }
}
