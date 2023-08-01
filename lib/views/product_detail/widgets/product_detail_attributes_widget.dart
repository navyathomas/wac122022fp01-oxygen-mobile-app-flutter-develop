import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:provider/provider.dart';

class ProductDetailAttributesWidget extends StatelessWidget {
  const ProductDetailAttributesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ProductDetailProvider, Item?>(
        selector: (context, provider) => provider.selectedItem,
        builder: (context, value, child) {
          List<ProductAttributes>? list;
          if (value?.productCustomAttributes != null) {
            final Map<String, dynamic> attributesValue =
                jsonDecode(value?.productCustomAttributes ?? "");
            list = attributesValue.entries.map((e) {
              return ProductAttributes(
                title: e.key,
                values: e.value,
              );
            }).toList();
          }

          return (list == null || list.isEmpty)
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list
                          .map((first) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        18.verticalSpace,
                                        Text(
                                          first.title?.trim() ?? "",
                                          style: FontPalette.black16Medium,
                                        ),
                                        11.verticalSpace,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: first.values?.entries
                                                  .map((second) {
                                                return _BuildRow(
                                                  title: second.key.trim(),
                                                  text: second.value
                                                      ?.toString()
                                                      .trim(),
                                                );
                                              }).toList() ??
                                              [],
                                        ),
                                        18.verticalSpace,
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 5.h,
                                    thickness: 5.h,
                                    color: HexColor("#F3F3F7"),
                                  ),
                                ],
                              ))
                          .toList()),
                );
        });
  }
}

class _BuildRow extends StatelessWidget {
  final String? title;
  final String? text;

  const _BuildRow({Key? key, this.title, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (text == null || (text?.isEmpty ?? true))
        ? const SizedBox.shrink()
        : Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 9.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    title ?? "",
                    style: FontPalette.black14Regular,
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  flex: 5,
                  child: Text(
                    text ?? "",
                    style: FontPalette.black14Medium,
                  ),
                ),
              ],
            ),
          );
  }
}
