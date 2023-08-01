import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/bajaj_emi/widgets/bajaj_emi_price_details.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FlowOne extends StatefulWidget {
  const FlowOne({
    Key? key,
  }) : super(key: key);

  @override
  State<FlowOne> createState() => _FlowOneState();
}

class _FlowOneState extends State<FlowOne> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<BajajEmiProvider>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                18.verticalSpace,
                Text(Constants.bajajEmiCardNumber,
                    style: FontPalette.f7B7E8E_12Regular),
                11.verticalSpace,
                CustomTextFormField(
                  controller: model.cardNumberController,
                  hintText: Constants.enterCardNumber,
                  hintStyle: FontPalette.f7B7E8E_15Regular,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: HexColor("#DBDBDB"),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    LengthLimitingTextInputFormatter(16)
                  ],
                  onChanged: (value) {
                    if (value.length == 16) {
                      model.changeSchemeButtonStatus(true);
                    } else {
                      model.changeSchemeButtonStatus(false);
                    }
                  },
                ),
                18.verticalSpace,
                Selector<BajajEmiProvider, Tuple2<LoaderState, bool>>(
                    selector: (context, provider) => Tuple2(
                        provider.loaderState, provider.enableSchemeButton),
                    builder: (context, value, child) {
                      return CustomButton(
                        isLoading: value.item1 == LoaderState.loading,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          model.clearEmiDetails();
                          model
                              .checkScheme(context,
                                  model.cardNumberController.text.trim())
                              .then((value) {
                            if (value) {
                              model.pageController.jumpToPage(1);
                              model.changeLinearProgressValue(2);
                            }
                          });
                        },
                        enabled: value.item2,
                        title: Constants.checkScheme,
                      );
                    }),
                18.verticalSpace,
              ],
            ),
          ),
          Divider(
            height: 5.h,
            thickness: 5.h,
            color: HexColor("#F3F3F7"),
          ),
          const BajajEmiPriceDetailsWidget()
        ],
      ),
    );
  }
}
