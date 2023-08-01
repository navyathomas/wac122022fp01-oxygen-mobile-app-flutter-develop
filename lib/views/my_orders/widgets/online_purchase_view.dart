import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/arguments/tracking_details_arguments.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/common_function.dart';
import '../../../common/constants.dart';
import '../../../common/route_generator.dart';
import '../../../models/arguments/my_order_details_arguments.dart';
import '../../../models/my_orders_model.dart';
import '../../../utils/color_palette.dart';
import '../../../widgets/custom_sliding_fade_animation.dart';
import '../../error_screens/api_error_screens.dart';
import '../../error_screens/custom_error_screens.dart';
import 'my_orders_product_widget.dart';

class OnlinePurchase extends StatefulWidget {
  final MyOrdersProvider myOrdersProvider;
  const OnlinePurchase({Key? key, required this.myOrdersProvider})
      : super(key: key);

  @override
  State<OnlinePurchase> createState() => _OnlinePurchaseState();
}

class _OnlinePurchaseState extends State<OnlinePurchase> {
  late final MyOrdersProvider myOrdersProvider;
  ScrollController scrollController = ScrollController();

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
                scrollController: scrollController,
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
                    await myOrdersProvider.getMyOrdersData(context,
                        loaderStateFlag: false, updateBtnLoadingState: true);
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
                    await myOrdersProvider.getMyOrdersData(context,
                        loaderStateFlag: false, updateBtnLoadingState: true);
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
    await myOrdersProvider.getMyOrdersData(context, loaderStateFlag: false);
  }

  @override
  void initState() {
    myOrdersProvider = widget.myOrdersProvider;
    scrollController.addListener(
        () => myOrdersProvider.pagination(context, scrollController));
    if (myOrdersProvider.myOrdersData == null) {
      CommonFunctions.afterInit(() async {
        await myOrdersProvider.getMyOrdersData(context, loaderStateFlag: true);
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
  final ScrollController scrollController;
  final Function onPageRefresh;
  final MyOrdersProvider myOrdersProvider;
  const _MyOrdersList(
      {Key? key,
      required this.scrollController,
      required this.onPageRefresh,
      required this.myOrdersProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSlidingFadeAnimation(
      slideDuration: const Duration(milliseconds: 250),
      child: Selector<MyOrdersProvider, Tuple2<List<Items>?, bool>>(
        selector: (_, provider) =>
            Tuple2(provider.myOrdersData?.items, provider.paginationLoadState),
        builder: (_, data, __) => RefreshIndicator(
          onRefresh: () async => onPageRefresh(),
          child: CustomScrollView(
            shrinkWrap: true,
            controller: scrollController,
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
                                id: (data.item1?[index].id ?? '').toString(),
                                status: data.item1?[index].status,
                                products: data.item1?[index].products,
                                currentStatus: data.item1?[index].currentStatus,
                                orderProcess:
                                    data.item1?[index].orderProcess?.getJson(),
                                createdAt: data.item1?[index].createdAt,
                                orderNumber: data.item1?[index].orderNumber,
                                address: data.item1?[index].shippingAddresses,
                                excludingTax: data
                                    .item1?[index].prices?.subtotalExcludingTax,
                                includingTax: data
                                    .item1?[index].prices?.subtotalIncludingTax,
                                gst: data.item1?[index].prices?.gst,
                                grandTotal:
                                    data.item1?[index].prices?.grandTotal,
                                discount:
                                    (data.item1?[index].prices?.discount ?? [])
                                            .isNotEmpty
                                        ? data
                                            .item1![index].prices!.discount![0]
                                        : null,
                                paymentMethod:
                                    data.item1?[index].orderPaymentMethod,
                                shippingFee:
                                    (data.item1?[index].prices?.shippingFee ??
                                                [])
                                            .isNotEmpty
                                        ? (data
                                            .item1?[index]
                                            .prices
                                            ?.shippingFee?[0]
                                            .selectedShippingMethod)
                                        : SelectedShippingMethod(),
                                myOrdersProvider: myOrdersProvider),
                          );
                        },
                        child: MyOrdersProductWidget(
                          id: (data.item1?[index].id ?? '').toString(),
                          products: data.item1?[index].products,
                          currentStatus: data.item1?[index].currentStatus,
                          status: data.item1?[index].status,
                          onTrackOrderTap: () {
                            Navigator.of(context).pushNamed(
                                RouteGenerator.routeTrackingDetailScreen,
                                arguments: TrackingDetailsArguments(
                                    trackDeliveryStatus:
                                        data.item1?[index].trackDeliveryStatus,
                                    customerDeliveryDetails: data.item1?[index]
                                        .customerDeliveryDetails));
                          },
                        ),
                      ),
                    ],
                  );
                }, childCount: data.item1?.length ?? 0),
              ),
              data.item2
                  ? SizedBox(
                      width: context.sw(),
                      height: 50.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ).convertToSliver()
                  : const SizedBox.shrink().convertToSliver()
            ],
          ),
        ),
      ),
    );
  }
}
