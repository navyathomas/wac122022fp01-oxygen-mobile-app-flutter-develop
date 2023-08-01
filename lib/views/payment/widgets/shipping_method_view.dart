import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/payment_provider.dart';
import 'package:oxygen/providers/select_address_provider.dart';
import 'package:oxygen/views/payment/widgets/shipping_method_select_tile.dart';
import 'package:provider/provider.dart';

class ShippingMethodView extends StatelessWidget {
  const ShippingMethodView(
      {Key? key,
      required this.paymentProvider,
      required this.selectAddressProvider})
      : super(key: key);
  final PaymentProvider paymentProvider;
  final SelectAddressProvider selectAddressProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: selectAddressProvider,
      child: ListView.builder(
        itemCount: selectAddressProvider.availableShippingMethods.notEmpty
            ? selectAddressProvider.availableShippingMethods.length
            : 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ShippingMethodSelectTile(
            selectAddressProvider: selectAddressProvider,
            isSelected: paymentProvider.selectedShippingMethodIndex == index,
            title: selectAddressProvider
                    .availableShippingMethods[index].carrierTitle ??
                '',
            onTap: () => paymentProvider
              ..updateSelectedShippingMethodIndex(index)
              ..updateShippingMethodCode(
                  shippingMethodCode: selectAddressProvider
                          .availableShippingMethods[index].methodCode ??
                      '',
                  shippingCarrierMode: selectAddressProvider
                          .availableShippingMethods[index].carrierCode ??
                      ''),
          );
        },
      ),
    );
  }
}
