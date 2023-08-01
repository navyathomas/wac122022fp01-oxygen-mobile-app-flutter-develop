import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';

class ProductDetailVideoAndHighlightsWidget extends StatelessWidget {
  const ProductDetailVideoAndHighlightsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          if (value?.productVideo != null &&
              (value?.productVideo?.isNotEmpty ?? false) &&
              (value?.productVideo?.first?.videoUrl?.isNotEmpty ?? false)) {
            model.initialiseVideo(value?.productVideo?.first?.videoUrl ?? "");
          }
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (value?.productVideo == null ||
                            (value?.productVideo?.isEmpty ?? true) ||
                            (value?.productVideo?.first?.videoUrl?.isEmpty ??
                                true))
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constants.video,
                                  style: FontPalette.black16Medium,
                                ),
                                10.5.verticalSpace,
                                Container(
                                  width: double.maxFinite,
                                  height: constraints.maxWidth * .5213,
                                  color: Colors.grey.withOpacity(.50),
                                  child: PodVideoPlayer(
                                    controller: model.podPlayerController!,
                                    onLoading: (context) {
                                      return const SizedBox(
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    onVideoError: () {
                                      return const SizedBox(
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                    (value?.description?.html == null ||
                            (value?.description?.html?.isEmpty ?? true))
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                20.2.verticalSpace,
                                Text(
                                  Constants.productHighlights,
                                  style: FontPalette.black16Medium,
                                ),
                                10.verticalSpace,
                                HtmlWidget(
                                  value?.description?.html ?? "",
                                  onErrorBuilder: (context, element, error) =>
                                      Text('$element error: $error'),
                                  onLoadingBuilder:
                                      (context, element, loadingProgress) =>
                                          const CircularProgressIndicator(),
                                  renderMode: RenderMode.column,
                                ),
                              ],
                            ),
                          ),
                    12.verticalSpace,
                  ],
                ),
              ),
            );
          });
        });
  }
}
