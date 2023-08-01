import 'package:flutter/material.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/models/bank_offers_model.dart';
import 'package:oxygen/models/emi_plans_model.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/repositories/product_detail_repo.dart';
import 'package:oxygen/services/firebase_analytics_services.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/services/hive_services.dart';
import 'package:oxygen/services/provider_helper_class.dart';
import 'package:oxygen/services/service_config.dart';
import 'package:pod_player/pod_player.dart';

class ProductDetailProvider extends ChangeNotifier with ProviderHelperClass {
  bool _disposed = false;

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    podPlayerController?.dispose();
    scrollController.dispose();
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  /* *** Product Details *** */
  ProductDetailData? initialData;
  Item? selectedItem;
  Reviews? reviews;
  EmiPlansData? emiPlans;
  BajajEmiDetails? bajajEmiDetails;

  List<Variant?>? variants;
  List<ConfigurableOption?>? configurableOption;
  List<Item?>? crossSellProducts;
  List<Item?>? upSellProducts;
  List<Item?>? relatedProducts;

  bool variantNotAvailable = false;
  PodPlayerController? podPlayerController;

  String? parentSku;
  String? productType;

  Map<String, dynamic> selectedProduct = {};
  Map<String, dynamic> userSelected = {};
  List<int?> listToHide = [];

  final ScrollController scrollController = ScrollController();

  void initialiseVideo(String url) {
    podPlayerController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(url),
        podPlayerConfig: const PodPlayerConfig(autoPlay: false));
    podPlayerController?.initialise();
  }

  void addToUserSelectedMap({String? key, dynamic value}) {
    listToHide.clear();
    if (userSelected.containsKey(key ?? "")) {
      userSelected.update(key ?? "", (_) => value ?? "");
    } else {
      userSelected.addAll({key ?? "": value ?? ""});
    }

    userSelected.forEach((key, value) {
      configurableOption?.forEach((first) {
        first?.values?.forEach((second) {
          if (second?.nonExistentAttributes?.contains(value) ?? false) {
            listToHide.add(second?.valueIndex);
          }
        });
      });
    });
  }

  void addToSelectedProduct(
      {String? key, dynamic value, bool fromButton = false}) {
    if (selectedProduct.containsKey(key ?? "")) {
      selectedProduct.update(key ?? "", (_) => value ?? "");
    } else {
      selectedProduct.addAll({key ?? "": value ?? ""});
    }

    int allCases = 0;

    if (variants != null) {
      for (var first in variants!) {
        if (first?.attributes?.length == selectedProduct.length) {
          if (first?.attributes != null) {
            for (var second in first!.attributes!) {
              selectedProduct.forEach((key, value) {
                if (second?.code == key && second?.valueIndex == value) {
                  allCases = allCases + 1;
                }
              });
            }
          }
          if (allCases < selectedProduct.length) {
            allCases = 0;
            variantNotAvailable = true;
          } else if (allCases == selectedProduct.length) {
            variantNotAvailable = false;
            selectedItem = first?.product;
            notifyListeners();
            return;
          }
        }
      }
    }
    notifyListeners();
  }

  /* *** Product Details *** */

  /* *** Bank Offers *** */
  BankOffersData? initialBankOffersData;
  GetBankOffersByProductSku? getBankOffersByProductSku;
  String? bankOfferContent;

  /* *** Bank Offers *** */

  /* *** Pin Code *** */
  String? pinCode;
  String? pinCodeMessage;
  bool? pinCodeStatus;
  bool pinCodeLoading = false;

  getPinCode() async {
    final map = await HiveServices.instance.getPinCode();
    pinCode = map?["code"];
    pinCodeMessage = map?["message"];
    pinCodeStatus = map?["status"];
    notifyListeners();
  }

  clearPinCode() async {
    await HiveServices.instance.clearPinCode();
    pinCode = null;
    pinCodeStatus = null;
    pinCodeMessage = null;
    notifyListeners();
  }

  /* *** Pin Code *** */

  /* *** Add To Cart *** */
  List<String> frequentlyList = [];

  void addToFrequentlyList({String? sku}) {
    if (frequentlyList.contains(sku)) {
      frequentlyList.remove(sku);
    } else {
      frequentlyList.add(sku ?? "");
    }
    notifyListeners();
  }

  /* *** Add To Cart *** */

  Future<void> checkPinCode(
      BuildContext context, String controllerPinCode, int productId) async {
    try {
      pinCodeLoading = true;
      notifyListeners();
      var resp = await serviceConfig.checkPinCode(
          productId: productId, pinCode: controllerPinCode);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        pinCodeLoading = false;
        notifyListeners();
      } else {
        if (resp["checkPincode"] != null) {
          await HiveServices.instance.savePinCode(
              pinCode: controllerPinCode,
              message: resp["checkPincode"]["message"],
              status: resp["checkPincode"]["status"]);
          pinCode = controllerPinCode;
          pinCodeMessage = resp["checkPincode"]["message"];
          pinCodeStatus = resp["checkPincode"]["status"];
          FocusManager.instance.primaryFocus?.unfocus();
        }
        pinCodeLoading = false;
        notifyListeners();
      }
    } catch (e) {
      pinCodeLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductDetails(BuildContext context, String sku) async {
    updateLoadState(LoaderState.loading);
    try {
      var resp = await serviceConfig.getProductDetails(sku: sku);
      if (resp != null && resp is ApiExceptions) {
        Helpers.successToast(Constants.noInternet);
        updateLoadState(LoaderState.networkErr);
      } else {
        if (resp != null && resp['products'] != null) {
          initialData = ProductDetailData.fromJson(resp);

          final item = initialData?.products?.items?.elementAt(0);
          productType = item?.productType;
          parentSku = item?.sku;
          ProductDetailRepo.addToRecentlyViewed(productId: item?.id);
          if (item != null) {
            final configurableOptions =
                initialData?.products?.items?.elementAt(0)?.configurableOptions;
            if (configurableOptions == null &&
                (configurableOptions?.isEmpty ?? true) &&
                (item.productType?.trim().toLowerCase() ==
                    Constants.simpleProduct)) {
              selectedItem = item;
              crossSellProducts = item.crossSellProducts;
              upSellProducts = item.upSellProducts;
              relatedProducts = item.relatedProducts;
              reviews = item.reviews;
            } else {
              configurableOption = configurableOptions;
              variants = item.variants;
              crossSellProducts = item.crossSellProducts;
              upSellProducts = item.upSellProducts;
              relatedProducts = item.relatedProducts;
              reviews = item.reviews;

              final selectedVariants = initialData?.products?.items
                  ?.elementAt(0)
                  ?.selectedVariantOptions;
              if (selectedVariants != null && selectedVariants.isNotEmpty) {
                for (var element in selectedVariants) {
                  addToSelectedProduct(
                      key: element?.code, value: element?.valueIndex);
                  addToUserSelectedMap(
                      key: element?.code, value: element?.valueIndex);
                }
              } else {
                if (variants?.first?.attributes != null &&
                    (variants?.first?.attributes?.isNotEmpty ?? false)) {
                  variants?.first?.attributes?.forEach((element) {
                    addToSelectedProduct(
                        key: element?.code, value: element?.valueIndex);
                    addToUserSelectedMap(
                        key: element?.code, value: element?.valueIndex);
                  });
                }
              }
            }
            updateLoadState(LoaderState.loaded);
          } else {
            updateLoadState(LoaderState.noData);
          }
          MaximumPrice? maxPrice = item?.priceRange?.maximumPrice;
          FirebaseAnalyticsService.instance.logProductOpen(
              price: maxPrice?.finalPrice?.value,
              discount: maxPrice?.discount?.amountOff,
              itemId: item?.sku,
              name: item?.name,
              qty: 1);
        } else {
          updateLoadState(LoaderState.noData);
        }
      }
    } catch (e) {
      updateLoadState(LoaderState.error);
    }
  }

  Future<void> getBankOffers(BuildContext context, String sku) async {
    try {
      var resp = await serviceConfig.getBankOffers(sku: sku);
      if (resp != null && resp['getBankOffersByProductSku'] != null) {
        initialBankOffersData = BankOffersData.fromJson(resp);
        getBankOffersByProductSku =
            initialBankOffersData?.getBankOffersByProductSku?.first;
        notifyListeners();
      }
    } catch (e) {
      //Handle Exception If Needed
    }
  }

  Future<void> getEmiPlans({String? sku}) async {
    try {
      var resp = await serviceConfig.getEmiPlans(sku: sku ?? "");
      if (resp != null && resp['getBankEmiByProductSku'] != null) {
        emiPlans = EmiPlansData.fromJson(resp['getBankEmiByProductSku']);
        notifyListeners();
      }
    } catch (e) {
      //Handle Exception If Needed
    }
  }

  Future<void> getBajajEmiDetails({String? sku}) async {
    try {
      var resp = await serviceConfig.getBajajEmiDetails(sku: sku ?? "");
      if (resp != null && resp['getBajajEMIDetails'] != null) {
        bajajEmiDetails = BajajEmiDetails.fromJson(resp['getBajajEMIDetails']);
        notifyListeners();
      }
    } catch (e) {
      //Handle Exception If Needed
    }
  }
}
