import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/cart_data_model.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

import '../../../../common/common_function.dart';
import '../../../../common/constants.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../utils/font_palette.dart';
import '../../../../widgets/custom_btn.dart';
import '../../../../widgets/custom_outline_button.dart';

class CartAddOnBottomSheet extends StatefulWidget {
  final BuildContext mainContext;
  final List<AddonOptions> addonOptions;
  final String sku;
  final int qty;
  final int cartItemId;

  const CartAddOnBottomSheet(
      {Key? key,
      required this.mainContext,
      required this.addonOptions,
      required this.qty,
      required this.sku,
      required this.cartItemId})
      : super(key: key);

  @override
  State<CartAddOnBottomSheet> createState() => _CartAddOnBottomSheetState();
}

class _CartAddOnBottomSheetState extends State<CartAddOnBottomSheet> {
  late final ValueNotifier<int> selectedOptionId;
  late final ValueNotifier<int> selectedOptionTypeId;

  double bottomSheetHeight(List<AddonOptions> options) {
    try {
      if ((options.first.value!.length != 1)) {
        return context.sh(size: 0.45);
      } else {
        return context.sh(size: 0.35);
      }
    } catch (e) {
      return context.sh(size: 0.35);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(left: 13.w, right: 13.w, top: 21.h, bottom: 26.h),
        height: bottomSheetHeight(widget.addonOptions),
        color: Colors.white,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (cxt, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                  text: widget.addonOptions[index].title ?? '',
                                  style: FontPalette.black16Regular),
                            ),
                            12.verticalSpace,
                            Text(
                              Constants.pleaseChooseOneOption,
                              style: FontPalette.f7E818C_12Regular,
                            ),
                            ValueListenableBuilder<int>(
                                valueListenable: selectedOptionTypeId,
                                builder: (context, selectedId, _) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      shrinkWrap: true,
                                      itemCount: widget.addonOptions[index]
                                              .value?.length ??
                                          0,
                                      itemBuilder: (context, childIndex) {
                                        Value? value = widget
                                            .addonOptions[index]
                                            .value?[childIndex];
                                        return InkWell(
                                          onTap: () {
                                            selectedOptionId.value = widget
                                                    .addonOptions[index]
                                                    .optionId ??
                                                -1;
                                            selectedOptionTypeId.value =
                                                value?.optionTypeId ?? -1;
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h),
                                            child: Row(
                                              children: [
                                                CustomRadioButton(
                                                  isSelected:
                                                      (value?.optionTypeId ??
                                                              -2) ==
                                                          selectedId,
                                                  onTap: () {
                                                    selectedOptionId
                                                        .value = widget
                                                            .addonOptions[index]
                                                            .optionId ??
                                                        -1;
                                                    selectedOptionTypeId.value =
                                                        value?.optionTypeId ??
                                                            -1;
                                                  },
                                                ),
                                                10.horizontalSpace,
                                                Expanded(
                                                    child: Text(
                                                  value?.title ?? '',
                                                  style:
                                                      FontPalette.black16Medium,
                                                ))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }),
                          ],
                        ),
                      );
                    },
                    itemCount: widget.addonOptions.length,
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: CustomOutlineButton(
                        title: Constants.cancel,
                        onPressed: () => Navigator.of(context).pop(),
                      )),
                  10.horizontalSpace,
                  Flexible(
                      child: CustomButton(
                    title: Constants.submit,
                    height: 45.h,
                    width: double.maxFinite,
                    onPressed: () async {
                      if (selectedOptionTypeId.value != -1) {
                        Navigator.of(context).pop();
                        final res = await widget.mainContext
                            .read<CartProvider>()
                            .updateCartItem(
                                sku: widget.sku,
                                cartItemId: widget.cartItemId,
                                qty: widget.qty,
                                optionId: selectedOptionId.value,
                                optionTypeId: selectedOptionTypeId.value,
                                refreshData: true);
                        if (res) {
                          CommonFunctions.afterInit(() {
                            Helpers.flushToast(widget.mainContext,
                                msg: Constants.updatedYourCart);
                          });
                        }
                      } else {
                        Helpers.flushToast(widget.mainContext,
                            msg: Constants.pleaseChooseOneOption);
                      }
                    },
                  ))
                ],
              )
            ]));
  }

  @override
  void initState() {
    selectedOptionId = ValueNotifier(-1);
    selectedOptionTypeId = ValueNotifier(-1);
    super.initState();
  }

  @override
  void dispose() {
    selectedOptionId.dispose();
    selectedOptionTypeId.dispose();
    super.dispose();
  }
}
