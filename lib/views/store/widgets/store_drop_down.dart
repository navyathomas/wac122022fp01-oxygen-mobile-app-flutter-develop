import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/stores_provider.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_palette.dart';
import '../../../widgets/custom_drop_down.dart';

class StoreDropDown extends StatelessWidget {
  StoreDropDown(
      {Key? key,
      this.isScrolled,
      this.districtList,
      this.onChanged,
      this.provider,
      required this.offeset})
      : super(key: key);

  bool? isScrolled;
  final List<String>? districtList;
  Function(String? value)? onChanged;
  StoresProvider? provider;
  ValueNotifier<double> offeset;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: offeset,
      builder: (_, __, ___) => Container(
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
          padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
          child: CustomDropdown(
            parrentScrolled: isScrolled,
            overlayPadding: 12.w,
            initialValue: Constants.allLocations,
            padding: EdgeInsets.symmetric(horizontal: 14.5.w),
            dropdownStyle: DropdownStyle(
              color: HexColor('#F4F4F4'),
            ),
            initialTextStyle: FontPalette.black15Regular,
            dropdownButtonStyle: DropdownButtonStyle(
                margin: EdgeInsets.symmetric(horizontal: 12.5.w),
                height: 40.h,
                decoration: BoxDecoration(
                  color: HexColor('#F4F4F4'),
                  border: Border.all(
                    color: HexColor('#DBDBDB'),
                  ),
                ),
                unselectedTextStyle: FontPalette.black16Regular),
            items: List.generate(
              districtList?.length ?? 0,
              (index) => DropdownItem(
                  value: districtList?.elementAt(index),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 17.h, horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          districtList?.elementAt(index) ?? '',
                          style: FontPalette.black14Regular,
                        ),
                      ],
                    ),
                  )),
            ),
            onChange: (value) {
              offeset.value = 0.0;
              onChanged?.call(value);
              provider?.scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            },
          ),
        ),
      ),
    );
  }
}
