import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/compare_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/compare/widgets/compare_product_details_list_view.dart';
import 'package:oxygen/views/compare/widgets/horizontal_product_list_view.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_btn.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late CompareProvider compareProvider;

  @override
  void initState() {
    compareProvider = CompareProvider();
    compareProvider.getCompareProductDetails();
    super.initState();
  }

  @override
  void dispose() {
    compareProvider.dispose();
    super.dispose();
  }

  Widget returnEmptyBox(int length) {
    switch (length) {
      case 3:
        return const SizedBox.shrink();
      case 2:
        return SizedBox(
          width: context.sw(size: 1 / 3),
          child: Container(
            width: context.sw(size: 1 / 3),
            padding:
                EdgeInsets.only(top: 8.h, bottom: 18.h, left: 12.w, right: 7.w),
            height: 293.h,
            child: Column(
              children: [
                Container(
                  color: HexColor("#E6E6E6"),
                  height: 88.77.h,
                  width: 88.77.w,
                ),
                20.verticalSpace,
                _AddProductButton()
              ],
            ),
          ),
        );
      case 1:
        return SizedBox(
          width: context.sw(size: 2 / 3),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 8.h, bottom: 18.h, left: 12.w, right: 7.w),
                height: 293.h,
                child: Column(
                  children: [
                    Container(
                      color: HexColor("#E6E6E6"),
                      height: 88.77.h,
                      width: 88.77.w,
                    ),
                    20.verticalSpace,
                    _AddProductButton()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 8.h, bottom: 18.h, left: 12.w, right: 7.w),
                height: 293.h,
                child: Column(
                  children: [
                    Container(
                      color: HexColor("#E6E6E6"),
                      height: 88.77.h,
                      width: 88.77.w,
                    ),
                    20.verticalSpace,
                    _AddProductButton()
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        buildContext: context,
        titleWidget: Text(
          Constants.compare,
          style: FontPalette.black18Medium,
        ),
        actionList: const [],
      ),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: compareProvider,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Selector<CompareProvider, LoaderState>(
                  selector: (context, compareProvider) =>
                      compareProvider.loaderState,
                  builder: (context, value, child) {
                    return value == LoaderState.loading
                        ? const CommonLinearProgress()
                        : compareProvider.compareProductList.notEmpty
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CompareHorizontalListview(
                                            compareProvider: compareProvider),
                                        5.verticalSpace,
                                        const CompareProductDetailsView(),
                                        10.verticalSpace
                                      ],
                                    ),
                                  ),
                                  if (compareProvider
                                          .compareProductList.length ==
                                      1)
                                    SizedBox(
                                      width: context.sw(size: 1 / 2),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8.h,
                                            bottom: 18.h,
                                            left: 12.w,
                                            right: 7.w),
                                        height: 293.h,
                                        child: Column(
                                          children: [
                                            Container(
                                              color: HexColor("#E6E6E6"),
                                              height: 68.77.h,
                                              width: 68.77.w,
                                            ),
                                            20.verticalSpace,
                                            _AddProductButton()
                                          ],
                                        ),
                                      ),
                                    )
                                  // returnEmptyBox(
                                  //     compareProvider.compareProductList.length),
                                ],
                              )
                            : _EmptyCompareList(height: constraints.maxHeight);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyCompareList extends StatelessWidget {
  final double height;

  const _EmptyCompareList({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
              dimension: 70.r,
              child: SvgPicture.asset(Assets.iconsEmptyCompare)),
          40.verticalSpace,
          Text(
            Constants.compareListEmpty,
            textAlign: TextAlign.center,
            style: FontPalette.black18Medium,
          ),
          6.verticalSpace,
          Text(
            Constants.addProductsToCompare,
            textAlign: TextAlign.center,
            style: FontPalette.black14Regular,
          ),
          30.verticalSpace,
          SizedBox(
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorPalette.materialPrimary)),
              child: Text(
                Constants.addProducts.toUpperCase(),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: FontPalette.white16Bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  _AddProductButton({Key? key}) : super(key: key);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return CustomButton(
            title: Constants.addProduct,
            height: 30.h,
            width: double.maxFinite,
            fontStyle: FontPalette.white13Medium,
            isLoading: value,
            onPressed: () => Navigator.pop(context),
          );
        });
  }
}
