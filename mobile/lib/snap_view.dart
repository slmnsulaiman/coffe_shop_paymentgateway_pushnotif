import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapView extends StatelessWidget {
  final String url;

  const SnapView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.contains('status_code=200')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pembayaran berhasil")),
              );
              Navigator.of(context).pop();
            } else if (url.contains('status_code=202')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pembayaran dibatalkan")),
              );
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: WebViewWidget(controller: controller),
    );
  }
}
