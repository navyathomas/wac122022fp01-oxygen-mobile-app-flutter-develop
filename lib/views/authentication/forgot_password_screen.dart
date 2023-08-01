import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/providers/auth_provider.dart';
import 'package:oxygen/views/authentication/widgets/auth_text_field.dart';
import 'package:oxygen/views/authentication/widgets/number_prefix_tile.dart';
import 'package:provider/provider.dart';

import '../../common/common_function.dart';
import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../common/validator.dart';
import '../../utils/font_palette.dart';
import '../../widgets/custom_btn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final AuthProvider authProvider;
  late final TextEditingController inputController;

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
                      Constants.forgotPassword,
                      style: FontPalette.black26Medium,
                    ),
                  ),
                  Selector<AuthProvider, bool>(
                    selector: (context, provider) => provider.isNumber,
                    builder: (context, value, child) {
                      return AuthTextField(
                        autofocus: true,
                        enabled: false,
                        prefix: value ? const NumberPrefixTile() : null,
                        validator: (val) => value
                            ? Validator.validateMobile(inputController.text,
                                maxLength: 10)
                            : Validator.validateEmail(inputController.text),
                        controller: inputController,
                        onFieldSubmitted: (val) => _continue(),
                        labelText: value
                            ? Constants.registeredMobNumber
                            : Constants.registeredEmail,
                      );
                    },
                  ),
                  20.verticalSpace,
                  Selector<AuthProvider, bool>(
                    selector: (context, provider) => provider.btnLoaderState,
                    builder: (context, value, child) {
                      return CustomButton(
                        onPressed: _continue,
                        isLoading: value,
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
    inputController = TextEditingController(text: authProvider.authInput);
    _formKey = GlobalKey<FormState>();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      bool res = await authProvider.requestForgotPasswordOtp();
      if (res) {
        navToResetPasswordScreen();
      }
    }
  }

  void navToResetPasswordScreen() {
    if (mounted) {
      Navigator.pushNamed(context, RouteGenerator.routeResetPassword);
    }
  }

  void initData() {
    CommonFunctions.afterInit(() {
      context.read<AuthProvider>().forgotPasswordInit();
    });
  }
}
