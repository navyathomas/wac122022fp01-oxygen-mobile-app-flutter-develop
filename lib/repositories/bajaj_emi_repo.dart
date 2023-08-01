import 'package:oxygen/common/constants.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/service_config.dart';

class BajajEmiRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();

  static Future<bool> unsetBajajEmiDetails() async {
    bool resFlag = false;
    try {
      var resp = await _serviceConfig.unsetBajajEmiDetails();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        return resFlag;
      } else {
        if (resp != null && resp['unSetBajajEmi'] != null) {
          return true;
        }
      }
    } catch (e) {
      return resFlag;
    }
    return resFlag;
  }
}
