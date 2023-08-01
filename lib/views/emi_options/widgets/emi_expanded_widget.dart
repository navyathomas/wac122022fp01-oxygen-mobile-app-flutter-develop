import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/models/emi_plans_model.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';

class EmiExpandedWidget extends StatelessWidget {
  final List<Plan?>? plans;

  const EmiExpandedWidget({
    Key? key,
    this.plans,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 78,
                    child: _BuildRow(
                      title: Constants.tenure,
                    ),
                  ),
                  Expanded(
                    flex: 79,
                    child: _BuildRow(
                      title: Constants.interest,
                    ),
                  ),
                  Expanded(
                    flex: 106,
                    child: _BuildRow(
                      title: Constants.emiAmount,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 78,
                    child: Column(
                      children: List.generate(plans?.length ?? 0, (index) {
                        final item = plans?.elementAt(index);
                        return _BuildAttribute(attribute: item?.month);
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 79,
                    child: Column(
                      children: List.generate(plans?.length ?? 0, (index) {
                        final item = plans?.elementAt(index);
                        return _BuildAttribute(attribute: "₹${item?.interest}");
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 106,
                    child: Column(
                      children: List.generate(plans?.length ?? 0, (index) {
                        final item = plans?.elementAt(index);
                        return _BuildAttribute(attribute: "₹${item?.emi}");
                      }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 5.r,
          color: HexColor("#F3F3F7"),
        )
      ],
    );
  }
}

class _BuildAttribute extends StatelessWidget {
  const _BuildAttribute({
    Key? key,
    this.attribute,
  }) : super(key: key);

  final String? attribute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: .5.r,
            color: HexColor("#E5E5ED"),
          ),
          right: BorderSide(
            width: .5.r,
            color: HexColor("#E5E5ED"),
          ),
        ),
      ),
      child: Text(
        attribute ?? "",
        maxLines: 1,
        textAlign: TextAlign.center,
        style: FontPalette.black12Regular,
      ),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final String? title;

  const _BuildRow({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#F3F3F7"),
        border: Border(
          left: BorderSide(
            width: .5.r,
            color: HexColor("#E5E5ED"),
          ),
          right: BorderSide(
            width: .5.r,
            color: HexColor("#E5E5ED"),
          ),
        ),
      ),
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: Text(
          title ?? "",
          maxLines: 1,
          style: FontPalette.f7B7E8E_14Regular,
        ),
      ),
    );
  }
}
