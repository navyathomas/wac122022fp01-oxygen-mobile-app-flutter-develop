import 'package:oxygen/providers/select_address_provider.dart';

class PaymentArguments {
  final SelectAddressProvider selectAddressProvider;
  final bool navFromBajaj;

  PaymentArguments(
      {required this.selectAddressProvider, this.navFromBajaj = false});
}
