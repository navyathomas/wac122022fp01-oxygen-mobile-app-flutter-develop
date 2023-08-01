import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/category_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/main_screen/categories/widgets/categories_grid_view_widget.dart';
import 'package:oxygen/views/shimmers/category_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_sliding_fade_animation.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    CommonFunctions.afterInit(() {
      if (context.read<CategoryProvider>().allCategoriesList.isEmpty) {
        context.read<CategoryProvider>().getCategoryPageData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return _switchView(categoryProvider);
          },
        ),
      ),
    );
  }

  _switchView(CategoryProvider categoryProvider) {
    Widget child = const SizedBox.shrink();
    switch (categoryProvider.loaderState) {
      case LoaderState.loaded:
        child = _mainView(categoryProvider);
        break;
      case LoaderState.loading:
        child = const CategoryShimmer();
        break;
      case LoaderState.error:
        child = CustomSlidingFadeAnimation(
          slideDuration: const Duration(milliseconds: 300),
          child: ApiErrorScreens(
            loaderState: LoaderState.error,
            onTryAgain: () => categoryProvider.getCategoryPageData(),
          ),
        );
        break;
      case LoaderState.networkErr:
        child = CustomSlidingFadeAnimation(
          slideDuration: const Duration(milliseconds: 300),
          child: ApiErrorScreens(
            loaderState: LoaderState.networkErr,
            onTryAgain: () => categoryProvider.getCategoryPageData(),
          ),
        );
        break;
      case LoaderState.noData:
        child = CustomSlidingFadeAnimation(
          slideDuration: const Duration(milliseconds: 300),
          child: ApiErrorScreens(
            loaderState: LoaderState.noData,
            onTryAgain: () => categoryProvider.getCategoryPageData(),
          ),
        );
        break;
      case LoaderState.noProducts:
        child = CustomSlidingFadeAnimation(
          slideDuration: const Duration(milliseconds: 300),
          child: ApiErrorScreens(
            loaderState: LoaderState.noData,
            onTryAgain: () => categoryProvider.getCategoryPageData(),
          ),
        );
        break;
    }
    return child;
  }

  _mainView(CategoryProvider categoryProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          28.verticalSpace,
          categoryProvider.allCategoriesList.notEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(Constants.allCategories,
                      style: FontPalette.black18Medium
                          .copyWith(letterSpacing: .3.w)),
                )
              : const SizedBox.shrink(),
          20.verticalSpace,
          CategoriesGridViewWidget(
            categoryContentList: categoryProvider.allCategoriesList,
          ),
          15.verticalSpace
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
