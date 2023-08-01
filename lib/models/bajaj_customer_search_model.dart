import 'package:oxygen/models/bajaj_emi_details_model.dart';

class CustomerBillingSearch {
  CustomerBillingSearch({
    this.city,
    this.intercity,
    this.items,
  });

  String? city;
  bool? intercity;
  BajajEmiDetails? items;

  factory CustomerBillingSearch.fromJson(Map<String, dynamic> json) =>
      CustomerBillingSearch(
        city: json["city"],
        intercity: json["intercity"],
        items: json["items"] == null
            ? null
            : BajajEmiDetails.fromJson(json["items"]),
      );
}
