import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/payment_modes_model.dart';
import '../../../providers/payment_provider.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_radio_button.dart';

class PaymentNowChildView extends StatelessWidget {
  final PaymentProvider paymentProvider;
  final List<PaymentMethods>? paymentMethods;

  const PaymentNowChildView(
      {Key? key, required this.paymentMethods, required this.paymentProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: paymentMethods?.length ?? 0,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 13.h, top: 5.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        PaymentMethods? availablePaymentMethods = paymentMethods?[index];
        return GestureDetector(
          onTap: () => paymentProvider.updateSelectedPaymentMethod(
              availablePaymentMethods?.paymentCode ?? ''),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                CustomRadioButton(
                  isSelected: paymentProvider.selectedPaymentMethod ==
                      (availablePaymentMethods?.paymentCode ?? ''),
                  onTap: () {
                    paymentProvider.updateSelectedPaymentMethod(
                        availablePaymentMethods?.paymentCode ?? '');
                  },
                ),
                16.horizontalSpace,
                Expanded(
                  child: Text(
                    availablePaymentMethods?.title ?? '',
                    style: FontPalette.black16Regular,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => 10.verticalSpace,
    );
  }
}
