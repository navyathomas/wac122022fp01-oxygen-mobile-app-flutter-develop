import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/order_details_response_model.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_fade_in_image.dart';

class OrderCompleteProductDetailsWidget extends StatelessWidget {
  const OrderCompleteProductDetailsWidget(
      {Key? key, this.orderDetailsProducts, this.index, this.length})
      : super(key: key);
  final OrderDetailsProducts? orderDetailsProducts;
  final int? index;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        return Column(
          children: [
            Row(
              children: [
                CommonFadeInImage(
                  image: orderDetailsProducts?.thumbnail?.url ?? '',
                  fit: BoxFit.contain,
                  height: p1.maxWidth * .2639,
                  width: p1.maxWidth * .2639,
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetailsProducts?.orderDetails?.name ?? '',
                        style: FontPalette.black14Regular,
                      ),
                      5.verticalSpace,
                      Text(
                        orderDetailsProducts?.orderDetails?.finalPrice ?? '',
                        style: FontPalette.black16Bold,
                      ),
                      7.verticalSpace,
                      Text(
                        'Qty: ${orderDetailsProducts?.orderDetails?.quantity ?? ''}',
                        style: FontPalette.black14Regular
                            .copyWith(color: HexColor('#7E818C')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (index! + 1 != length) 11.verticalSpace,
            if (index! + 1 != length)
              Divider(
                color: HexColor('#E6E6E6'),
                thickness: 1.5.h,
                height: 1.5.h,
              ),
            if (index! + 1 != length) 11.verticalSpace
          ],
        );
      },
    );
  }
}
