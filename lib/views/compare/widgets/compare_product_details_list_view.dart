import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/compare_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';

class CompareProductDetailsView extends StatelessWidget {
  const CompareProductDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          context.read<CompareProvider>().comparableAttributeList[0].length,
          (mainIndex) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15.h, bottom: 5.h, left: 5.w, right: 5.w),
                    child: Text(
                      context
                          .read<CompareProvider>()
                          .comparableAttributeList[0][mainIndex]
                          .key,
                      style: FontPalette.black16Medium
                          .copyWith(color: HexColor('#282C3F')),
                    ),
                  ),
                  //15.verticalSpace,
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    border: TableBorder(
                      verticalInside: BorderSide(
                          width: .7.r,
                          color: HexColor("#E6E6E6"),
                          style: BorderStyle.solid),
                      right:
                          BorderSide(color: HexColor("#E6E6E6"), width: .7.r),
                      top: BorderSide(color: HexColor("#E6E6E6"), width: .7.r),
                      bottom:
                          BorderSide(color: HexColor("#E6E6E6"), width: .7.r),
                    ),
                    children: List.generate(
                        context
                            .read<CompareProvider>()
                            .comparableAttributeList[0][mainIndex]
                            .value
                            .length, (valueIndex) {
                      return TableRow(
                        children: List.generate(
                          (context
                                  .read<CompareProvider>()
                                  .compareProductList
                                  .notEmpty)
                              ? context
                                  .read<CompareProvider>()
                                  .compareProductList
                                  .length
                              : 0,
                          (productIndex) {
                            var item = context
                                .read<CompareProvider>()
                                .comparableAttributeList[productIndex]
                                    [mainIndex]
                                .value[valueIndex];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text((item.key ?? '').toString().trim(),
                                      style: FontPalette.black13Medium),
                                  5.verticalSpace,
                                  Text(convertValueText(item.value.toString()),
                                      style: FontPalette.black13Regular
                                          .copyWith(height: 1.5.h))
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              )),
    );
  }

  convertValueText(String value) {
    String valueText = '';
    switch (value) {
      case 'null':
        valueText = 'N/A';
        break;
      case 'true':
        valueText = 'Yes';
        break;
      case 'false':
        valueText = 'No';
        break;
      default:
        valueText = value;
    }
    return valueText;
  }
}
