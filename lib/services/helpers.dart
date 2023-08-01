import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

import '../common/constants.dart';
import '../widgets/cached_image_view.dart';

class Helpers {
  static Future<bool> isInternetAvailable({bool enableToast = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        if (enableToast) successToast(Constants.noInternet);
        return false;
      }
    } on SocketException catch (_) {
      if (enableToast) successToast(Constants.noInternet);
      return false;
    }
  }

  /* static Future<bool> isLocationServiceEnabled() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }*/

  static double validateScale(double valArg) {
    double val = 1.0;
    if (valArg <= 1.0) {
      val = 1.0;
    } else if (valArg >= 1.3) {
      val = valArg - 0.2;
    } else if (valArg >= 1.1) {
      val = valArg - 0.1;
    }
    return val;
  }

  static double convertToDouble(var valArg, {bool check = false}) {
    double val = 0.0;
    if (valArg == null) return val;
    switch (valArg.runtimeType) {
      case int:
        val = valArg.toDouble();
        break;
      case String:
        val = double.tryParse(valArg) ?? val;
        break;

      default:
        val = valArg;
    }
    return val;
  }

  static int convertToInt(var valArg, {int defValue = 0}) {
    int val = defValue;
    if (valArg == null) return val;
    switch (valArg.runtimeType) {
      case double:
        return valArg.toInt();

      case String:


        return int.tryParse(valArg) ?? val;

      default:
        return valArg;
    }
  }

  static void successToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future flushToast(BuildContext context, {required String msg}) {
    return Flushbar(
      message: msg,
      duration: const Duration(seconds: 2),
      titleColor: HexColor('#282C3F').withOpacity(0.95),
      margin: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.h),
    ).show(context);
  }

  static Future flushImageToast(BuildContext context,
      {required String msg, required String image, VoidCallback? onUndo}) {
    if (image.isEmpty) {
      return Flushbar(
        message: msg,
        duration: const Duration(seconds: 2),
        titleColor: HexColor('#282C3F').withOpacity(0.95),
        margin: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.h),
        mainButton: onUndo == null
            ? null
            : InkWell(
                onTap: onUndo,
                child: Container(
                    height: 39.h,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      Constants.undo,
                      style: FontPalette.white16Medium,
                    )),
              ),
      ).show(context);
    }
    return Flushbar(
      message: msg,
      duration: const Duration(seconds: 2),
      maxWidth: double.maxFinite,
      icon: Container(
        padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
        child: CachedImageView(
          image: image,
          height: 39.h,
          width: 36.w,
        ),
      ),
      mainButton: onUndo == null
          ? null
          : Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: onUndo,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    height: 39.h,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      Constants.undo,
                      style: FontPalette.white16Medium,
                    )),
              ),
            ),
      padding: EdgeInsets.only(left: 25.w),
      titleColor: HexColor('#282C3F').withOpacity(0.95),
      margin: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.h),
    ).show(context);
  }

  static capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }

  static String decodeBase64(String? val) {
    String uid = '';
    if (val != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      uid = stringToBase64.decode(val);
    }
    return uid;
  }

  static String encodeBase64(String? valArg) {
    String val = '';
    if (valArg != null) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      val = stringToBase64.encode(valArg);
    }
    return val;
  }

  static String removeBracket(List<String>? input) {
    if (input != null && input.isNotEmpty) {
      return input.toString().replaceAll('[', '').replaceAll(']', '');
    }
    return '';
  }

  static DateTime? convertDateStringToDate(String? string) {
    if (string != null) {
      return DateFormat("yyyy-MM-dd").parse(string);
    } else {
      return null;
    }
  }

  static bool validateNewDates({String? fromDate, String? toDate}) {
    try {
      if (fromDate == null || toDate == null) {
        return false;
      } else {
        final from = convertDateStringToDate(fromDate);
        final to = convertDateStringToDate(toDate);

        final currentDateInString = DateTime.now().toString();
        final currentDate = DateFormat("yyyy-MM-dd").parse(currentDateInString);

        if ((currentDate.difference(from!).inDays >= 0) &&
            (currentDate.difference(to!).inDays <= 0)) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

/*static LocalProducts getLocalProducts(AppDataProvider model, String? sku) {
    if (sku == null) return LocalProducts();
    return model.appProductData.containsKey(sku)
        ? model.appProductData[sku]!
        : LocalProducts();
  }*/
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
