import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_drop_down.dart';

class FaqQueryDropdown extends StatelessWidget {
  FaqQueryDropdown(
      {super.key,
      required this.faqFilters,
      required this.offeset,
      this.onChanged});

  final List<String> faqFilters;
  Function(String? s)? onChanged;
  ValueNotifier<double> offeset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (offeset.value > 10.0)
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              spreadRadius: 0,
            )
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 14.h, left: 13.w, right: 13.w, bottom: 10.h),
        child: Container(
          color: HexColor('#F4F4F4'),
          child: CustomDropdown<String>(
            onChange: (value) {
              onChanged?.call(value);
              offeset.value = 0.0;
            },
            dropdownStyle: DropdownStyle(
              color: HexColor('#F4F4F4'),
            ),
            initialTextStyle: FontPalette.black15Regular,
            dropdownButtonStyle: DropdownButtonStyle(
                unselectedTextStyle: FontPalette.f282C3F_15Regular,
                textStyle: FontPalette.f282C3F_15Regular,
                padding: EdgeInsets.only(left: 14.w, right: 11.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor("#DBDBDB"),
                  ),
                ),
                height: 40.h),
            items: List.generate(
              faqFilters.length,
              (index) => DropdownItem(
                  value: faqFilters.elementAt(index),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 17.h, horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          faqFilters.elementAt(index),
                          style: FontPalette.black14Regular,
                        ),
                      ],
                    ),
                  )),
            ),
            initialValue: 'All',
          ),
        ),
      ),
    );
  }
}
