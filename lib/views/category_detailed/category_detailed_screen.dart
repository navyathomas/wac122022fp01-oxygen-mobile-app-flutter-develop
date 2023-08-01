import 'package:flutter/material.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/category_detailed_provider.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/shimmers/category_detailed_shimmer.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/custom_fade_only_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CategoryDetailedScreen extends StatefulWidget {
  final String? type;
  final String? title;

  const CategoryDetailedScreen({
    Key? key,
    this.type,
    this.title,
  }) : super(key: key);

  @override
  State<CategoryDetailedScreen> createState() => _CategoryDetailedScreenState();
}

class _CategoryDetailedScreenState extends State<CategoryDetailedScreen> {
  CategoryDetailedProvider? categoryDetailedProvider;

  @override
  void initState() {
    super.initState();
    categoryDetailedProvider = CategoryDetailedProvider();
    CommonFunctions.afterInit(() {
      categoryDetailedProvider?.getCategoryDetailed(context, type: widget.type);
    });
  }

  @override
  void dispose() {
    categoryDetailedProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: categoryDetailedProvider,
      child: Scaffold(
        floatingActionButton: const WhatsappChatWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: widget.title,
        ),
        body: SafeArea(
          child: Selector<CategoryDetailedProvider,
                  Tuple2<List<Widget>, LoaderState>>(
              selector: (context, provider) => Tuple2(
                  provider.categoryDetailedWidgets, provider.loaderState),
              builder: (context, value, child) {
                switch (value.item2) {
                  case LoaderState.loaded:
                    return RefreshIndicator(
                      onRefresh: () async {
                        await categoryDetailedProvider?.getCategoryDetailed(
                            context,
                            type: widget.type,
                            loaderStateEnabled: false);
                      },
                      child: CustomFadeOnlyAnimation(
                        child: CustomScrollView(
                          slivers: value.item1,
                        ),
                      ),
                    );
                  case LoaderState.loading:
                    return const CategoryDetailedShimmer();
                  case LoaderState.error:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.error);
                  case LoaderState.networkErr:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.networkErr);
                  case LoaderState.noData:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.noData);
                  case LoaderState.noProducts:
                    return const ApiErrorScreens(
                        loaderState: LoaderState.noProducts);
                }
              }),
        ),
      ),
    );
  }
}
