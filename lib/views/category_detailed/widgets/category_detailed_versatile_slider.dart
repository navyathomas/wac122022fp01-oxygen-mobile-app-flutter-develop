import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/nav_routes.dart';
import 'package:oxygen/models/category_detailed_model.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CategoryDetailedVersatileSlider extends StatefulWidget {
  final List<DetailContent?>? content;

  const CategoryDetailedVersatileSlider({Key? key, this.content})
      : super(key: key);

  @override
  State<CategoryDetailedVersatileSlider> createState() =>
      _CategoryDetailedVersatileSliderState();
}

class _CategoryDetailedVersatileSliderState
    extends State<CategoryDetailedVersatileSlider> {
  late final PageController controller;
  int page = 0;
  late int nextPage;

  @override
  void initState() {
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenController();
      _animateSlider();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _listenController() {
    controller.addListener(() {
      page = controller.page!.round();
      nextPage = page + 1;
    });
  }

  Future<List<CachedNetworkImageProvider>> _loadAllImages() async {
    List<CachedNetworkImageProvider> cachedImages = [];
    widget.content?.forEach((element) {
      var configuration = createLocalImageConfiguration(context);
      cachedImages.add(CachedNetworkImageProvider(element?.imageUrl ?? "")
        ..resolve(configuration));
    });
    return cachedImages;
  }

  void _animateSlider() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      if (controller.hasClients) {
        nextPage = page + 1;
        Future.delayed(const Duration(seconds: 3)).then((value) {
          if (controller.hasClients) {
            controller
                .animateToPage(nextPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear)
                .then((_) => _animateSlider());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: widget.content != null
          ? Container(
              height: context.sw(size: 0.56),
              width: double.maxFinite,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 18.h),
              child: Stack(
                children: [
                  FutureBuilder<List<CachedNetworkImageProvider>>(
                    future: _loadAllImages(),
                    builder: (context, snapshot) {
                      return ((snapshot.hasData &&
                                  snapshot.data != null &&
                                  (snapshot.data?.isNotEmpty ?? false))
                              ? PageView.builder(
                                  controller: controller,
                                  itemBuilder: (context, index) {
                                    int currentIndex =
                                        index % (snapshot.data?.length ?? 0);
                                    final item =
                                        widget.content?.elementAt(currentIndex);
                                    return GestureDetector(
                                      onTap: () {
                                        NavRoutes.instance.navByType(
                                            context,
                                            item?.linkType,
                                            item?.linkId,
                                            item?.categoryPage);
                                      },
                                      child: CommonCachedNetworkImage(
                                          image: snapshot.data!
                                              .elementAt(currentIndex)
                                              .url),
                                    );
                                  },
                                )
                              : const SizedBox.shrink())
                          .animatedSwitch(
                              duration: 500, curvesIn: Curves.easeIn);
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: (widget.content?.length ?? 0),
                        effect: ScrollingDotsEffect(
                            strokeWidth: 1.0,
                            activeStrokeWidth: 1.0,
                            paintStyle: PaintingStyle.fill,
                            activeDotColor: Colors.white.withOpacity(0.9),
                            dotColor: Colors.white.withOpacity(0.6),
                            dotHeight: 7.r,
                            dotWidth: 7.r),
                      ),
                    ),
                  )
                ],
              ))
          : const SizedBox(),
    );
  }
}
