import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/generated/assets.dart';
import 'package:oxygen/providers/product_detail_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/three_bounce.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../common/constants.dart';

class ProductDetailDeliveryToWidget extends StatefulWidget {
  const ProductDetailDeliveryToWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailDeliveryToWidget> createState() =>
      _ProductDetailDeliveryToWidgetState();
}

class _ProductDetailDeliveryToWidgetState
    extends State<ProductDetailDeliveryToWidget> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> enableCheck = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    CommonFunctions.afterInit(() {
      context.read<ProductDetailProvider>().getPinCode();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    enableCheck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductDetailProvider>();
    return Selector<ProductDetailProvider,
            Tuple4<String?, bool?, String?, bool>>(
        selector: (context, provider) => Tuple4(
            provider.pinCode,
            provider.pinCodeStatus,
            provider.pinCodeMessage,
            provider.pinCodeLoading),
        builder: (context, value, child) {
          return Container(
            width: double.maxFinite,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 5.h),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 19.h, horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: 16.5.r,
                        child: SvgPicture.asset(Assets.iconsLocation),
                      ),
                      6.horizontalSpace,
                      Expanded(
                        child: Text(
                          Constants.deliveryTo,
                          style: FontPalette.black16Medium,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      if (!(value.item2 ?? true)) {
                        enableCheck.value = false;
                        controller.clear();
                        model.clearPinCode();
                      }
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor("#DBDBDB"),
                            ),
                          ),
                        ),
                        Container(
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (value.item1 == null)
                                  ? Expanded(
                                      child: TextFormField(
                                        controller: controller,
                                        style: FontPalette.black15Regular,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(6),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        keyboardType: TextInputType.number,
                                        maxLines: 1,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                hintText:
                                                    Constants.enterPinCode,
                                                hintStyle: FontPalette
                                                    .black15Regular
                                                    .copyWith(
                                                        color: Colors.grey))
                                            .copyWith(isDense: true),
                                        onChanged: (val) {
                                          if (val.length > 5) {
                                            enableCheck.value = true;
                                          } else {
                                            enableCheck.value = false;
                                          }
                                        },
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          value.item1 ?? "",
                                          style: FontPalette.black16Bold,
                                        ),
                                        18.horizontalSpace,
                                        SizedBox.square(
                                          dimension: 12.7.r,
                                          child: SvgPicture.asset(
                                            (value.item2 ?? false)
                                                ? Assets.iconsTick
                                                : Assets.iconsClose,
                                            color: (value.item2 ?? false)
                                                ? HexColor("#179614")
                                                : HexColor("#E50019"),
                                          ),
                                        ),
                                      ],
                                    ),
                              value.item4
                                  ? ThreeBounce(
                                      color: HexColor("#E50019"), size: 30.r)
                                  : GestureDetector(
                                      onTap: () {
                                        if (enableCheck.value ||
                                            value.item1 != null) {
                                          if (value.item1 != null) {
                                            enableCheck.value = false;
                                            controller.clear();
                                            model.clearPinCode();
                                          } else {
                                            if (controller.text.length < 6) {
                                              Helpers.successToast(
                                                  Constants.enterValidPinCode);
                                            } else {
                                              model.checkPinCode(
                                                  context,
                                                  controller.text,
                                                  model.selectedItem?.id ?? 0);
                                            }
                                          }
                                        }
                                      },
                                      child: (value.item1 == null)
                                          ? ValueListenableBuilder<bool>(
                                              valueListenable: enableCheck,
                                              builder: (_, check, __) {
                                                return Text(
                                                  Constants.check.toUpperCase(),
                                                  style: check
                                                      ? FontPalette
                                                          .fE50019_15Bold
                                                      : FontPalette
                                                          .fE50019_15Bold
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
                                                );
                                              })
                                          : Text(
                                              Constants.change.toUpperCase(),
                                              style: FontPalette.fE50019_15Bold,
                                            ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  if (value.item2 != null)
                    Text(
                      value.item3 ?? "",
                      style: (value.item2 ?? false)
                          ? FontPalette.black16Regular
                              .copyWith(color: HexColor("#179614"))
                          : FontPalette.black16Regular
                              .copyWith(color: HexColor("#E50019")),
                    )
                ],
              ),
            ),
          );
        });
  }
}
