import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/cached_image_view.dart';

import '../../../../models/home_data_model.dart';

class HomeEmiSlider extends StatefulWidget {
  final List<Content>? contentData;

  const HomeEmiSlider({Key? key, this.contentData}) : super(key: key);

  @override
  State<HomeEmiSlider> createState() => _HomeEmiSliderState();
}

class _HomeEmiSliderState extends State<HomeEmiSlider> {
  late final PageController _pageController;
  int page = 0;
  late int nextPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      color: HexColor('#F3F3F7'),
      child: Row(
        children: [
          Container(
            height: double.maxFinite,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              Constants.availableEMIs,
              style: FontPalette.black16Medium,
            ),
          ),
          Container(
            height: 28.h,
            width: 1.w,
            color: HexColor('#B9B9B9'),
          ),
          Expanded(
              child: PageView.builder(
            controller: _pageController,
            padEnds: false,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              int currentIndex = index % (widget.contentData?.length ?? 0);
              return Padding(
                padding: EdgeInsets.only(
                    left: currentIndex == 0 ? 13.w : 12.w,
                    top: 10.h,
                    bottom: 10.h,
                    right: (widget.contentData!.length - 1 == currentIndex)
                        ? 13.w
                        : 0),
                child: CachedImageView(
                  image: widget.contentData?[currentIndex].images ?? '',
                  height: double.maxFinite,
                  width: 80.w,
                ),
              );
            },
          ))
          /*Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              controller: controller,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 13.w : 12.w,
                      top: 10.h,
                      bottom: 10.h,
                      right:
                          (widget.contentData!.length - 1 == index) ? 13.w : 0),
                  child: CachedImageView(
                    image: widget.contentData?[index].images ?? '',
                    height: double.maxFinite,
                    width: 80.w,
                  ),
                );
              },
              itemCount: widget.contentData?.length ?? 0,
            ),
          )*/
        ],
      ),
    ).convertToSliver();
  }

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.3);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenController();
      _animateSlider();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _listenController() {
    _pageController.addListener(() {
      page = _pageController.page!.round();
      nextPage = page + 1;
    });
  }

  void _animateSlider() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      if (_pageController.hasClients && mounted) {
        nextPage = page + 1;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          if (_pageController.hasClients && mounted) {
            _pageController
                .animateToPage(nextPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear)
                .then((_) => _animateSlider());
          }
        });
      }
    });
  }
}
