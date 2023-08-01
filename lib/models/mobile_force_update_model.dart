import 'dart:io';

import 'package:oxygen/common/common_function.dart';

enum UpdateState { showForceUpdate, showUpdate, none }

class MobileForceUpdate {
  int? androidMinVersion;
  int? androidMaxVersion;
  int? iosMinVersion;
  int? iosMaxVersion;

  MobileForceUpdate(
      {this.androidMinVersion,
      this.androidMaxVersion,
      this.iosMinVersion,
      this.iosMaxVersion});

  MobileForceUpdate.fromJson(Map<String, dynamic> json) {
    androidMinVersion = json['android_min_version'];
    androidMaxVersion = json['android_max_version'];
    iosMinVersion = json['ios_min_version'];
    iosMaxVersion = json['ios_max_version'];
  }

  Future<UpdateState> get updateState async {
    int version = await CommonFunctions.getBuildVersion();
    if (Platform.isIOS) {
      if (version < (iosMinVersion ?? 0)) return UpdateState.showForceUpdate;
      if (version < (iosMaxVersion ?? 0)) return UpdateState.showUpdate;
      return UpdateState.none;
    } else {
      if (version < (androidMinVersion ?? 0)) {
        return UpdateState.showForceUpdate;
      }
      if (version < (androidMaxVersion ?? 0)) return UpdateState.showUpdate;
      return UpdateState.none;
    }
  }
}
