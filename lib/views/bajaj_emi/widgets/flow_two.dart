import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/providers/cart_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/bajaj_emi/widgets/bajaj_emi_price_details.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FlowTwo extends StatelessWidget {
  const FlowTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BajajEmiProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.verticalSpace,
                      Text(Constants.customerResidenceCity,
                          style: FontPalette.f7B7E8E_12Regular),
                      11.verticalSpace,
                      Container(
                        height: 45.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor("#DBDBDB"),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.customerBillingSearch?.city ?? "",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: FontPalette.black15Regular,
                        ),
                      ),
                      16.verticalSpace,
                      Text(Constants.intercityDeliveryAllowed,
                          style: FontPalette.f7B7E8E_12Regular),
                      11.verticalSpace,
                      Container(
                        height: 45.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor("#DBDBDB"),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (model.customerBillingSearch?.intercity ?? false)
                              ? Constants.yes
                              : Constants.no,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: FontPalette.black15Regular,
                        ),
                      ),
                      16.verticalSpace,
                    ],
                  ),
                ),
                Divider(
                  height: 5.h,
                  thickness: 5.h,
                  color: HexColor("#F3F3F7"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      18.verticalSpace,
                      Text(Constants.selectPaymentPlan,
                          style: FontPalette.f7B7E8E_12Regular),
                      14.verticalSpace,
                      Selector<BajajEmiProvider, List<BajajItem?>?>(
                        selector: (context, provider) =>
                            provider.customerBillingSearch?.items?.items,
                        builder: (context, value, child) {
                          return Column(
                            children:
                                List.generate(value?.length ?? 0, (index) {
                              final item = value?.elementAt(index);
                              return _BuildPaymentPlan(bajajItem: item);
                            }),
                          );
                        },
                      ),
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
          child: Selector<BajajEmiProvider, Tuple2<String?, LoaderState>>(
              selector: (context, provider) =>
                  Tuple2(provider.selectedScheme, provider.loaderState),
              builder: (context, value, child) {
                return CustomButton(
                  isLoading: value.item2 == LoaderState.loading,
                  enabled: value.item1 != null,
                  onPressed: () async {
                    await model
                        .setEmiScheme(context, model.selectedScheme ?? "")
                        .then((value) async {
                      if (value) {
                        model.accept = false;
                        await model.getCurrentSchemeDetails();
                        await model.getBajajTermsAndConditions();
                        await Future.microtask(() =>
                            context.read<CartProvider>().getCartDataList());
                        model.pageController.jumpToPage(2);
                        model.changeLinearProgressValue(3);
                      }
                    });
                  },
                );
              }),
        )
      ],
    );
  }
}

class _BuildPaymentPlan extends StatelessWidget {
  final BajajItem? bajajItem;

  const _BuildPaymentPlan({
    Key? key,
    this.bajajItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<BajajEmiProvider>();
    return GestureDetector(
      onTap: () {
        model.setSelectedScheme(bajajItem?.schemeId);
      },
      child: Selector<BajajEmiProvider, String?>(
          selector: (context, provider) => provider.selectedScheme,
          builder: (context, value, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#DBDBDB"),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRadioButton(
                      isSelected:
                          (value != null && bajajItem?.schemeId == value)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: (value != null && bajajItem?.schemeId == value)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bajajItem?.values?.elementAt(0) ?? "",
                                    style: FontPalette.black16Medium),
                                11.verticalSpace,
                                _BuildPlanDetailsRow(
                                    title: Constants.additionalFees,
                                    value:
                                        bajajItem?.values?.elementAt(1) ?? ""),
                                _BuildPlanDetailsRow(
                                    title: Constants.downPayment,
                                    value:
                                        bajajItem?.values?.elementAt(2) ?? ""),
                                _BuildPlanDetailsRow(
                                    title: Constants.overallLoanAmount,
                                    value:
                                        bajajItem?.values?.elementAt(3) ?? "",
                                    textStyle: FontPalette.black14Medium),
                              ],
                            )
                          : Text(bajajItem?.values?.elementAt(0) ?? "",
                              style: FontPalette.black16Medium),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class _BuildPlanDetailsRow extends StatelessWidget {
  const _BuildPlanDetailsRow({
    Key? key,
    this.title,
    this.value,
    this.textStyle,
  }) : super(key: key);

  final String? title;
  final String? value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title ?? "",
              style: textStyle ?? FontPalette.black14Regular,
            ).avoidOverFlow(),
          ),
          Expanded(
            child: Text(
              value ?? "",
              textAlign: TextAlign.end,
              style: textStyle ?? FontPalette.black14Regular,
            ).avoidOverFlow(),
          ),
        ],
      ),
    );
  }
}
