import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/common/extensions.dart';
import 'package:oxygen/providers/payment_provider.dart';
import 'package:oxygen/services/app_config.dart';
import 'package:oxygen/widgets/common_appbar.dart';
import 'package:oxygen/widgets/common_linear_progress.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView(
      {Key? key,
      required this.actionUrl,
      required this.paymentProvider,
      this.title = ''})
      : super(key: key);
  final String actionUrl;
  final PaymentProvider paymentProvider;
  final String title;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final PlatformWebViewControllerCreationParams params;
  late WebViewController webViewController;

  // @override
  // void dispose() {
  //   widget.paymentProvider.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    webViewController = WebViewController.fromPlatformCreationParams(params);
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            widget.paymentProvider.updateBtnLoaderState(true);
          },
          onPageFinished: (String url) {
            widget.paymentProvider.updateBtnLoaderState(false);
            /*if (url.toLowerCase().contains("https://api.payu.in/hdfc/")) {
              Navigator.pushReplacementNamed(
                  context, RouteGenerator.routeOrderCompleteScreen,
                  arguments: OrderCompleteArguments(
                      paymentProvider: widget.paymentProvider));
            }*/
            if (url
                    .toLowerCase()
                    .contains("${AppConfig.baseUrl}payment-reciept-callback") &&
                url.toLowerCase().contains("status")) {
              Uri uri = Uri.parse(url);
              Map? value = uri.queryParameters;
              if (value['status'] == '1') {
                Navigator.pop(context, 1);
              } else {
                Navigator.pop(context, 0);
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('message $message');
        },
      )
      ..loadRequest(
        Uri.parse(widget.actionUrl),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: widget.title,
          onBackPressed: () => Navigator.pop(context, 0),
          actionList: const [],
        ),
        body: WillPopScope(
          onWillPop: () => onWillPop(),
          child: SafeArea(
              child: ChangeNotifierProvider.value(
                  value: widget.paymentProvider,
                  child:
                      //WebViewWidget(controller: webViewController))
                      Column(
                    children: [
                      WidgetExtension.crossSwitch(
                          first: const CommonLinearProgress(),
                          value: widget.paymentProvider.btnLoaderState),
                      Expanded(
                          child: WebViewWidget(controller: webViewController)),
                    ],
                  ))),
        ));
  }

  Future<bool> onWillPop() async {
    Navigator.pop(context, 0);
    return false;
  }
}
