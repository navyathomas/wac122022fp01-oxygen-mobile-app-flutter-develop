import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/widgets/custom_sliding_fade_animation.dart';

import '../../../../common/constants.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/custom_btn.dart';

class HomeErrorScreen extends StatelessWidget {
  final LoaderState loaderState;
  final VoidCallback? onTap;

  const HomeErrorScreen({Key? key, required this.loaderState, this.onTap})
      : super(key: key);

  Widget _errorView() {
    switch (loaderState) {
      case LoaderState.error:
        return _serverError();
      case LoaderState.networkErr:
        return _nwkError();
      case LoaderState.noData:
        return _noDataError();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _serverError() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _nwkError() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _noDataError() {
    return Column(
      children: [
        SvgPicture.asset(Assets.iconsNoDataFound),
        40.44.verticalSpace,
        Text(
          'No Data Found!',
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

  @override
  Widget build(BuildContext context) {
    return CustomSlidingFadeAnimation(
      slideDuration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: context.sw(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            195.06.verticalSpace,
            _errorView(),
            30.33.verticalSpace,
            if (onTap != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 131.5.w),
                child: CustomButton(
                  isLoading: false,
                  title: Constants.tryAgain,
                  onPressed: onTap,
                ),
              )
          ],
        ),
      ),
    );
  }
}
