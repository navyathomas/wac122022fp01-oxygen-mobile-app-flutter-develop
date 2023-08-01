import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/common_function.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/utils/color_palette.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/views/job_tracking/track_jobs_detail/widgets/o2_care.dart';
import 'package:oxygen/views/product_listing/widgets/compare_product_list_view.dart';
import 'package:oxygen/views/service_request/widgets/add_photos_widget.dart';
import 'package:oxygen/views/service_request/widgets/brand_type_widget.dart';
import 'package:oxygen/views/service_request/widgets/category_type_widget.dart';
import 'package:oxygen/views/service_request/widgets/issue_description_widget.dart';
import 'package:oxygen/views/service_request/widgets/issue_title_widget.dart';
import 'package:oxygen/views/service_request/widgets/model_widget.dart';
import 'package:oxygen/views/service_request/widgets/pick_up_address_widget.dart';
import 'package:oxygen/views/service_request/widgets/product_from_widget.dart';
import 'package:oxygen/views/service_request/widgets/select_district_widget.dart';
import 'package:oxygen/views/service_request/widgets/send_request_button.dart';
import 'package:oxygen/views/service_request/widgets/serial_number_widget.dart';
import 'package:oxygen/views/service_request/widgets/service_request_type_widget.dart';
import 'package:oxygen/views/service_request/widgets/store_widget.dart';
import 'package:oxygen/views/service_request/widgets/warranty_status_widget.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:oxygen/widgets/custom_drop_down.dart';
import 'package:oxygen/widgets/custom_radio_button.dart';
import 'package:oxygen/widgets/custom_text_form_field.dart';
import 'package:oxygen/widgets/whatsapp_chat_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen(
      {Key? key, this.orderId, this.itemId, this.isDemoRequest})
      : super(key: key);
  final String? orderId;
  final String? itemId;
  final bool? isDemoRequest;
  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  late ServiceRequestProvider serviceRequestProvider;
  @override
  void initState() {
    initFunction();
    super.initState();
  }

  initFunction() {
    serviceRequestProvider = ServiceRequestProvider();
    serviceRequestProvider.updateIsDemoRequest((widget.isDemoRequest ?? false));
    CommonFunctions.afterInit(() {
      if ((widget.isDemoRequest ?? false)) {
        serviceRequestProvider.getServiceRequestDemoData(
            widget.orderId ?? '', widget.itemId ?? '');
      } else {
        serviceRequestProvider.getServiceRequestData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const WhatsappChatWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: CommonAppBar(
        buildContext: context,
        pageTitle: (widget.isDemoRequest ?? false)
            ? Constants.demoRequest
            : Constants.serviceRequest,
        actionList: const [],
      ),
      body: ChangeNotifierProvider.value(
        value: serviceRequestProvider,
        child: SafeArea(
            child: Selector<ServiceRequestProvider, Tuple2<LoaderState, bool>>(
          selector: (context, serviceRequestProvider) => Tuple2(
              serviceRequestProvider.loaderState,
              serviceRequestProvider.isDemoRequest),
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: value.item1 == LoaderState.loading
                  ? const CommonLinearProgress()
                  : Column(
                      children: [
                        const O2Care(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 18.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CategoryTypeWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              BrandTypeWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              ModelWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              SerialNumberWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              IssueTitleWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              IssueDescriptionWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              12.verticalSpace,
                              ServiceRequestTypeWidget(
                                serviceRequestProvider: serviceRequestProvider,
                              ),
                              18.verticalSpace,
                              Selector<ServiceRequestProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isBringToBranchSelected,
                                builder: (context, value, child) {
                                  return Column(
                                    children: [
                                      value
                                          ? SelectDistrictWidget(
                                              serviceRequestProvider:
                                                  serviceRequestProvider)
                                          : PickUpAddressWidget(
                                              serviceRequestProvider:
                                                  serviceRequestProvider),
                                      if (value) 12.verticalSpace,
                                      if (value)
                                        StoreWidget(
                                            serviceRequestProvider:
                                                serviceRequestProvider),
                                    ],
                                  );
                                },
                              ),
                              if (!value.item2) 22.verticalSpace,
                              if (!value.item2)
                                ProductFromWidget(
                                    serviceRequestProvider:
                                        serviceRequestProvider),
                              18.verticalSpace,
                              WarrantyStatusWidget(
                                  serviceRequestProvider:
                                      serviceRequestProvider),
                              20.verticalSpace,
                              AddPhotosWidget(
                                serviceRequestProvider: serviceRequestProvider,
                              ),
                              32.verticalSpace,
                              SendRequestButton(
                                serviceRequestProvider: serviceRequestProvider,
                                buildContext: context,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        )),
      ),
    );
  }

  @override
  void dispose() {
    serviceRequestProvider.dispose();
    super.dispose();
  }
}
