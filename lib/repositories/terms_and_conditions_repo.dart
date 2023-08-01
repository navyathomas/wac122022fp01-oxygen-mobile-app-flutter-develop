import 'dart:developer';

import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/models/terms_and_conditions_data_model.dart';
import 'package:oxygen/services/service_config.dart';

class TermsAndConditionsPrivacyPolicyRepo {
  ServiceConfig serviceConfig = ServiceConfig();

  Future<TermsAndConditionsPrivacyPolicyModel?> getTermsAndConditions() async {
    try {
      var resp = await serviceConfig.getTermsAndConditions();
      if (resp != null && resp is ApiExceptions) {
        CommonFunctions.checkException(resp);
      } else {
        if (resp['cmsPage'] != null) {
          var data =
              TermsAndConditionsPrivacyPolicyModel.fromJson(resp['cmsPage']);
          return data;
        } else {
          CommonFunctions.checkException(resp);
        }
      }
    } catch (e) {
      log('$e');
    }
    return null;
  }

  Future<TermsAndConditionsPrivacyPolicyModel?> getPrivacyPolicy() async {
    try {
      var resp = await serviceConfig.getPrivacyPolicies();
      if (resp != null && resp is ApiExceptions) {
        CommonFunctions.checkException(resp);
      } else {
        if (resp['cmsPage'] != null) {
          var data =
              TermsAndConditionsPrivacyPolicyModel.fromJson(resp['cmsPage']);
          return data;
        } else {
          CommonFunctions.checkException(resp);
        }
      }
    } catch (e) {
      log('$e');
    }
    return null;
  }
}
