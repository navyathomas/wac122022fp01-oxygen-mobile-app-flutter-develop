import 'package:oxygen/models/my_orders_model.dart';

class TrackingDetailsArguments {
  final TrackDeliveryStatus? trackDeliveryStatus;
  final CustomerDeliveryDetails? customerDeliveryDetails;
  TrackingDetailsArguments(
      {this.trackDeliveryStatus, this.customerDeliveryDetails});
}
