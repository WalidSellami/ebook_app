import 'package:ebook/shared/components/Components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String? url;

  const WebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0xff151d24))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {},
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {
                if (kDebugMode) {
                  print('WebView error: ${error.description}');
                  showFlutterToast(message: error.description.toString(), state: ToastStates.error, context: context);
                }
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('http://') ||
                    request.url.startsWith('https://')) {
                  return NavigationDecision.navigate;
                }
                  return NavigationDecision.prevent;
                }
            ),
          )
          ..loadRequest(Uri.parse(url!)),
      ),
    );
  }
}