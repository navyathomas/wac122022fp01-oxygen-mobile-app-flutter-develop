import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_text_form_field.dart';

class IssueTitleWidget extends StatelessWidget {
  const IssueTitleWidget({Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: serviceRequestProvider.issueTitleController,
      hintText: Constants.issueTitle,
      hintStyle: FontPalette.black15Regular,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: HexColor("#DBDBDB"),
        ),
      ),
      onChanged: (value) =>
          serviceRequestProvider.updateIsServiceRequestFormValidated(),
    );
  }
}
