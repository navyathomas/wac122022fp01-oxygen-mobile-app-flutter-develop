import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/arguments/service_request_arguments.dart';
import 'package:oxygen/models/my_orders_model.dart';
import 'package:oxygen/providers/my_orders_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:provider/provider.dart';

import 'demo_request.dart';

class MyOrdersProductWidget extends StatelessWidget {
  const MyOrdersProductWidget(
      {Key? key,
      this.products,
      this.currentStatus,
      this.status,
      this.onTrackOrderTap,
      this.id})
      : super(key: key);

  final List<Products>? products;
  final CurrentStatus? currentStatus;
  final String? status;
  final void Function()? onTrackOrderTap;
  final String? id;
  Widget _buildSingleProductWidget(BuildContext context) {
    return SizedBox(
      width: context.sw(),
      // height: 116.h,
      child: Padding(
        padding: EdgeInsets.only(top: 12.5.h, bottom: 25.h),
        child: Row(
          children: [
            13.horizontalSpace,
            CommonCachedNetworkImageFixed(
              image: products?[0].smallImage?.url ?? '',
              width: 88.r,
              height: 88.r,
            ),
            16.5.horizontalSpace,
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: status?.toLowerCase() ==
                                      Constants.delivered.toLowerCase()
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 4.w),
                                      child: SvgPicture.asset(
                                          Assets.iconsDelivered),
                                    )
                                  : const SizedBox.shrink()),
                          TextSpan(
                            text: (status ?? '').replaceUnderscore(),
                            style: status?.toLowerCase() == Constants.canceled
                                ? FontPalette.f179614_14Medium
                                    .copyWith(color: HexColor('#E50019'))
                                : status == Constants.paymentFailed
                                    ? FontPalette.f179614_14Medium.copyWith(
                                        color: const Color.fromARGB(
                                            255, 255, 191, 0))
                                    : status?.toLowerCase() ==
                                            Constants.delivered.toLowerCase()
                                        ? FontPalette.f179614_14Medium.copyWith(
                                            color: HexColor('#282C3F'))
                                        : FontPalette.f179614_14Medium,
                          ),
                          WidgetSpan(child: 4.horizontalSpace),
                          status?.toLowerCase() ==
                                  Constants.delivered.toLowerCase()
                              ? TextSpan(
                                  text:
                                      'on ${(context.read<MyOrdersProvider>().reFormatCurrentStatusDate(currentStatus?.date) ?? currentStatus?.date) ?? ''}',
                                  style: FontPalette.f6C6C6C_12Regular,
                                )
                              : const WidgetSpan(child: SizedBox.shrink()),
                        ],
                      ),
                      maxLines: 1,
                    ),
                    6.5.verticalSpace,
                    Text(
                      products?[0].orderDetails?.name ?? '',
                      style: FontPalette.black14Regular.copyWith(height: 1.4),
                    ).avoidOverFlow(maxLine: 2),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (status?.toLowerCase() ==
                            Constants.delivered.toLowerCase())
                          Padding(
                            padding: EdgeInsets.only(right: 7.w),
                            child: DemoRequestBtn(
                              onPressed: () => Navigator.pushNamed(
                                  context, RouteGenerator.routeServiceRequest,
                                  arguments: ServiceRequestArguments(
                                      orderId: id ?? '',
                                      itemId:
                                          (products?[0].orderDetails?.id ?? '')
                                              .toString(),
                                      isDemoRequest: true)),
                            ),
                          ),
                        Flexible(
                          child: _TrackOrderBtn(onTap: onTrackOrderTap),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // 20.horizontalSpace,
            Padding(
              padding: EdgeInsets.only(right: 17.w, left: 17.w),
              child: SizedBox(
                height: 12.r,
                width: 12.r,
                child: SvgPicture.asset(
                  Assets.iconsRightArrow,
                  color: HexColor("#7B7E8E"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiProductWidget(BuildContext context) {
    return SizedBox(
      width: context.sw(),
      child: Column(
        children: [
          15.verticalSpace,
          SizedBox(
            width: context.sw(),
            height: 51.55.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    cacheExtent: 9999,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 9.45.w,
                          right:
                              index == (products ?? []).length - 1 ? 9.45.w : 0,
                        ),
                        child: CommonCachedNetworkImageFixed(
                          image: products?[index].smallImage?.url ?? '',
                          width: 42.13.w,
                          height: 51.55.h,
                        ),
                      );
                    },
                    itemCount: products?.length ?? 0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 17.w, left: 17.w),
                  child: SizedBox(
                    height: 12.r,
                    width: 12.r,
                    child: SvgPicture.asset(
                      Assets.iconsRightArrow,
                      color: HexColor("#7B7E8E"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.56.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: context.sw(),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: status?.toLowerCase() ==
                                    Constants.delivered.toLowerCase()
                                ? Padding(
                                    padding: EdgeInsets.only(right: 4.w),
                                    child:
                                        SvgPicture.asset(Assets.iconsDelivered),
                                  )
                                : const SizedBox.shrink()),
                        TextSpan(
                          text: (status ?? '').replaceUnderscore(),
                          style: status?.toLowerCase() == Constants.canceled
                              ? FontPalette.f179614_14Medium.copyWith(
                                  color: HexColor('#E50019'),
                                )
                              : status == Constants.paymentFailed
                                  ? FontPalette.f179614_14Medium.copyWith(
                                      color: const Color.fromARGB(
                                          255, 255, 191, 0))
                                  : status?.toLowerCase() ==
                                          Constants.delivered.toLowerCase()
                                      ? FontPalette.f179614_14Medium.copyWith(
                                          color: HexColor('#282C3F'),
                                        )
                                      : FontPalette.f179614_14Medium,
                        ),
                        WidgetSpan(child: 4.horizontalSpace),
                        status?.toLowerCase() ==
                                Constants.delivered.toLowerCase()
                            ? TextSpan(
                                text:
                                    'on ${(context.read<MyOrdersProvider>().reFormatCurrentStatusDate(currentStatus?.date) ?? currentStatus?.date) ?? ''}',
                                style: FontPalette.f6C6C6C_12Regular,
                              )
                            : const WidgetSpan(
                                child: SizedBox.shrink(),
                              ),
                      ],
                    ),
                  ),
                ),
                6.5.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    context
                            .read<MyOrdersProvider>()
                            .getGroupedProductNames(products) ??
                        '',
                    style: FontPalette.black14Regular.copyWith(height: 1.4),
                  ).avoidOverFlow(maxLine: 2),
                ),
                7.67.verticalSpace,
                _TrackOrderBtn(
                    color: HexColor('#E50019'), onTap: onTrackOrderTap),
                14.14.verticalSpace,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((products ?? []).length > 1) {
      return _buildMultiProductWidget(context);
    } else {
      return _buildSingleProductWidget(context);
    }
  }
}

extension ReplaceUnderscoreFromStatus on String? {
  String? replaceUnderscore() {
    if (this == Constants.pendingPayment) {
      String r = '';
      var list = this!.split('_');
      r = '${list[0][0].toUpperCase()}${list[0].substring(1)} ${list[1][0].toUpperCase()}${list[1].substring(1)}';
      return r;
    } else {
      return '${this?[0].toUpperCase()}${this?.substring(1)}';
    }
  }
}

class _TrackOrderBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  const _TrackOrderBtn({Key? key, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Text(
          Constants.trackOrder,
          style: FontPalette.black14Medium
              .copyWith(decoration: TextDecoration.underline, color: color),
        ).avoidOverFlow(),
      ),
    );
  }
}
