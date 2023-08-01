import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/error_model.dart';
import 'package:oxygen/models/service_request_body_model.dart';
import 'package:oxygen/models/service_request_demo_response_model.dart';
import 'package:oxygen/models/service_request_response.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oxygen/services/service_config.dart';

class ServiceRequestProvider extends ChangeNotifier with ProviderHelperClass {
  List<ServiceRequestValueData> districtList = [];
  List<ServiceRequestValueData> categoryTypeList = [];
  List<ServiceRequestValueData> storeList = [];
  List<List<int>> imageFilesList = [];
  List<ServiceRequestValueData> brandList = [];
  List<ServiceRequestValueData> serviceRequestTypeList = [];
  List<ServiceRequestValueData> productFromList = [];
  List<ServiceRequestValueData> warrantStatusList = [];

  TextEditingController modelController = TextEditingController();
  TextEditingController issueTitleController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController issueDescriptionController = TextEditingController();

  bool isBringToBranchSelected = false;
  bool isFromOxygen = true;
  bool isServiceRequestFormValidated = false;
  bool isDemoRequest = false;
  bool _disposed = false;

  String errorMessage = '';
  String? categoryType;
  String? categoryTypeLabel;
  String? brand;
  String? brandLabel;
  String? district;
  String? districtLabel;
  String? store;
  String? storeLabel;
  String? modelErrorMessage;
  String? serialNumberErrorMessage;
  String? issueDescriptionErrorMessage;
  String? pickUpAddressErrorMessage;
  String? serviceRequestType;
  String? productFrom;
  String? warrantyStatus;

  ServiceRequestData? serviceRequestResponse;
  ServiceRequestDemoData? serviceRequestDemoResponse;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> getServiceRequestData(
      {Function? onSuccess, Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getServiceRequestData();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null) {
          serviceRequestResponse = ServiceRequestData.fromJson(resp);
          updateValueList(serviceRequestResponse?.getServiceRequestData);
          updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  Future<void> getServiceRequestDemoData(String orderId, String itemId,
      {Function? onSuccess, Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getServiceRequestDemoData(orderId, itemId);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null) {
          serviceRequestDemoResponse = ServiceRequestDemoData.fromJson(resp);
          updateDemoValueList(
              serviceRequestDemoResponse?.getServiceRequestDataWeb?.formData ??
                  []);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  Future<void> sendRequest({Function? onSuccess, Function? onFailure}) async {
    updateLoadState(LoaderState.loading);
    List<String> base64ImageList = [];
    for (var element in imageFilesList) {
      base64ImageList.add(base64Encode(element));
    }
    String tempDistrict = district ?? '';
    String tempStore = store ?? '';
    ServiceRequestBody serviceRequestBody = ServiceRequestBody(
        title: issueTitleController.text.trim(),
        addPhotoList: base64ImageList,
        brand: brand,
        categoryType: categoryType,
        issueDescription: issueDescriptionController.text.trim(),
        model: modelController.text.trim(),
        productFrom: productFrom,
        selectDistrict: tempDistrict,
        serviceRequestType: serviceRequestType,
        store: tempStore,
        pickupAddress: pickUpAddressController.text.trim(),
        serialNumber: serialNumberController.text.trim(),
        warranty: warrantyStatus);

    try {
      var resp = await serviceConfig.createServiceRequest(serviceRequestBody);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null) {
          if (onSuccess != null) onSuccess();
          // updateLoadState(LoaderState.loaded);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
          updateLoadState(LoaderState.loaded);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
    notifyListeners();
  }

  //image picker function to get images from gallery
  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    if (pickedFile.notEmpty) {
      for (int i = 0; i < pickedFile.length; i++) {
        imageFilesList = [
          ...imageFilesList,
          File(pickedFile[i].path).readAsBytesSync()
        ];
      }
    }
    updateIsServiceRequestFormValidated();
    notifyListeners();
  }

  //image picker function to get images from camera
  Future getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFilesList = [
        ...imageFilesList,
        File(pickedFile.path).readAsBytesSync()
      ];
    }
    updateIsServiceRequestFormValidated();
    notifyListeners();
  }

  removeImageFromList(int index) {
    for (int i = 0; i < imageFilesList.length; i++) {
      List<List<int>> tempImageFiles = List.from(imageFilesList);
      tempImageFiles.removeAt(index);
      imageFilesList = tempImageFiles;
      break;
    }
    updateIsServiceRequestFormValidated();
    notifyListeners();
  }

  updateValueList(List<GetServiceRequestData>? getServiceRequestDataList) {
    for (int i = 0; i < (getServiceRequestDataList ?? []).length; i++) {
      switch (getServiceRequestDataList?[i].label) {
        case 'CategoryType':
          categoryTypeList = getServiceRequestDataList?[i].data ?? [];
          break;
        case 'Brand':
          brandList = getServiceRequestDataList?[i].data ?? [];
          break;
        case 'SelectDistrict':
          districtList = getServiceRequestDataList?[i].data ?? [];
          break;
        case 'Store':
          storeList = getServiceRequestDataList?[i].data ?? [];
          break;
        case 'ServiceRequestType':
          serviceRequestTypeList = getServiceRequestDataList?[i].data ?? [];
          updateServiceRequest(serviceRequestTypeList[0].value ?? '');
          break;
        case 'ProductFrom':
          productFromList = getServiceRequestDataList?[i].data ?? [];
          updateProductFrom(productFromList[0].value ?? '');
          break;
        case 'Under warrenty':
          warrantStatusList = getServiceRequestDataList?[i].data ?? [];
          updateWarrantyStatus(warrantStatusList[0].value ?? '');
          break;
      }
    }
    notifyListeners();
  }

  updateDemoValueList(
      List<ServiceRequestDemoValue>? getServiceRequestDataList) {
    for (int i = 0; i < (getServiceRequestDataList ?? []).length; i++) {
      switch (getServiceRequestDataList?[i].label) {
        case 'CategoryType':
          categoryTypeList = getServiceRequestDataList?[i].data ?? [];
          for (var element in categoryTypeList) {
            if ((element.isSelected ?? false)) {
              categoryTypeLabel = element.label ?? '';
              getCategoryTypeValueFromLabel(categoryTypeLabel ?? '');
              break;
            }
          }
          break;
        case 'Brand':
          brandList = getServiceRequestDataList?[i].data ?? [];
          for (var element in brandList) {
            if ((element.isSelected ?? false)) {
              brandLabel = element.label ?? '';
              getBrandValueFromLabel(brandLabel ?? '');
              break;
            }
          }
          break;
        case 'SelectDistrict':
          districtList = getServiceRequestDataList?[i].data ?? [];
          for (var element in districtList) {
            if ((element.isSelected ?? false)) {
              districtLabel = element.label ?? '';
              getDistrictValueFromLabel(districtLabel ?? '');
              break;
            }
          }
          break;
        case 'Store':
          storeList = getServiceRequestDataList?[i].data ?? [];
          for (var element in storeList) {
            if ((element.isSelected ?? false)) {
              storeLabel = element.label ?? '';
              getStoreValueFromLabel(storeLabel ?? '');
              break;
            }
          }
          break;
        case 'ServiceRequestType':
          serviceRequestTypeList = getServiceRequestDataList?[i].data ?? [];
          for (int i = 0; i < serviceRequestTypeList.length; i++) {
            if ((serviceRequestTypeList[i].isSelected ?? false)) {
              updateServiceRequest(serviceRequestTypeList[i].value ?? '');
              break;
            } else {
              updateServiceRequest(serviceRequestTypeList[0].value ?? '');
            }
          }
          break;
        case 'ProductFrom':
          productFromList = getServiceRequestDataList?[i].data ?? [];
          for (int i = 0; i < productFromList.length; i++) {
            if ((productFromList[i].isSelected ?? false)) {
              updateProductFrom(productFromList[i].value ?? '');
              break;
            } else {
              updateProductFrom(productFromList[0].value ?? '');
            }
          }
          break;
        case 'Under warrenty':
          warrantStatusList = getServiceRequestDataList?[i].data ?? [];
          for (int i = 0; i < warrantStatusList.length; i++) {
            if ((warrantStatusList[i].isSelected ?? false)) {
              updateWarrantyStatus(warrantStatusList[i].value ?? '');
              break;
            } else {
              updateWarrantyStatus(warrantStatusList[0].value ?? '');
            }
          }
          break;
      }
      modelController.text =
          serviceRequestDemoResponse?.getServiceRequestDataWeb?.productName ??
              "";
      updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

  getCategoryTypeValueFromLabel(String label) {
    for (var element in categoryTypeList) {
      if (element.label == label) {
        categoryType = element.value;
        break;
      }
    }
    notifyListeners();
  }

  getBrandValueFromLabel(String label) {
    for (var element in brandList) {
      if (element.label == label) {
        brand = element.value;
        break;
      }
    }
    notifyListeners();
  }

  getDistrictValueFromLabel(String label) {
    for (var element in districtList) {
      if (element.label == label) {
        district = element.value;
        break;
      }
    }
    notifyListeners();
  }

  getStoreValueFromLabel(String label) {
    for (var element in storeList) {
      if (element.label == label) {
        store = element.value;
        break;
      }
    }
    notifyListeners();
  }

  updateIsBringToBranch(bool value) {
    isBringToBranchSelected = value;
    notifyListeners();
  }

  updateIsFromOxygen(bool value) {
    isFromOxygen = value;
    notifyListeners();
  }

  updateServiceRequest(String value) {
    serviceRequestType = value;
    notifyListeners();
  }

  updateProductFrom(String value) {
    productFrom = value;
    notifyListeners();
  }

  updateWarrantyStatus(String value) {
    warrantyStatus = value;
    notifyListeners();
  }

  updateIsDemoRequest(bool value) {
    isDemoRequest = value;
    notifyListeners();
  }

  updateIsServiceRequestFormValidated() {
    if (!isBringToBranchSelected) {
      if ((categoryType ?? '').isNotEmpty &&
          (brand ?? '').isNotEmpty &&
          modelController.text.trim().isNotEmpty &&
          issueDescriptionController.text.trim().isNotEmpty &&
          imageFilesList.notEmpty &&
          pickUpAddressController.text.trim().isNotEmpty) {
        isServiceRequestFormValidated = true;
      } else {
        isServiceRequestFormValidated = false;
      }
    } else {
      if ((categoryType ?? '').isNotEmpty &&
          (brand ?? '').isNotEmpty &&
          (district ?? '').isNotEmpty &&
          (store ?? '').isNotEmpty &&
          modelController.text.trim().isNotEmpty &&
          issueDescriptionController.text.trim().isNotEmpty &&
          imageFilesList.notEmpty) {
        isServiceRequestFormValidated = true;
      } else {
        isServiceRequestFormValidated = false;
      }
    }
    notifyListeners();
  }

  clearSelectDistrictAndStore() {
    district = null;
    store = null;
    notifyListeners();
  }

  clearValues() {
    district = null;
    store = null;
    categoryType = null;
    brand = null;
    store = null;
    modelController.clear();
    issueDescriptionController.clear();
    imageFilesList.clear();
    pickUpAddressController.clear();
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
