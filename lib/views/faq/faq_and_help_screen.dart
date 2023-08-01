import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/faq_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/error_screens/api_error_screens.dart';
import 'package:oxygen/views/faq/widgets/faq_query_dropdown.dart';
import 'package:oxygen/views/faq/widgets/faq_tile.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';

class FaqAndHelpScreen extends StatefulWidget {
  const FaqAndHelpScreen({super.key});

  @override
  State<FaqAndHelpScreen> createState() => _FaqAndHelpScreenState();
}

class _FaqAndHelpScreenState extends State<FaqAndHelpScreen> {
  FaqProvider? faqProvider;
  ScrollController scrollController = ScrollController();
  ValueNotifier<double> scrollOffset = ValueNotifier<double>(0.0);

  Widget _faqView() {
    return Consumer<FaqProvider>(
        builder: (_, provider, __) => provider.loaderState ==
                LoaderState.loading
            ? const CommonLinearProgress()
            : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const _LinearIndicator(),
                    FaqQueryDropdown(
                      faqFilters: provider.faqQueryList,
                      onChanged: (s) => _onDropdownChanged(s),
                      offeset: scrollOffset,
                    ),
                    provider.filterLoaderState
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: CustomSlidingFadeAnimation(
                              slideDuration: const Duration(milliseconds: 250),
                              child: CustomScrollView(
                                controller: scrollController,
                                slivers: [
                                  provider.filteredFaqList.isEmpty &&
                                          provider.filterQuery == null
                                      ? SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (ctx, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13.w),
                                              child: InkWell(
                                                onTap: () => Navigator.pushNamed(
                                                    context,
                                                    RouteGenerator
                                                        .routeFaqDetailedView,
                                                    arguments: provider
                                                        .faqList[index]),
                                                child: FaqTileWidget(
                                                  index: index,
                                                  title: provider
                                                      .faqList[index].question,
                                                ),
                                              ),
                                            );
                                          },
                                              childCount:
                                                  provider.faqList.length),
                                        )
                                      : provider.filteredFaqList.isNotEmpty ||
                                              provider.filterLoaderState
                                          ? SliverList(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                      (ctx, index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 13.w),
                                                  child: InkWell(
                                                    onTap: () => Navigator.pushNamed(
                                                        context,
                                                        RouteGenerator
                                                            .routeFaqDetailedView,
                                                        arguments: provider
                                                                .filteredFaqList[
                                                            index]),
                                                    child: FaqTileWidget(
                                                      index: index,
                                                      title: provider
                                                          .filteredFaqList[
                                                              index]
                                                          .question,
                                                    ),
                                                  ),
                                                );
                                              },
                                                      childCount: provider
                                                          .filteredFaqList
                                                          .length),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: context.sw()),
                                                160.verticalSpace,
                                                SvgPicture.asset(
                                                    Assets.iconsNoDataFound),
                                                40.44.verticalSpace,
                                                Text(
                                                  Constants.noDataFound,
                                                  style:
                                                      FontPalette.black18Medium,
                                                ),
                                              ],
                                            ).convertToSliver(),
                                  provider.paginationLoaderState
                                      ? SizedBox(
                                          width: context.sw(),
                                          height: 50.h,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ).convertToSliver()
                                      : const SizedBox.shrink()
                                          .convertToSliver()
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.helpAndFaqs,
        actionList: const [],
      ),
      body: Selector<FaqProvider, LoaderState>(
        selector: (_, provider) => provider.loaderState,
        builder: (_, value, __) {
          switch (value) {
            case LoaderState.loaded:
              return _faqView();
            case LoaderState.loading:
              return _faqView();
            case LoaderState.error:
              return ApiErrorScreens(loaderState: value);
            case LoaderState.networkErr:
              return ApiErrorScreens(loaderState: value);
            case LoaderState.noData:
              return ApiErrorScreens(loaderState: value);
            case LoaderState.noProducts:
              return const SizedBox.shrink();
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    faqProvider = context.read<FaqProvider>();
    scrollController.addListener(() {
      faqProvider?.pagination(scrollController, context);
      faqProvider?.updateScrollStatus(true);
    });
    super.initState();
    faqProvider?.pageInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      faqProvider?.getFaqList(context);
    });
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
  }

  void _onDropdownChanged(String? v) async {
    if (v != null && v.toLowerCase() == 'all') {
      faqProvider?.currentPage = 1;
      faqProvider?.maxScrollExtent = 0.0;
      faqProvider?.updateFilterLoader(true);
      faqProvider?.filterQuery = null;
      await faqProvider
          ?.getFaqList(context, all: true)
          .then((_) => faqProvider?.updateFilterLoader(false));
    } else {
      faqProvider?.updateFilterLoader(true);
      faqProvider?.filterQuery = v;
      faqProvider?.currentPage = 1;
      await faqProvider
          ?.getFaqList(context, query: v)
          .then((_) => faqProvider?.updateFilterLoader(false));
    }
  }
}

class _LinearIndicator extends StatelessWidget {
  const _LinearIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<FaqProvider, bool>(
      selector: (_, s) => s.filterLoaderState,
      builder: (_, isLoading, __) {
        return isLoading
            ? const CommonLinearProgress()
            : SizedBox(
                height: 2.h,
              );
      },
    );
  }
}
