import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';

class WarrantyStatusWidget extends StatelessWidget {
  const WarrantyStatusWidget({Key? key, required this.serviceRequestProvider})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  @override
  Widget build(BuildContext context) {
    return Selector<ServiceRequestProvider, String>(
      selector: (context, serviceRequestProvider) =>
          serviceRequestProvider.warrantyStatus ?? '',
      builder: (context, value, child) {
        return serviceRequestProvider.warrantStatusList.notEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Under warrenty:',
                    style: FontPalette.black15Medium,
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      CustomRadioButton(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[0].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        isSelected: value ==
                            (serviceRequestProvider
                                    .warrantStatusList[0].value ??
                                ''),
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[0].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        child: Text(
                          serviceRequestProvider.warrantStatusList[0].label ??
                              '',
                          style: FontPalette.black15Regular,
                        ),
                      ).removeSplash(),
                      24.horizontalSpace,
                      CustomRadioButton(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[1].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        isSelected: value ==
                            serviceRequestProvider.warrantStatusList[1].value,
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[1].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        child: Text(
                          serviceRequestProvider.warrantStatusList[1].label ??
                              '',
                          style: FontPalette.black15Regular,
                        ),
                      ).removeSplash(),
                    ],
                  ),
                  15.verticalSpace,
                  Row(
                    children: [
                      CustomRadioButton(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[2].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        isSelected: value ==
                            serviceRequestProvider.warrantStatusList[2].value,
                      ),
                      5.horizontalSpace,
                      InkWell(
                        onTap: () => serviceRequestProvider
                          ..updateWarrantyStatus(serviceRequestProvider
                                  .warrantStatusList[2].value ??
                              '')
                          ..updateIsServiceRequestFormValidated(),
                        child: Text(
                          serviceRequestProvider.warrantStatusList[2].label ??
                              '',
                          style: FontPalette.black15Regular,
                        ),
                      ).removeSplash()
                    ],
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
