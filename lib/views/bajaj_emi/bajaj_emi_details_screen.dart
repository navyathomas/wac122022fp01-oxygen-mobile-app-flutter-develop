import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/bajaj_emi_details_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';

class BajajEmiDetailsScreen extends StatelessWidget {
  final BajajEmiDetails? bajajEmiDetails;
  const BajajEmiDetailsScreen({Key? key, this.bajajEmiDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: Constants.bajajNoCostEmi,
        actionList: const [],
      ),
      body: SafeArea(
        child: (bajajEmiDetails?.items?.isEmpty ?? true)
            ? const CommonLinearProgress()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    18.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(bajajEmiDetails?.subTitle ?? "",
                          style: FontPalette.black14Regular),
                    ),
                    10.verticalSpace,
                    Column(
                      children: [
                        Container(
                          color: HexColor("#F3F3F7"),
                          child: Center(
                            child: _BuildLoanRow(
                              data: bajajEmiDetails?.columns,
                              textStyle: FontPalette.f7B7E8E_12Medium,
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                              bajajEmiDetails?.items?.length ?? 0, (index) {
                            final item =
                                bajajEmiDetails?.items?.elementAt(index);
                            return _BuildLoanRow(data: item?.values);
                          }),
                        ),
                        Divider(
                          height: 5.h,
                          thickness: 5.h,
                          color: HexColor("#F3F3F7"),
                        ),
                      ],
                    ),
                    25.verticalSpace,
                  ],
                ),
              ),
      ),
    );
  }
}

class _BuildLoanRow extends StatelessWidget {
  final List<String?>? data;
  final TextStyle? textStyle;

  const _BuildLoanRow({
    Key? key,
    this.data,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
            data?.length ?? 0,
            (index) => Expanded(
                  flex: index == 0 ? 3 : 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        right:
                            BorderSide(width: 1.w, color: HexColor("#E5E5ED")),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Text(
                        data?.elementAt(index) ?? "",
                        style: textStyle ?? FontPalette.black12Regular,
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
