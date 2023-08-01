import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/route_generator.dart';
import 'package:oxygen/providers/service_request_provider.dart';
import 'package:oxygen/services/helpers.dart';
import 'package:oxygen/utils/font_palette.dart';
import 'package:oxygen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

class SendRequestButton extends StatelessWidget {
  const SendRequestButton(
      {Key? key,
      required this.serviceRequestProvider,
      required this.buildContext})
      : super(key: key);
  final ServiceRequestProvider serviceRequestProvider;
  final BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    return Selector<ServiceRequestProvider, bool>(
      selector: (context, provider) => provider.isServiceRequestFormValidated,
      builder: (context, value, child) {
        return CustomButton(
          enabled: value,
          title: Constants.sendRequest,
          width: double.maxFinite,
          fontStyle: FontPalette.white13Medium,
          isLoading: false,
          onPressed: () => serviceRequestProvider.sendRequest(
            onSuccess: () {
              Navigator.pushNamedAndRemoveUntil(
                  buildContext, RouteGenerator.routeTrackJobScreen,
                  arguments: 1, (route) {
                debugPrint('route ${route.settings.name}');
                return route.isFirst;
              }).then((value) =>
                  serviceRequestProvider.updateLoadState(LoaderState.loaded));
              serviceRequestProvider.clearValues();
            },
            onFailure: () => Helpers.flushToast(buildContext,
                msg: serviceRequestProvider.errorMessage),
          ),
        );
      },
    );
  }
}
