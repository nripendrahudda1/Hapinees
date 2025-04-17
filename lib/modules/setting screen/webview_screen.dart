import 'package:flutter/material.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreeen extends StatefulWidget {
  final String url;
  final String appbarTitle;
  const WebViewScreeen(
      {super.key, required this.url, required this.appbarTitle});

  @override
  State<WebViewScreeen> createState() => _WebViewScreeenState();
}

class _WebViewScreeenState extends State<WebViewScreeen> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.appbarTitle,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
