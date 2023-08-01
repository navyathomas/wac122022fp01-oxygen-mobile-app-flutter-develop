import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/bajaj_emi/widgets/bajaj_emi_price_details.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_check_box.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FlowThree extends StatelessWidget {
  const FlowThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BajajEmiProvider>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                18.verticalSpace,
                Column(
                  children: [
                    Container(
                      color: HexColor("#F3F3F7"),
                      child: Center(
                        child: _BuildLoanRow(
                          item: model.selectedSchemeDetails?.columns,
                          textStyle: FontPalette.black12Medium,
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(
                          model.selectedSchemeDetails?.items?.length ?? 0,
                          (index) {
                        final item = model.selectedSchemeDetails?.items
                            ?.elementAt(index);
                        return _BuildLoanRow(
                          item: item?.values,
                        );
                      }),
                    ),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: HexColor("#E5E5ED"),
                    ),
                    18.verticalSpace,
                  ],
                ),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                if (model.termsAndConditions != null)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<BajajEmiProvider, bool>(
                            selector: (context, provider) => provider.accept,
                            builder: (context, value, child) {
                              return CustomCheckBox(
                                isSelected: value,
                                onTap: () {
                                  model.changeAcceptStatus();
                                },
                              );
                            }),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.termsAndConditions?.title ?? "",
                                  style: FontPalette.black14Medium,
                                ),
                                10.verticalSpace,
                                Text(
                                  model.termsAndConditions?.description ?? "",
                                  style: FontPalette.black12Regular,
                                ),
                                18.verticalSpace,
                                Row(
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          model.pageController.jumpToPage(1);
                                          model.changeLinearProgressValue(2);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6.h, horizontal: 12.w),
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: 15.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: HexColor("#7B7E8E"))),
                                          child: Center(
                                              child: Text(
                                            Constants.changeEmiScheme
                                                .toUpperCase(),
                                            style: FontPalette.black13Medium,
                                          )),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                const BajajEmiPriceDetailsWidget(),
                25.verticalSpace,
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
          decoration: CommonStyles.bottomDecoration,
          child: Selector<BajajEmiProvider, Tuple2<bool, LoaderState>>(
              selector: (context, provider) =>
                  Tuple2(provider.accept, provider.loaderState),
              builder: (context, value, child) {
                return CustomButton(
                  enabled: value.item1,
                  isLoading: value.item2 == LoaderState.loading,
                  title: Constants.generateOtp,
                  onPressed: () async {
                    model.currentMicroSeconds.value = 30 * 1000000;
                    model.otpController.clear();
                    final result = await model.generateBajajEmiOtp(
                        cardNumber: model.cardNumber ?? "",
                        city: model.customerBillingSearch?.city ?? "",
                        intercity:
                            model.customerBillingSearch?.intercity ?? false,
                        schemeId: model.selectedScheme ?? "");
                    if (result) {
                      model.pageController.jumpToPage(3);
                      model.changeLinearProgressValue(4);
                    }
                  },
                );
              }),
        )
      ],
    );
  }
}

class _BuildLoanRow extends StatelessWidget {
  final List<String?>? item;
  final TextStyle? textStyle;

  const _BuildLoanRow({
    Key? key,
    this.item,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          item?.length ?? 0,
          (index) => Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: .5, color: HexColor("#E5E5ED")),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 23.w, right: 5.w),
                    child: Text(
                      item?.elementAt(index) ?? "",
                      style: textStyle ?? FontPalette.black12Regular,
                    ),
                  ),
                ),
              )),
    );
  }
}
