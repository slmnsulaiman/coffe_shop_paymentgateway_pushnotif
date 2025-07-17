import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/snap_controller.dart';

class SnapView extends GetView<SnapController> {
  const SnapView({super.key});

  @override
  Widget build(BuildContext context) {
    final url = Get.arguments['url']; // Ambil URL dari argument Get.to()

    final webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final currentUrl = request.url;

            if (currentUrl.contains('status_code=200')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pembayaran berhasil")),
              );

              // Navigasi ke HOME (seperti Cash)
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.offAllNamed(Routes.HOME); // Ganti sesuai route kamu
              });
            } else if (currentUrl.contains('status_code=202')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pembayaran dibatalkan")),
              );
              Get.back();
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: WebViewWidget(controller: webController),
    );
  }
}
