import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailImageSlider extends StatefulWidget {
  final List<MediaGallery?>? mediaGallery;

  const ProductDetailImageSlider({
    Key? key,
    this.mediaGallery,
  }) : super(key: key);

  @override
  State<ProductDetailImageSlider> createState() =>
      _ProductDetailImageSliderState();
}

class _ProductDetailImageSliderState extends State<ProductDetailImageSlider> {
  late final PageController controller;
  int page = 0;
  late int nextPage;

  Future<List<CachedNetworkImageProvider>> loadAllImages() async {
    List<CachedNetworkImageProvider> cachedImages = [];
    widget.mediaGallery?.forEach((element) {
      var configuration = createLocalImageConfiguration(context);
      cachedImages.add(CachedNetworkImageProvider(element?.url ?? "")
        ..resolve(configuration));
    });
    return cachedImages;
  }

  @override
  void initState() {
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.mediaGallery != null &&
          (widget.mediaGallery?.length ?? 0) > 1) {
        _listenController();
        _animateSlider();
      }
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

  void _animateSlider() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      if (controller.hasClients) {
        nextPage = page + 1;
        Future.delayed(const Duration(seconds: 3)).then((value) {
          if (controller.hasClients) {
            if (nextPage <= (widget.mediaGallery?.length ?? 0)) {
              controller
                  .animateToPage(nextPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear)
                  .then((_) => _animateSlider());
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.mediaGallery != null
        ? Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Stack(
              children: [
                SizedBox(
                    height: context.sw(size: .6788),
                    child: (widget.mediaGallery != null &&
                            (widget.mediaGallery?.length ?? 0) > 1)
                        ? FutureBuilder<List<CachedNetworkImageProvider>>(
                            future: loadAllImages(),
                            builder: (context, snapshot) {
                              return ((snapshot.hasData &&
                                          snapshot.data != null &&
                                          (snapshot.data?.isNotEmpty ?? false))
                                      ? PageView.builder(
                                          controller: controller,
                                          itemBuilder: (context, index) {
                                            int currentIndex = index %
                                                (snapshot.data?.length ?? 0);
                                            return CommonCachedNetworkImage(
                                                image: snapshot.data!
                                                    .elementAt(currentIndex)
                                                    .url);
                                          },
                                        )
                                      : const SizedBox.shrink())
                                  .animatedSwitch(
                                      duration: 500, curvesIn: Curves.easeIn);
                            },
                          )
                        : CommonCachedNetworkImage(
                            image: widget.mediaGallery?.first?.url ?? "",
                          )),
                if (widget.mediaGallery != null &&
                    (widget.mediaGallery?.length ?? 0) > 1)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: (widget.mediaGallery?.length ?? 0),
                        effect: ScrollingDotsEffect(
                            strokeWidth: 1.0,
                            activeStrokeWidth: 1.0,
                            paintStyle: PaintingStyle.fill,
                            activeDotColor: Colors.black,
                            activeDotScale: 1.0,
                            spacing: 10.w,
                            dotColor: Colors.black.withOpacity(.30),
                            dotHeight: 7.r,
                            dotWidth: 7.r),
                      ),
                    ),
                  )
              ],
            ))
        : const SizedBox();
  }
}
