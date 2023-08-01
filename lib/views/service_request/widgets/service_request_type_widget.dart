import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

class ServiceRequestTypeWidget extends StatelessWidget {
  const ServiceRequestTypeWidget(
      {Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return Selector<ServiceRequestProvider, bool>(
      selector: (context, serviceRequestProvider) =>
          serviceRequestProvider.isBringToBranchSelected,
      builder: (context, value, child) {
        return serviceRequestProvider.serviceRequestTypeList.notEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Constants.serviceRequestType,
                    style: FontPalette.black15Medium,
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      CustomRadioButton(
                        onTap: () => serviceRequestProvider
                          ..updateIsBringToBranch(false)
                          ..updateServiceRequest(serviceRequestProvider
                                  .serviceRequestTypeList[0].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        isSelected: !value,
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => serviceRequestProvider
                          ..updateIsBringToBranch(false)
                          ..updateServiceRequest(serviceRequestProvider
                                  .serviceRequestTypeList[0].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        child: Text(
                          serviceRequestProvider
                                  .serviceRequestTypeList[0].label ??
                              '',
                          style: FontPalette.black15Regular,
                        ),
                      ).removeSplash(),
                      24.horizontalSpace,
                      CustomRadioButton(
                        onTap: () => serviceRequestProvider
                          ..clearSelectDistrictAndStore()
                          ..updateIsBringToBranch(true)
                          ..updateServiceRequest(serviceRequestProvider
                                  .serviceRequestTypeList[1].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        isSelected: value,
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => serviceRequestProvider
                          ..clearSelectDistrictAndStore()
                          ..updateIsBringToBranch(true)
                          ..updateServiceRequest(serviceRequestProvider
                                  .serviceRequestTypeList[1].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        child: Text(
                          serviceRequestProvider
                                  .serviceRequestTypeList[1].label ??
                              '',
                          style: FontPalette.black15Regular,
                        ),
                      ).removeSplash()
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
