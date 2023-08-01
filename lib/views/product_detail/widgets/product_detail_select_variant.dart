import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/product_detail_model.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_fade_in_image.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProductDetailSelectVariant extends StatelessWidget {
  const ProductDetailSelectVariant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider,
            Tuple2<List<ConfigurableOption?>?, Map<String, dynamic>>>(
        selector: (context, provider) =>
            Tuple2(provider.configurableOption, provider.selectedProduct),
        shouldRebuild: (previous, next) {
          return previous.item2 == next.item2;
        },
        builder: (context, value, child) {
          return (value.item1 == null || (value.item1?.isEmpty ?? true))
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          Constants.selectVariant,
                          textAlign: TextAlign.start,
                          style: FontPalette.black18Medium,
                        ),
                      ),
                      12.verticalSpace,
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.item1?.length ?? 0,
                        itemBuilder: (context, index) {
                          final label = value.item1?.elementAt(index)?.label;
                          final attributeCode =
                              value.item1?.elementAt(index)?.attributeCode;

                          Value? selected;
                          try {
                            selected = value.item1
                                ?.elementAt(index)
                                ?.values
                                ?.firstWhere(
                              (element) {
                                return value.item2.values
                                    .contains(element?.valueIndex);
                              },
                            );
                          } catch (e) {
                            //Handle Exception
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: label ?? "",
                                        style: FontPalette.black16Regular,
                                      ),
                                      TextSpan(
                                        text: ": ",
                                        style: FontPalette.black16Regular,
                                      ),
                                      TextSpan(
                                        text: selected?.label,
                                        style: FontPalette.black16Medium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: (label?.toLowerCase() == "color")
                                    ? 105.h
                                    : 62.h,
                                child: ListView.separated(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: value.item1
                                          ?.elementAt(index)
                                          ?.values
                                          ?.length ??
                                      0,
                                  itemBuilder: (context, secondIndex) {
                                    final valueIndex = value.item1
                                        ?.elementAt(index)
                                        ?.values
                                        ?.elementAt(secondIndex)
                                        ?.valueIndex;
                                    final swatchValue = value.item1
                                        ?.elementAt(index)
                                        ?.values
                                        ?.elementAt(secondIndex)
                                        ?.swatchData
                                        ?.value;
                                    final swatchThumbnail = value.item1
                                        ?.elementAt(index)
                                        ?.values
                                        ?.elementAt(secondIndex)
                                        ?.swatchData
                                        ?.thumbnail;
                                    final childLabel = value.item1
                                        ?.elementAt(index)
                                        ?.values
                                        ?.elementAt(secondIndex)
                                        ?.label;
                                    return Center(
                                      child: (label?.toLowerCase() == "color")
                                          ? (swatchThumbnail == null)
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (value.item2
                                                        .containsValue(
                                                            valueIndex)) {
                                                      return;
                                                    } else if (model.listToHide
                                                        .contains(valueIndex)) {
                                                      return;
                                                    }
                                                    model.addToUserSelectedMap(
                                                      key: attributeCode,
                                                      value: valueIndex,
                                                    );
                                                    model.addToSelectedProduct(
                                                        key: attributeCode,
                                                        value: valueIndex);
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: value.item2
                                                                .containsValue(
                                                                    valueIndex)
                                                            ? 46.r
                                                            : 40.r,
                                                        width: value.item2
                                                                .containsValue(
                                                                    valueIndex)
                                                            ? 46.r
                                                            : 40.r,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: value.item2
                                                                  .containsValue(
                                                                      valueIndex)
                                                              ? null
                                                              : HexColor(
                                                                  swatchValue ??
                                                                      ""),
                                                          border: value.item2
                                                                  .containsValue(
                                                                      valueIndex)
                                                              ? Border.all(
                                                                  color: HexColor(
                                                                      swatchValue ??
                                                                          ""))
                                                              : null,
                                                        ),
                                                        child: value.item2
                                                                .containsValue(
                                                                    valueIndex)
                                                            ? Center(
                                                                child:
                                                                    Container(
                                                                  height: 40.r,
                                                                  width: 40.r,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: HexColor(
                                                                          swatchValue ??
                                                                              "")),
                                                                ),
                                                              )
                                                            : null,
                                                      ),
                                                      if (model.listToHide
                                                          .contains(valueIndex))
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: CustomPaint(
                                                            foregroundPainter:
                                                                _CustomDiagonal(),
                                                            child: Container(
                                                              height: 40.r,
                                                              width: 40.r,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .50),
                                                                  shape: BoxShape
                                                                      .circle),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (value.item2
                                                        .containsValue(
                                                            valueIndex)) {
                                                      return;
                                                    } else if (model.listToHide
                                                        .contains(valueIndex)) {
                                                      return;
                                                    }
                                                    model.addToUserSelectedMap(
                                                      key: attributeCode,
                                                      value: valueIndex,
                                                    );
                                                    model.addToSelectedProduct(
                                                        key: attributeCode,
                                                        value: valueIndex);
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: 64.h,
                                                        width: 59.w,
                                                        padding:
                                                            EdgeInsets.all(2.r),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: model
                                                                      .listToHide
                                                                      .contains(
                                                                          valueIndex)
                                                                  ? Colors
                                                                      .transparent
                                                                  : value.item2
                                                                          .containsValue(
                                                                              valueIndex)
                                                                      ? HexColor(
                                                                          "#E50019")
                                                                      : HexColor(
                                                                          "#DBDBDB")),
                                                        ),
                                                        child: CommonFadeInImage(
                                                            image:
                                                                swatchThumbnail),
                                                      ),
                                                      if (model.listToHide
                                                          .contains(valueIndex))
                                                        CustomPaint(
                                                          foregroundPainter:
                                                              _CustomDiagonal(),
                                                          child: DottedBorder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            color: HexColor(
                                                                "#DBDBDB"),
                                                            child: Container(
                                                              height: 64.h,
                                                              width: 59.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        .25),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ))
                                          : GestureDetector(
                                              onTap: () {
                                                if (value.item2.containsValue(
                                                    valueIndex)) {
                                                  return;
                                                } else if (model.listToHide
                                                    .contains(valueIndex)) {
                                                  return;
                                                }
                                                model.addToUserSelectedMap(
                                                  key: attributeCode,
                                                  value: valueIndex,
                                                );
                                                model.addToSelectedProduct(
                                                    key: attributeCode,
                                                    value: valueIndex);
                                              },
                                              child: CustomPaint(
                                                foregroundPainter: model
                                                        .listToHide
                                                        .contains(valueIndex)
                                                    ? _CustomDiagonal()
                                                    : null,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.h,
                                                      horizontal: 10.w),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: model
                                                                  .listToHide
                                                                  .contains(
                                                                      valueIndex)
                                                              ? HexColor(
                                                                  "#DBDBDB")
                                                              : value.item2
                                                                      .containsValue(
                                                                          valueIndex)
                                                                  ? HexColor(
                                                                      "#E50019")
                                                                  : HexColor(
                                                                      "#DBDBDB"))),
                                                  child: Text(childLabel ?? "",
                                                      style: model.listToHide
                                                              .contains(
                                                                  valueIndex)
                                                          ? FontPalette
                                                              .fDBDBDB_14Medium
                                                          : value.item2
                                                                  .containsValue(
                                                                      valueIndex)
                                                              ? FontPalette
                                                                  .fE50019_14Medium
                                                              : FontPalette
                                                                  .black14Medium),
                                                ),
                                              ),
                                            ),
                                    );
                                  },
                                  separatorBuilder: (context, secondIndex) =>
                                      (label?.toLowerCase() == "color")
                                          ? 13.horizontalSpace
                                          : 18.horizontalSpace,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => 10.verticalSpace,
                      ),
                      18.verticalSpace,
                    ],
                  ),
                );
        });
  }
}

class _CustomDiagonal extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = HexColor("#DBDBDB");
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;

    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
