import 'package:flutter/cupertino.dart';

class ServiceRequestArguments {
  final String? orderId;
  final String? itemId;
  final bool? isDemoRequest;

  ServiceRequestArguments({this.orderId, this.itemId, this.isDemoRequest});
}
