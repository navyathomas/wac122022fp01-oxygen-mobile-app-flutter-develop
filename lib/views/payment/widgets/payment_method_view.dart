import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/views/payment/widgets/pay_now_child_view.dart';
import 'package:oxygen/widgets/custom_expanded_widget.dart';

import '../../../models/payment_modes_model.dart';
import '../../../providers/payment_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/common_fade_in_image.dart';

class PaymentMethodView extends StatelessWidget {
  const PaymentMethodView({Key? key, required this.paymentProvider})
      : super(key: key);
  final PaymentProvider paymentProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount:
          paymentProvider.paymentModesModel?.getMobileAppPaymentModes?.length ??
              0,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 4.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        GetMobileAppPaymentModes? availablePaymentModes =
            paymentProvider.paymentModesModel?.getMobileAppPaymentModes?[index];
        return CustomExpandedWidget(
          backgroundColor: Colors.white,
          initiallyExpanded: index == 0,
          trailColor: HexColor('#7B7E8E'),
          enableDivider: false,
          expandedWidget: PaymentNowChildView(
            paymentProvider: paymentProvider,
            paymentMethods: availablePaymentModes?.paymentMethods,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                SizedBox(
                  height: 30.h,
                  child: CommonFadeInImage(
                    image: availablePaymentModes?.imageUrl ?? '',
                    width: 30.w,
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                    child: Text(
                  availablePaymentModes?.title ?? '',
                  style: FontPalette.black16Medium,
                ))
              ],
            ),
          ),
        );
        /*    return Column(
          children: [
            20.verticalSpace,
            CustomExpandedWidget(
              backgroundColor: Colors.white,
              child: Row(
                children: [
                  CommonFadeInImage(
                    image: availablePaymentModes?.imageUrl ?? '',
                    height: 30.h,
                    width: 30.w,
                  ),
                  5.horizontalSpace,
                  Expanded(
                      child: Text(
                    availablePaymentModes?.title ?? '',
                    style: FontPalette.black16Regular,
                  ))
                ],
              ),
              expandedWidget: PaymentNowChildView(
                paymentMethods: availablePaymentModes?.paymentMethods,
              ) */ /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      availablePaymentModes?.paymentMethods?.length ?? 0,
                      (index) => PaymentNowChildView(
                          paymentMethods: availablePaymentModes?.paymentMethods[index],)) */ /* */ /*[
                  ((availablePaymentMethods.code ?? '').toLowerCase() !=
                          PaymentProvider.payNowKey)
                      ? 20.verticalSpace
                      : CustomSlidingFadeAnimation(
                          slideDuration: const Duration(milliseconds: 200),
                          fadeDuration: const Duration(milliseconds: 200),
                          child: PaymentNowChildView(
                              paymentProvider: paymentProvider),
                        ),
                  ((paymentProvider.availablePaymentModes[index].code ?? '')
                              .toLowerCase() !=
                          PaymentProvider.cod)
                      ? const SizedBox.shrink()
                      : CustomSlidingFadeAnimation(
                          slideDuration: const Duration(milliseconds: 200),
                          fadeDuration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 20.h, left: 20.w, top: 5.h),
                            child: PaymentSelectTile(
                              paymentIcon:
                                  availablePaymentMethods.mobileImageUrl ?? '',
                              paymentTitle: Constants.cashOnDelivery,
                              index: index,
                              isSelected:
                                  paymentProvider.selectedPaymentMethod ==
                                      (availablePaymentMethods.code ?? ''),
                              onTap: () =>
                                  paymentProvider.updateSelectedPaymentMethod(
                                      availablePaymentMethods.code ?? ''),
                            ),
                          ),
                        )
                ],*/ /* */ /*
                  )*/ /*
              ,
            ),
            */ /*PaymentSelectTile(
              paymentIcon: availablePaymentMethods.mobileImageUrl ?? '',
              paymentTitle: availablePaymentMethods.title,
              index: index,
              isSelected: paymentProvider.selectedPaymentMode ==
                  (availablePaymentMethods.code ?? ''),
              onTap: () => paymentProvider
                ..updateSelectedPaymentMode(availablePaymentMethods.code ?? '')
                ..setChildAsSelected(availablePaymentMethods.code ?? ''),
            ),
            ((availablePaymentMethods.code ?? '').toLowerCase() !=
                        PaymentProvider.payNowKey ||
                    paymentProvider.selectedPaymentMode.toLowerCase() !=
                        PaymentProvider.payNowKey)
                ? 20.verticalSpace
                : CustomSlidingFadeAnimation(
                    slideDuration: const Duration(milliseconds: 200),
                    fadeDuration: const Duration(milliseconds: 200),
                    child:
                        PaymentNowChildView(paymentProvider: paymentProvider),
                  ),
            ((paymentProvider.availablePaymentModes[index].code ?? '')
                            .toLowerCase() !=
                        PaymentProvider.cod ||
                    paymentProvider.selectedPaymentMode.toLowerCase() !=
                        PaymentProvider.cod)
                ? const SizedBox.shrink()
                : CustomSlidingFadeAnimation(
                    slideDuration: const Duration(milliseconds: 200),
                    fadeDuration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding:
                          EdgeInsets.only(bottom: 20.h, left: 20.w, top: 5.h),
                      child: PaymentSelectTile(
                        paymentIcon:
                            availablePaymentMethods.mobileImageUrl ?? '',
                        paymentTitle: Constants.cashOnDelivery,
                        index: index,
                        isSelected: paymentProvider.selectedPaymentMethod ==
                            (availablePaymentMethods.code ?? ''),
                        onTap: () =>
                            paymentProvider.updateSelectedPaymentMethod(
                                availablePaymentMethods.code ?? ''),
                      ),
                    ),
                  )*/ /*
          ],
        );*/
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Divider(
            color: HexColor('#E6E6E6'),
            thickness: 1.h,
            height: 1.h,
          ),
        );
      },
    );
  }
}
