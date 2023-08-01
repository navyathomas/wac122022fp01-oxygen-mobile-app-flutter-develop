import 'package:oxygen/providers/payment_provider.dart';

class OrderCompleteArguments {
  final PaymentProvider paymentProvider;

  OrderCompleteArguments({required this.paymentProvider});
}
