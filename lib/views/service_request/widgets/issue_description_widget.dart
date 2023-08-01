import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_text_form_field.dart';

class IssueDescriptionWidget extends StatelessWidget {
  const IssueDescriptionWidget({Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: HexColor('#DBDBDB'),
        ),
      ),
      child: TextField(
        maxLines: 5,
        onChanged: (value) =>
            serviceRequestProvider.updateIsServiceRequestFormValidated(),
        controller: serviceRequestProvider.issueDescriptionController,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: Constants.issueDescription,
          hintStyle: FontPalette.black15Regular,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
      ),
    );
  }
}
