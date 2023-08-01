import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/ratings_and_reviews_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/ratings_and_review/widgets/ratings_and_reviews_list.dart';
import 'package:oxygen/views/ratings_and_review/widgets/ratings_and_reviews_pagination_loader.dart';
import 'package:oxygen/views/ratings_and_review/widgets/ratings_and_reviews_top_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

class RatingsAndReviewsScreen extends StatefulWidget {
  final String? sku;

  const RatingsAndReviewsScreen({Key? key, this.sku}) : super(key: key);

  @override
  State<RatingsAndReviewsScreen> createState() =>
      _RatingsAndReviewsScreenState();
}

class _RatingsAndReviewsScreenState extends State<RatingsAndReviewsScreen> {
  RatingsAndReviewsProvider? ratingsProvider;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ratingsProvider = RatingsAndReviewsProvider();
    CommonFunctions.afterInit(() {
      ratingsProvider?.enableLoaderState = true;
      ratingsProvider?.getReviews(context, widget.sku ?? "");
      pagination();
    });
  }

  @override
  void dispose() {
    ratingsProvider?.dispose();
    super.dispose();
  }

  void pagination() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (ratingsProvider?.reviewsPageCount != null &&
            ratingsProvider?.reviewsTotalPage != null) {
          if ((ratingsProvider?.reviewsPageCount ?? 0) <=
              (ratingsProvider?.reviewsTotalPage ?? 0)) {
            if (ratingsProvider?.enableLoaderState ?? true) {
              ratingsProvider?.enableLoaderState = false;
            }
            ratingsProvider?.getReviews(context, widget.sku ?? "",
                pageNo: (ratingsProvider?.reviewsPageCount ?? 0));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: ratingsProvider,
        child: Scaffold(
          floatingActionButton: const WhatsappChatWidget(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          appBar: CommonAppBar(
            buildContext: context,
            pageTitle: Constants.ratingsAndReviews,
            actionList: const [],
          ),
          body: Selector<RatingsAndReviewsProvider, LoaderState>(
              selector: (context, provider) => provider.loaderState,
              builder: (context, value, child) {
                switch (value) {
                  case LoaderState.loading:
                    return Center(
                      child: SizedBox(
                        height: 30.r,
                        width: 30.r,
                        child: CircularProgressIndicator(
                            color: ColorPalette.primaryColor),
                      ),
                    );
                  case LoaderState.loaded:
                    return _RatingsAndReviewsListView(
                        scrollController: scrollController);
                  case LoaderState.noData:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.noData);
                  case LoaderState.error:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.error);
                  case LoaderState.networkErr:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.networkErr);
                  default:
                    return const SizedBox.shrink();
                }
              }),
        ));
  }
}

class _RatingsAndReviewsListView extends StatelessWidget {
  const _RatingsAndReviewsListView({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const RatingsAndReviewsTopWidget(),
        Divider(
          height: 5.h,
          thickness: 5.h,
          color: HexColor("#F3F3F7"),
        ).convertToSliver(),
        18.verticalSpace.convertToSliver(),
        const RatingsAndReviewsList(),
        const RatingsAndReviewsPaginationLoader()
      ],
    );
  }
}
