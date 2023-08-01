import 'package:oxygen/common/extensions.dart';

import '../common/constants.dart';
import '../models/compare_products_response_model.dart';
import '../models/error_model.dart';
import '../models/product_detail_model.dart';
import '../services/helpers.dart';
import '../services/hive_services.dart';
import '../services/service_config.dart';

class CompareRepo {
  static final ServiceConfig _serviceConfig = ServiceConfig();
  static String errorMessage = '';

  static Future<CompareProductsData?> getCompareProducts() async {
    try {
      var resp = await _serviceConfig.getCompareProductsDetails();
      updateCompareProductList(CompareProductsData.fromJson(resp));
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        return null;
      } else {
        if (resp['getCompareProducts'] != null) {
          return CompareProductsData.fromJson(resp);
        } else {
          return null;
        }
      }
    } catch (e) {
      'Get compare products $e'.log(name: 'Compare Repo');
      return null;
    }
  }

  static Future<bool> addProductToCompare(Item? item,
      {Function? onSuccess, Function? onFailure}) async {
    bool flag = false;
    try {
      var resp =
          await _serviceConfig.addProductToCompare(item?.id.toString() ?? '');
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['addProductToCompare'] == true) {
          await HiveServices.instance.addProductsToCompareLocal(
            productId: item?.id.toString(),
            name: item?.name ?? '',
            imageUrl: item?.smallImage?.url ?? '',
            productTypeSet: item?.productTypeSet,
          );
          if (onSuccess != null) onSuccess();
          flag = true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message.notEmpty) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
        }
      }
    } catch (e) {
      flag = false;
      'Search product $e'.log(name: 'ProductListingProvider');
    }
    return flag;
  }

  static Future<bool> removeProductFromCompare(String? id,
      {Function? onSuccess, Function? onFailure}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.removeProductFromCompare(id.toString());
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['removeProductFromComapre'] == true) {
          if (onSuccess != null) onSuccess();
          await HiveServices.instance.removeFromCompareListLocal(id.toString());
          flag = true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message.notEmpty) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
        }
      }
    } catch (e) {
      'Search product $e'.log(name: 'ProductListingProvider');
      flag = false;
    }
    return flag;
  }

  static Future<bool> removeAllProductsFromCompare(
      {Function? onSuccess, Function? onFailure}) async {
    bool flag = false;
    try {
      var resp = await _serviceConfig.removeAllProductsFromCompare();
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
      } else {
        if (resp['removeallProductFromComapre'] == true) {
          if (onSuccess != null) onSuccess();
          await HiveServices.instance.clearCompareProducts();
          flag = true;
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(resp);
          if (errorModel.message != null) {
            errorMessage = errorModel.message ?? '';
            if (onFailure != null) onFailure();
          }
        }
      }
    } catch (e) {
      flag = false;
      'Search product $e'.log(name: 'ProductListingProvider');
    }
    return flag;
  }

  static updateCompareProductList(CompareProductsData? compareProducts) async {
    await HiveServices.instance.clearCompareProducts();

    if (compareProducts != null) {
      int length = compareProducts.getCompareProducts?.length ?? 0;
      for (int i = 0; i < length; i++) {
        if (i > 2) break;
        await HiveServices.instance.addProductsToCompareLocal(
            productId:
                compareProducts.getCompareProducts?[i].productId.toString(),
            name: compareProducts.getCompareProducts?[i].productName ?? '',
            imageUrl: compareProducts.getCompareProducts?[i].image ?? '',
            productTypeSet: compareProducts
                    .getCompareProducts?[i].productInterface?.productTypeSet ??
                0,
            index: i);
      }
    }
  }
}
