import '../common/constants.dart';
import 'service_config.dart';

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoaderState loaderState = LoaderState.loaded;
  int apiCallCount = 0;
  bool btnLoaderState = false;

  void pageInit() {}

  void pageDispose() {}

  void updateApiCallCount() {}

  void updateBtnLoaderState(bool val) {}

  void updateLoadState(LoaderState state);

  LoaderState fetchError(ApiExceptions exceptions) {
    Map<ApiExceptions, LoaderState> errorState = {
      ApiExceptions.networkError: LoaderState.networkErr,
    };
    return errorState[exceptions] ?? LoaderState.loaded;
  }

//updateLoaderState(fetchError(res.asError!.error as Exceptions));
}
