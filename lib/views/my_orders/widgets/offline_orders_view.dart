import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/models/arguments/tracking_details_arguments.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/arguments/my_order_details_arguments.dart';
import '../../../models/my_orders_model.dart';
import '../../../providers/my_orders_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';
import '../../error_screens/api_error_screens.dart';
import '../../error_screens/custom_error_screens.dart';
import 'my_orders_product_widget.dart';

class OfflineOrdersView extends StatefulWidget {
  final MyOrdersProvider myOrdersProvider;
  const OfflineOrdersView({Key? key, required this.myOrdersProvider})
      : super(key: key);

  @override
  State<OfflineOrdersView> createState() => _OfflineOrdersViewState();
}

class _OfflineOrdersViewState extends State<OfflineOrdersView> {
  late final MyOrdersProvider myOrdersProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.myOrdersProvider,
      child: Selector<MyOrdersProvider, Tuple2<LoaderState, bool>>(
        selector: (_, provider) =>
            Tuple2(provider.loaderState, provider.btnLoaderState),
        builder: (_, data, __) {
          switch (data.item1) {
            case LoaderState.loaded:
              return _MyOrdersList(
                onPageRefresh: () => _onPageRefresh(),
                myOrdersProvider: myOrdersProvider,
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
                  btnLoader: data.item2,
                  onTryAgain: () async {
                    await myOrdersProvider.getOfflineOrdersData(context,
                        updateBtnLoadingState: true);
                  },
                ),
              );
            case LoaderState.networkErr:
              return CustomSlidingFadeAnimation(
                slideDuration: const Duration(milliseconds: 250),
                child: ApiErrorScreens(
                  loaderState: data.item1,
                  btnLoader: data.item2,
                  onTryAgain: () async {
                    await myOrdersProvider.getOfflineOrdersData(context,
                        updateBtnLoadingState: true);
                  },
                ),
              );
            case LoaderState.noData:
              return CustomSlidingFadeAnimation(
                slideDuration: const Duration(milliseconds: 250),
                child: CustomErrorScreen(
                  errorType: CustomErrorType.noOrders,
                  onButtonPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        RouteGenerator.routeMainScreen, (route) => false);
                  },
                ),
              );
            case LoaderState.noProducts:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  void _onPageRefresh() async {
    myOrdersProvider.pageDispose();
    await myOrdersProvider.getOfflineOrdersData(context,
        updateBtnLoadingState: true);
  }

  @override
  void initState() {
    myOrdersProvider = widget.myOrdersProvider;
    if (myOrdersProvider.myOfflineOrdersData == null) {
      CommonFunctions.afterInit(() async {
        await myOrdersProvider.getOfflineOrdersData(context);
        await myOrdersProvider.setEmailAddress();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _MyOrdersList extends StatelessWidget {
  final Function onPageRefresh;
  final MyOrdersProvider myOrdersProvider;
  const _MyOrdersList(
      {Key? key, required this.onPageRefresh, required this.myOrdersProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSlidingFadeAnimation(
      slideDuration: const Duration(milliseconds: 250),
      child: Selector<MyOrdersProvider, List<Items>?>(
        selector: (_, provider) => provider.myOfflineOrdersData?.items,
        builder: (_, data, __) => RefreshIndicator(
          onRefresh: () async => onPageRefresh(),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return Column(
                    children: [
                      index != 0
                          ? Divider(
                              height: 5.h,
                              thickness: 5.h,
                              color: HexColor("#F3F3F7"),
                            )
                          : const SizedBox.shrink(),
                      InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.routeOrderDetailScreen,
                            arguments: MyOrderDetailsArguments(
                                id: (data?[index].id ?? '').toString(),
                                status: data?[index].status,
                                products: data?[index].products,
                                currentStatus: data?[index].currentStatus,
                                orderProcess:
                                    data?[index].orderProcess?.getJson(),
                                createdAt: data?[index].createdAt,
                                orderNumber: data?[index].orderNumber,
                                address: data?[index].shippingAddresses,
                                excludingTax:
                                    data?[index].prices?.subtotalExcludingTax,
                                includingTax:
                                    data?[index].prices?.subtotalIncludingTax,
                                gst: data?[index].prices?.gst,
                                grandTotal: data?[index].prices?.grandTotal,
                                discount: (data?[index].prices?.discount ?? [])
                                        .isNotEmpty
                                    ? data![index].prices!.discount![0]
                                    : null,
                                paymentMethod: data?[index].orderPaymentMethod,
                                shippingFee:
                                    (data?[index].prices?.shippingFee ?? [])
                                            .isNotEmpty
                                        ? (data?[index]
                                            .prices
                                            ?.shippingFee?[0]
                                            .selectedShippingMethod)
                                        : SelectedShippingMethod(),
                                myOrdersProvider: myOrdersProvider),
                          );
                        },
                        child: MyOrdersProductWidget(
                          id: (data?[index].id ?? '').toString(),
                          products: data?[index].products,
                          currentStatus: data?[index].currentStatus,
                          status: data?[index].status,
                          onTrackOrderTap: () {
                            Navigator.of(context).pushNamed(
                                RouteGenerator.routeTrackingDetailScreen,
                                arguments: TrackingDetailsArguments(
                                    trackDeliveryStatus:
                                        data?[index].trackDeliveryStatus,
                                    customerDeliveryDetails:
                                        data?[index].customerDeliveryDetails));
                          },
                        ),
                      ),
                    ],
                  );
                }, childCount: data?.length ?? 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
