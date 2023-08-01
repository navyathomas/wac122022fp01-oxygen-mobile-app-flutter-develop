import '../../providers/my_orders_provider.dart';
import '../my_orders_model.dart';

class MyOrderDetailsArguments {
  final List<Products>? products;
  final CurrentStatus? currentStatus;
  final Map<String, dynamic>? orderProcess;
  final String? createdAt;
  final String? orderNumber;
  final ShippingAddresses? address;
  final GrandTotal? grandTotal;
  final Gst? gst;
  final SubtotalExcludingTax? excludingTax;
  final SubtotalIncludingTax? includingTax;
  final Discount? discount;
  final String? status;
  final OrderPaymentMethod? paymentMethod;
  final SelectedShippingMethod? shippingFee;
  final MyOrdersProvider myOrdersProvider;
  final String? id;

  MyOrderDetailsArguments(
      {this.products,
      this.currentStatus,
      this.orderProcess,
      this.createdAt,
      this.orderNumber,
      this.address,
      this.excludingTax,
      this.grandTotal,
      this.gst,
      this.includingTax,
      this.discount,
      this.status,
      this.paymentMethod,
      this.shippingFee,
      this.id,
      required this.myOrdersProvider});
}
