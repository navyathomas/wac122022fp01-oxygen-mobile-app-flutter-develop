import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/cms_model.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';

class ProductDetailTermsAndConditionsScreen extends StatelessWidget {
  final String? identifier;

  const ProductDetailTermsAndConditionsScreen({
    Key? key,
    this.identifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.termsAndConditions,
        actionList: const [],
      ),
      body: SafeArea(
        child: FutureBuilder<CmsItem?>(
            future: ProductDetailRepo.getCmsBlocks(context, identifier ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: HtmlWidget(
                      snapshot.data?.content ?? "",
                      onErrorBuilder: (context, element, error) =>
                          Text('$element error: $error'),
                      onLoadingBuilder: (context, element, loadingProgress) =>
                          const SizedBox.shrink(),
                      renderMode: RenderMode.column,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const CommonLinearProgress();
              } else {
                return const CommonLinearProgress();
              }
            }),
      ),
    );
  }
}
