import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:byyu/constants/color_constants.dart';

class WebViewScreen extends StatefulWidget {
  final String url; // 👈 just pass your URL

  const WebViewScreen({
    super.key,
    required this.url,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            debugPrint("Loading Progress = $progress%");
          },
          onPageStarted: (url) {
            setState(() => _loading = true);
          },
          onPageFinished: (url) {
            setState(() => _loading = false);

            // ********* PAYMENT STATUS CHECK *********
            final lowerUrl = url.toLowerCase();

            if (lowerUrl.contains("failed")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Payment failed. Please try again!")),
              );
              Navigator.pop(context);
            }

            if (lowerUrl.contains("success")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Successful")),
              );

              // extract SIID from URL (optional)
              String siid = url.split("/").last;
              debugPrint("SIID: $siid");

              // TODO: navigate to order success page
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        title: Text(
          widget.url.contains("thegiftscatalog") ? "Catalog" : "Web View",
          style: const TextStyle(
            color: ColorConstants.newAppColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
