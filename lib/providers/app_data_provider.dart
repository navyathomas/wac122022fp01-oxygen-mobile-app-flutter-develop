import 'package:flutter/material.dart';
import 'package:oxygen/models/whatsapp_model.dart';
import 'package:oxygen/repositories/app_data_repo.dart';
import 'package:oxygen/repositories/cart_repo.dart';

import '../models/mobile_force_update_model.dart';

class AppDataProvider extends ChangeNotifier {
  bool enableAppUpdateTile = false;
  WhatsappModel? whatsappModel;

  Future<UpdateState> checkAppUpdate() async {
    UpdateState state = UpdateState.none;
    setEnableAppUpdateTile(false);
    try {
      MobileForceUpdate? model = await CartRepo.getForceUpdateData();
      if (model?.androidMinVersion != null) {
        UpdateState state = await model!.updateState;
        if (state == UpdateState.showForceUpdate) {
          return UpdateState.showForceUpdate;
        }
        if (state == UpdateState.showUpdate) {
          setEnableAppUpdateTile(true);
          return UpdateState.showUpdate;
        }
      }
    } catch (_) {}
    return state;
  }

  void setEnableAppUpdateTile(bool val) {
    enableAppUpdateTile = val;
    notifyListeners();
  }

  Future<void> getWhatsappChatConfiguration() async {
    try {
      whatsappModel = await AppDataRepo.getWhatsappChatConfiguration();
    } catch (_) {}
  }
}
