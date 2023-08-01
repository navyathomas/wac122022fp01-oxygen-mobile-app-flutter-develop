import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/availabl_regions_model.dart';
import 'package:oxygen/models/customer_address_model.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';

class AddressProvider extends ChangeNotifier with ProviderHelperClass {
  ///validation values
  bool firstNameIsEmpty = true;
  bool lastNameIsEmpty = true;
  bool mobileNumberIsEmpty = true;
  bool pincodeIsEmpty = true;
  bool localityOrTownIsEmpty = true;
  bool addressIsEmpty = true;
  bool districtIsEmpty = true;

  int selectedAddressTypeId = 0;
  String? customerEmailAddress;
  bool openOnSaturday = true;
  bool openOnSunday = true;
  bool makeThisMyDefaultAddress = true;
  bool districtDropdownHasError = false;
  bool stateDropdownHasError = false;
  int selectedAddressIndex = 0;
  String? selectedDistrict;
  Region? selectedState;
  final availableRegions = <AvailableRegions>[];
  final availableDistricts = <String>[];
  final availableStates = <Region>[];
  final addressTypes = <AddressTypes>[
    AddressTypes(id: 0, type: Constants.home, isSelected: true),
    AddressTypes(id: 1, type: Constants.work)
  ];
  List<Addresses>? addressList;

  /// GET ALL AVAILABLE REGIONS AND DISTRICTS
  Future<void> getAvailableRegionsList(BuildContext context) async {
    try {
      var resp = await serviceConfig.getRegionsList();
      log(resp['country'].toString());
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        availableRegions.clear();
        if (resp['country'] != null) {
          AvailablRegionsModel model =
              AvailablRegionsModel.fromJson(resp['country']);
          if (model.availableRegions != null) {
            availableRegions.addAll(model.availableRegions!);
          }
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// ADD CUSTOMER ADDRESS
  Future<bool?> saveAddress(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String contactNumber,
    required String pincode,
    required String localityOrTown,
    required String street,
  }) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.addCustomerAddress(
          firstName: firstName,
          lastName: lastName,
          contactNumber: contactNumber,
          address: street,
          locality: localityOrTown,
          pincode: pincode,
          city: selectedDistrict!,
          addressType: selectedAddressTypeId.toString(),
          defaultAddress: makeThisMyDefaultAddress,
          openSaturday: openOnSaturday,
          openSunday: openOnSunday,
          region: selectedState!.toJson());
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp['createCustomerAddress'] != null) {
          CommonFunctions.afterInit(() async {
            Helpers.flushToast(context,
                msg: Constants.addressSavedSuccessfully);
            await getCustomerAddressList(context);
          });
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    return null;
  }

  /// UPDATE SINGLE ADDRESS
  Future<bool?> updateAddress(
    BuildContext context,
    int id, {
    required String firstName,
    required String lastName,
    required String contactNumber,
    required String pincode,
    required String localityOrTown,
    required String street,
  }) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.updateCustomerAddress(id,
          firstName: firstName,
          lastName: lastName,
          contactNumber: contactNumber,
          address: street,
          pincode: pincode,
          city: selectedDistrict!,
          addressType: selectedAddressTypeId.toString(),
          locality: localityOrTown,
          defaultAddress: makeThisMyDefaultAddress,
          openSaturday: openOnSaturday,
          openSunday: openOnSunday,
          region: selectedState!.toJson());
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp['updateCustomerAddress'] != null) {
          CommonFunctions.afterInit(() async {
            Helpers.flushToast(context,
                msg: Constants.addressUpdatedSuccessFully);
            await getCustomerAddressList(context);
          });
          updateLoadState(LoaderState.loaded);
          return true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    return null;
  }

  /// GET SAVED CUSTOMER ADDRESS LIST
  Future<void> getCustomerAddressList(BuildContext context,
      {bool tryAgain = false}) async {
    if (!tryAgain) {
      updateLoadState(LoaderState.loading);
    } else {
      updateBtnLoaderState(true);
    }
    try {
      var resp = await serviceConfig.getCustomerAddresses();
      log(resp.toString());
      customerEmailAddress = await HiveServices.instance
          .getUserData()
          .then((value) => value?.email);
      if (resp != null && resp is ApiExceptions) {
        updateLoadState(LoaderState.networkErr);
        updateBtnLoaderState(false);
      } else {
        if (resp['customer']['addresses'] != null) {
          log('${resp['customer']['addresses'].runtimeType}');
          addressList = [];
          var data = CustomerAddressModel.fromJson(resp['customer']);
          addressList?.addAll(data.addresses as List<Addresses>);
          updateLoadState(LoaderState.loaded);
          updateBtnLoaderState(false);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          updateLoadState(LoaderState.error);
          updateBtnLoaderState(false);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
      updateBtnLoaderState(false);
    }
  }

  /// UPDATE DEFAULT SHIPPING-BILLING ADDRESS
  Future<void> updateDefaultAddress(BuildContext context, int id) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.updateCustomerDefaultAddress(id: id);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp['updateCustomerAddress'] != null) {
          CommonFunctions.afterInit(
              () async => await getCustomerAddressList(context).then((_) {
                    CommonFunctions.afterInit(() => Helpers.flushToast(context,
                        msg: Constants.defaultAddressChanged));
                    updateLoadState(LoaderState.loaded);
                  }));
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
          updateLoadState(LoaderState.error);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
  }

  /// REMOVE CUSTOMER ADDRESS BY ID
  Future<void> removeCustomerAddress(
      BuildContext context, int addressId) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp =
          await serviceConfig.removeCustomerAddress(addressId: addressId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.error);
      } else {
        if (resp['deleteCustomerAddress'] != null) {
          CommonFunctions.afterInit(() async {
            getCustomerAddressList(context);
          });
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            updateLoadState(LoaderState.loaded);
            CommonFunctions.afterInit(
                () => Helpers.flushToast(context, msg: errorModel.message!));
          }
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
  }

  /// UPDATE STATE DISTRICT LIST
  void setStatesAndDistricts(BuildContext context) async {
    await getAvailableRegionsList(context).then(
      (_) {
        availableStates.clear();
        availableDistricts.clear();
        for (int i = 0; i < availableRegions.length; i++) {
          var stateName = availableRegions[i].name;
          var stateCode = availableRegions[i].code;
          var regionId = availableRegions[i].id;
          Region region = Region(
              region: stateName, regionCode: stateCode, regionId: regionId);
          availableStates.add(region);
          if (availableRegions[i].availableDistricts != null) {
            for (int j = 0;
                j < availableRegions[i].availableDistricts!.length;
                j++) {
              var district = availableRegions[i].availableDistricts![j].name;
              availableDistricts.add(district ?? '');
            }
          }
        }
        log('available state length : ${availableStates.length}');
        if (availableStates.length == 1) selectedState = availableStates[0];
      },
    );
    notifyListeners();
  }

  /// SELECT ADDRESS TYPE FROM ADD ADDRESS SCREEN
  void updateAddressType(int id) {
    for (var element in addressTypes) {
      if (element.id == id) {
        selectedAddressTypeId = id;
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }

    notifyListeners();
  }

  /// CHANGE WORKDAYS AVAILABILITY
  void updateWeekendAddressStatusAndDefaultAddress(int type) {
    // 0 for open on saturday
    // 1 for open on sunday
    // 2 for make this my default address
    switch (type) {
      case 0:
        openOnSaturday = !openOnSaturday;
        break;
      case 1:
        openOnSunday = !openOnSunday;
        break;
      case 2:
        makeThisMyDefaultAddress = !makeThisMyDefaultAddress;
        break;
    }
    notifyListeners();
  }

  /// VALIDATE DISTRICT DROPDOWN/VALUE IS SELECTED
  bool checkDistrictDropdown() {
    if (selectedDistrict != null) {
      districtDropdownHasError = false;
      notifyListeners();
      return true;
    } else {
      districtDropdownHasError = true;
      notifyListeners();
      return false;
    }
  }

  /// VALIDATE STATE DROPDOWN/VALUE IS SELECTED
  bool checkStateDropdown() {
    if (selectedState != null) {
      stateDropdownHasError = false;
      notifyListeners();
      return true;
    } else {
      stateDropdownHasError = true;
      notifyListeners();
      return false;
    }
  }

  String setAddressFromList(List<String>? list) {
    String address = '';
    if (list != null) {
      address = list.join(' ');
    }
    return address;
  }

  /// PARSE AND SET WORKDAYS CHECK BOX VALUES
  void setWorkAddressOpenStatus(String? mapString) {
    if (mapString != null) {
      mapString = removeJsonAndArray(mapString);
      var dataSp = mapString.split(',');
      Map<String, String> mapData = {};
      for (var element in dataSp) {
        mapData[element.split(':')[0].trim()] = element.split(':')[1].trim();
      }
      if (mapData['open_on_saturdays'] != null) {
        openOnSaturday = mapData['open_on_saturdays']!.parseBool();
      }
      if (mapData['open_on_sundays'] != null) {
        openOnSunday = mapData['open_on_sundays']!.parseBool();
      }
    }
  }

  void updateFieldValidationValues(int fieldId, String value) {
    switch (fieldId) {
      case 1:
        if (value.isNotEmpty) {
          firstNameIsEmpty = false;
        } else {
          firstNameIsEmpty = true;
        }
        break;
      case 2:
        if (value.isNotEmpty) {
          lastNameIsEmpty = false;
        } else {
          lastNameIsEmpty = true;
        }
        break;
      case 3:
        if (value.isNotEmpty) {
          mobileNumberIsEmpty = false;
        } else {
          mobileNumberIsEmpty = true;
        }
        break;
      case 4:
        if (value.isNotEmpty) {
          pincodeIsEmpty = false;
        } else {
          pincodeIsEmpty = true;
        }
        break;

      case 5:
        if (value.isNotEmpty) {
          localityOrTownIsEmpty = false;
        } else {
          localityOrTownIsEmpty = true;
        }
        break;

      case 6:
        if (value.isNotEmpty) {
          addressIsEmpty = false;
        } else {
          addressIsEmpty = true;
        }
        break;
      case 7:
        if (value.isNotEmpty) {
          districtIsEmpty = false;
        } else {
          districtIsEmpty = true;
        }
        break;
    }
    notifyListeners();
  }

  String removeJsonAndArray(String text) {
    if (text.startsWith('{')) {
      text = text.substring(1, text.length - 1);
      if (text.startsWith('{')) {
        text = removeJsonAndArray(text);
      }
    }
    return text;
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void updateBtnLoaderState(bool val) {
    btnLoaderState = val;
    notifyListeners();
    super.updateBtnLoaderState(val);
  }

  @override
  void pageDispose() {
    selectedDistrict = null;
    selectedState = null;
    selectedAddressTypeId = 0;
    addressTypes[0].isSelected = true;
    addressTypes[1].isSelected = false;
    stateDropdownHasError = false;
    districtDropdownHasError = false;
    firstNameIsEmpty = true;
    lastNameIsEmpty = true;
    mobileNumberIsEmpty = true;
    pincodeIsEmpty = true;
    localityOrTownIsEmpty = true;
    addressIsEmpty = true;
    districtIsEmpty = true;
    notifyListeners();
    super.pageDispose();
  }
}

class AddressTypes {
  final int id;
  final String type;
  bool? isSelected;

  AddressTypes({
    required this.id,
    required this.type,
    this.isSelected = false,
  });
}
