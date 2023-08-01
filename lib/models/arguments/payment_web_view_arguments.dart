import '../../providers/payment_provider.dart';

class PaymentWebViewArguments {
  final String? actionUrl;
  final String title;
  final PaymentProvider paymentProvider;

  PaymentWebViewArguments(
      {this.actionUrl, required this.paymentProvider, this.title = ''});
}
