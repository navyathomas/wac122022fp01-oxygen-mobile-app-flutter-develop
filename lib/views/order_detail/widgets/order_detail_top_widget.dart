import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/models/arguments/product_detail_arguments.dart';
import 'package:oxygen/models/product_detail_model.dart' as p;
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/my_orders/widgets/demo_request.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';

import '../../../models/arguments/service_request_arguments.dart';
import '../../../models/my_orders_model.dart';

class OrderDetailTopWidget extends StatelessWidget {
  OrderDetailTopWidget({Key? key, this.products, this.status, this.id})
      : super(key: key);

  final List<Products>? products;
  String? status;
  final String? id;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        var prod = products?[index];
        return SizedBox(
          width: context.sw(),
          child: Column(
            children: [
              18.59.verticalSpace,
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, RouteGenerator.routeProductDetailScreen,
                    arguments: ProductDetailsArguments(
                        sku: products?[index].orderDetails?.sku ?? '',
                        isFromInitialState: true)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: SizedBox(
                    width: context.sw(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 113.w,
                          child: CommonCachedNetworkImageFixed(
                            width: 96.w,
                            height: 85.h,
                            image: prod?.smallImage?.url ?? '',
                          ),
                        ),
                        12.82.horizontalSpace,
                        Expanded(
                          child: SizedBox(
                            width: context.sw(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: context.sw(),
                                  child: Text(
                                    prod?.orderDetails?.name ?? '',
                                    style: FontPalette.f1B1B1B_14Regular,
                                  ).avoidOverFlow(maxLine: 2),
                                ),
                                10.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Constants.productPrice,
                                      style: FontPalette.f343434_14Medium,
                                    ),
                                    Text(
                                      setPriceInInt(prod
                                              ?.orderDetails?.regularPrice) ??
                                          (prod?.orderDetails?.regularPrice ??
                                              ''),
                                      style: FontPalette.black14Regular,
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Constants.quantity,
                                      style: FontPalette.f343434_14Medium,
                                    ),
                                    Text(
                                      prod?.orderDetails?.quantity ?? '',
                                      style: FontPalette.black14Regular,
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                prod?.orderDetails?.discount != null &&
                                        prod?.orderDetails?.discount != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${Constants.discount}:',
                                            style: FontPalette.f343434_14Medium,
                                          ),
                                          Text(
                                            prod?.orderDetails?.discount
                                                    ?.toString() ??
                                                '',
                                            style: FontPalette.black14Regular,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                prod?.orderDetails?.discount != null &&
                                        prod?.orderDetails?.discount != 0
                                    ? 10.verticalSpace
                                    : const SizedBox.shrink(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Constants.subTotal,
                                      style: FontPalette.f343434_14Medium,
                                    ),
                                    Text(
                                      setPriceInInt(
                                              prod?.orderDetails?.finalPrice) ??
                                          (prod?.orderDetails?.finalPrice ??
                                              ''),
                                      style: FontPalette.black14Regular,
                                    ),
                                  ],
                                ),
                                12.59.verticalSpace,
                                if (status?.toLowerCase() ==
                                    Constants.delivered.toLowerCase())
                                  DemoRequestBtn(
                                    onPressed: () => Navigator.pushNamed(
                                        context,
                                        RouteGenerator.routeServiceRequest,
                                        arguments: ServiceRequestArguments(
                                            orderId: id ?? '',
                                            itemId: (products?[0]
                                                        .orderDetails
                                                        ?.id ??
                                                    '')
                                                .toString(),
                                            isDemoRequest: true)),
                                  ),
                                20.verticalSpace
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).removeSplash(),
              status?.toLowerCase() == Constants.delivered.toLowerCase()
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Container(
                        width: context.sw(),
                        height: 1,
                        color: HexColor('#E6E6E6'),
                      ),
                    )
                  : const SizedBox.shrink(),
              status?.toLowerCase() == Constants.delivered.toLowerCase()
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context,
                            RouteGenerator.routeSubmitRatingsAndReviewsScreen,
                            arguments: p.Item(
                                mediaGallery: [
                                  p.MediaGallery(
                                    url: prod?.smallImage?.url,
                                  ),
                                ],
                                name: prod?.orderDetails?.name,
                                sku: prod?.orderDetails?.sku));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: SizedBox(
                          width: context.sw(),
                          height: 55.41.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constants.rateAndReview,
                                style: FontPalette.f282C3F_16Medium,
                              ),
                              SizedBox(
                                height: 12.r,
                                width: 12.r,
                                child: SvgPicture.asset(
                                  Assets.iconsRightArrow,
                                  color: HexColor("#7B7E8E"),
                                ),
                              ),
                            ],
                          ),
                          // color: Colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                width: context.sw(),
                height: 5,
                color: HexColor('#F3F3F7'),
              )
            ],
          ),
        );
      },
      itemCount: products?.length,
    );
  }

  String? setPriceInInt(String? value) {
    if (value != null) {
      value = value.replaceAll('₹', '');
      value = value.replaceAll(',', '');
      var toDouble = double.tryParse(value);
      var toInt = toDouble?.toInt();
      if (toInt != null) {
        var toRupee = toInt.toRupee;
        return toRupee;
      }
    }
    return null;
  }
}
