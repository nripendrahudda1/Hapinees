import 'package:flutter/material.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlViewScreen extends StatefulWidget {
  final String data;
  final String appbarTitle;
  const HtmlViewScreen(
      {super.key, required this.data, required this.appbarTitle});

  @override
  State<HtmlViewScreen> createState() => _WebViewScreeenState();
}

class _WebViewScreeenState extends State<HtmlViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.appbarTitle,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
          child: Html(data: widget.data, shrinkWrap: true)),
    );
  }
}
