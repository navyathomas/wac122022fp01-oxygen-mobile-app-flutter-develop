import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/auth_data_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/service_config.dart';

class LeaveFeedbackRepo {
  ServiceConfig serviceConfig = ServiceConfig();
  AuthCustomer? customerData;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  ValueNotifier<double> ratingValue = ValueNotifier<double>(5.0);
  ValueNotifier<String?> feedback = ValueNotifier<String?>(null);

  Future<bool?> postFeedback(String feedback) async {
    isLoading.value = true;
    try {
      customerData = await HiveServices.instance.getUserData();
      if (customerData != null) {
        String name = '${customerData?.firstname} ${customerData?.lastname}';
        String mobile = customerData?.mobileNumber ?? '';
        int rating = ratingValue.value.toInt();
        String email = customerData?.email ?? '';
        var resp = await serviceConfig.postCustomerFeedback(
            name: name,
            mobile: mobile,
            rating: rating,
            email: email,
            feedback: feedback);
        if (resp != null && resp is ApiExceptions) {
          isLoading.value = false;
          CommonFunctions.checkException(resp);
        } else {
          if (resp['submitContactForm'] != null &&
              resp['submitContactForm'] == true) {
            CommonFunctions.afterInit(() {
              Helpers.successToast(Constants.feedbackSubmitedMsg);
            });
            isLoading.value = false;
            return true;
          } else {
            isLoading.value = false;
            CommonFunctions.checkException(resp);
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
    }
    return null;
  }
}
