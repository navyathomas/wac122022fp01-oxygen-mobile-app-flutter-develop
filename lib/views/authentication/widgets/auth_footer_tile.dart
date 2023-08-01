import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/route_generator.dart';

import '../../../common/constants.dart';
import '../../../utils/font_palette.dart';

class AuthFooterTile extends StatelessWidget {
  const AuthFooterTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 50.h),
      child: Text.rich(
        TextSpan(
            text: Constants.authTermsText,
            children: [
              const TextSpan(text: '\n'),
              TextSpan(
                  text: Constants.termsAndService,
                  style: FontPalette.black12Regular,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                          context, RouteGenerator.routeTermsAndConditionScreen);
                    }),
              TextSpan(text: '\t&\t', style: FontPalette.f7B7E8E_12Regular),
              TextSpan(
                  text: Constants.privacyPolicy,
                  style: FontPalette.black12Regular,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                          context, RouteGenerator.routePrivacyPolicyScreen);
                    })
            ],
            style: FontPalette.f7B7E8E_12Regular),
        textAlign: TextAlign.center,
        strutStyle: const StrutStyle(height: 1.2),
      ),
    );
  }
}
