import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';

class ApiErrorScreens extends StatefulWidget {
  const ApiErrorScreens(
      {super.key,
      required this.loaderState,
      this.onTryAgain,
      this.btnLoader = false});

  final LoaderState loaderState;
  final Function()? onTryAgain;
  final bool? btnLoader;

  @override
  State<ApiErrorScreens> createState() => _ApiErrorScreensState();
}

class _ApiErrorScreensState extends State<ApiErrorScreens> {
  Widget _noInternetScreen() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          195.06.verticalSpace,
          SvgPicture.asset(Assets.iconsNetworkError),
          49.33.verticalSpace,
          Text(
            Constants.apiErrorNoInternetTitle,
            style: FontPalette.black18Medium,
          ),
          6.verticalSpace,
          Text(
            Constants.apiErrorNoInternetSubTitle,
            style: FontPalette.f282C3F_14Regular,
          ),
          30.33.verticalSpace,
          CustomButton(
            isLoading: widget.btnLoader!,
            title: Constants.tryAgain,
            width: 132.w,
            onPressed: widget.onTryAgain,
          )
        ],
      ),
    );
  }

  Widget _serverErrorScreen() {
    return SizedBox(
      width: context.sw(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          195.06.verticalSpace,
          SvgPicture.asset(Assets.iconsServerError),
          49.33.verticalSpace,
          Text(
            Constants.apiErrorServerErrorTitle,
            style: FontPalette.black18Medium,
          ),
          6.verticalSpace,
          Text(
            Constants.apiErrorServerErrorSubTitle,
            style: FontPalette.f282C3F_14Regular,
          ),
          30.33.verticalSpace,
          CustomButton(
            isLoading: widget.btnLoader!,
            title: Constants.tryAgain,
            width: 132.w,
            onPressed: widget.onTryAgain,
          )
        ],
      ),
    );
  }

  Widget _noDataScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: context.sw()),
        225.verticalSpace,
        SvgPicture.asset(Assets.iconsNoDataFound),
        40.44.verticalSpace,
        Text(
          Constants.noDataFound,
          style: FontPalette.black18Medium,
        ),
        // 6.verticalSpace,
        // Text(
        //   'Sorry, we couldn’t find any products',
        //   style: FontPalette.f282C3F_14Regular,
        // )
      ],
    );
  }

  Widget _productEmptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.iconsEmptyProducts,
          height: 94.h,
          width: 86.w,
        ),
        41.verticalSpace,
        Text(
          'No Product Found!',
          style: FontPalette.black18Medium,
        ),
        6.verticalSpace,
        Text(
          'Sorry, we couldn’t find any products',
          style: FontPalette.black14Regular,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.loaderState) {
      case LoaderState.error:
        return _serverErrorScreen();
      case LoaderState.networkErr:
        return _noInternetScreen();
      case LoaderState.noData:
        return _noDataScreen();
      case LoaderState.loaded:
        return const SizedBox.shrink();
      case LoaderState.loading:
        return const SizedBox.shrink();
      case LoaderState.noProducts:
        return _productEmptyScreen();
    }
  }
}
