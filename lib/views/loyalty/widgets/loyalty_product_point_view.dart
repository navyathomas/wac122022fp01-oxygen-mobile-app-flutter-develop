import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/loyalty_point_model.dart';
import '../../../providers/loyalty_provider.dart';
import '../../../widgets/common_linear_progress.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';
import '../../error_screens/api_error_screens.dart';
import '../../error_screens/custom_error_screens.dart';
import 'loyalty_bill_tile.dart';
import 'loyalty_error_view.dart';

class LoyaltyProductPointView extends StatelessWidget {
  final VoidCallback? onRefresh;

  const LoyaltyProductPointView({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<LoyaltyProvider,
        Tuple2<LoaderState, WacLoyaltyProductPoint?>>(
      selector: (context, provider) =>
          Tuple2(provider.loaderState, provider.loyaltyProductPoint),
      builder: (context, data, child) {
        switch (data.item1) {
          case LoaderState.loaded:
            return _ProductView(
              onRefresh: onRefresh,
            );
          case LoaderState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case LoaderState.error:
            return CustomSlidingFadeAnimation(
              slideDuration: const Duration(milliseconds: 250),
              child: ApiErrorScreens(
                loaderState: data.item1,
                onTryAgain: () {
                  onRefresh?.call();
                },
              ),
            );
          case LoaderState.networkErr:
            return CustomSlidingFadeAnimation(
              slideDuration: const Duration(milliseconds: 250),
              child: ApiErrorScreens(
                loaderState: data.item1,
                onTryAgain: () {
                  onRefresh?.call();
                },
              ),
            );
          case LoaderState.noData:
            return CustomSlidingFadeAnimation(
              slideDuration: const Duration(milliseconds: 250),
              child: LoyaltyErrorView(
                title: Constants.noProductPoints,
                subTitle: Constants.theyDontHaveAnyProductPoints,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteGenerator.routeMainScreen, (route) => false);
                },
              ),
            );
          case LoaderState.noProducts:
            return CustomSlidingFadeAnimation(
              slideDuration: const Duration(milliseconds: 250),
              child: LoyaltyErrorView(
                title: Constants.noProductPoints,
                subTitle: Constants.theyDontHaveAnyProductPoints,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteGenerator.routeMainScreen, (route) => false);
                },
              ),
            );
        }
      },
    );
  }
}

class _ProductView extends StatelessWidget {
  final VoidCallback? onRefresh;
  const _ProductView({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<LoyaltyProvider, WacLoyaltyProductPoint?>(
      selector: (context, provider) => provider.loyaltyProductPoint,
      builder: (context, data, child) {
        return SizedBox.expand(
          child: RefreshIndicator(
            onRefresh: () async {
              onRefresh?.call();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return LoyaltyBillTile(
                    wacLoyaltyPoint: data?.wacLoyaltyPoint?[index]);
              },
              itemCount: data?.wacLoyaltyPoint?.length ?? 0,
            ),
          ),
        );
      },
    );
  }
}
