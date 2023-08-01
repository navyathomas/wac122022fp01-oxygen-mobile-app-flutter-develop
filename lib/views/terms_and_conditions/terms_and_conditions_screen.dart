import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/repositories/terms_and_conditions_repo.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({super.key});

  TermsAndConditionsPrivacyPolicyRepo repo =
      TermsAndConditionsPrivacyPolicyRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.termsAndConditions,
        actionList: const [],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: repo.getTermsAndConditions(),
          builder: (ctx, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const SizedBox.shrink();
              case ConnectionState.waiting:
                return const CommonLinearProgress();
              case ConnectionState.active:
                return const CommonLinearProgress();
              case ConnectionState.done:
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13),
                  child: HtmlWidget(snapshot.data?.content ?? "",
                      onErrorBuilder: (context, element, error) =>
                          Text('$element error: $error'),
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          const SizedBox.shrink(),
                      renderMode: RenderMode.column,
                      onTapUrl: (url) {
                        CommonFunctions.openExternalUrl(url);
                        return true;
                      }),
                );
            }
          },
        ),
      ),
    );
  }
}
