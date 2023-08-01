import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_styles.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/models/arguments/payment_arguments.dart';
import 'package:oxygen/providers/bajaj_emi_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/bajaj_emi/widgets/bajaj_emi_price_details.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../../../providers/select_address_provider.dart';

class FlowFive extends StatelessWidget {
  final SelectAddressProvider selectAddressProvider;

  const FlowFive({
    Key? key,
    required this.selectAddressProvider,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Constants.customerResidenceCity,
                          style: FontPalette.f7B7E8E_12Regular),
                      11.verticalSpace,
                      Container(
                        height: 45.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor("#DBDBDB"),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.customerBillingSearch?.city ?? "",
                          maxLines: 1,
                          style: FontPalette.black15Regular,
                        ),
                      ),
                      16.verticalSpace,
                      Text(Constants.transactionRefNo,
                          style: FontPalette.f7B7E8E_12Regular),
                      11.verticalSpace,
                      Container(
                        height: 45.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor("#DBDBDB"),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.transactionRefNumber ?? "",
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
                Column(
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
                    18.verticalSpace,
                  ],
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
          child: CustomButton(
            title: Constants.payNow,
            onPressed: () {
              Navigator.pushNamed(context, RouteGenerator.routePaymentScreen,
                  arguments: PaymentArguments(
                      selectAddressProvider: selectAddressProvider,
                      navFromBajaj: true));
            },
          ),
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
