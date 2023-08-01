import 'package:flutter/material.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/constants.dart';
import '../../../models/loyalty_point_model.dart';
import '../../../providers/loyalty_provider.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';
import '../../error_screens/api_error_screens.dart';
import '../../error_screens/custom_error_screens.dart';
import 'loyalty_bill_tile.dart';
import 'loyalty_error_view.dart';

class LoyaltyBillPointView extends StatelessWidget {
  final VoidCallback? onRefresh;

  const LoyaltyBillPointView({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<LoyaltyProvider, Tuple2<LoaderState, WacLoyaltyBillPoint?>>(
      selector: (context, provider) =>
          Tuple2(provider.billPointLoadState, provider.loyaltyBillPoint),
      builder: (context, data, child) {
        switch (data.item1) {
          case LoaderState.loaded:
            return _BillView(onRefresh: onRefresh);
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
                title: Constants.noBillPoints,
                subTitle: Constants.theyDontHaveAnyBillPoints,
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
                title: Constants.noBillPoints,
                subTitle: Constants.theyDontHaveAnyBillPoints,
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

class _BillView extends StatelessWidget {
  final VoidCallback? onRefresh;
  const _BillView({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<LoyaltyProvider, WacLoyaltyBillPoint?>(
      selector: (context, provider) => provider.loyaltyBillPoint,
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
