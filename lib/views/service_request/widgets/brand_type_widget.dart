import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_drop_down.dart';

class BrandTypeWidget extends StatelessWidget {
  const BrandTypeWidget({Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      allowTap: serviceRequestProvider.brand == null,
      initialTextStyle: FontPalette.black14Regular,
      onChange: (value) => serviceRequestProvider
        ..getBrandValueFromLabel(value)
        ..updateIsServiceRequestFormValidated(),
      dropdownStyle: DropdownStyle(
        color: Colors.white,
        borderSide: BorderSide(
          color: HexColor("#DBDBDB"),
        ),
      ),
      dropdownButtonStyle: DropdownButtonStyle(
        unselectedTextStyle: FontPalette.f7B7E8E_14Regular,
        textStyle: FontPalette.black14Regular,
        padding: EdgeInsets.only(left: 14.w, right: 4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor("#DBDBDB"),
          ),
        ),
      ),
      items: List.generate(
        serviceRequestProvider.brandList.length,
        (index) => DropdownItem(
          value: serviceRequestProvider.brandList[index].label ?? '',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  serviceRequestProvider.brandList[index].label ?? '',
                  style: FontPalette.black14Regular,
                ),
              ],
            ),
          ),
        ),
      ),
      initialValue: serviceRequestProvider.brandLabel ?? Constants.brand,
    );
  }
}
