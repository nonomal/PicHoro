import 'package:flutter/material.dart';
import 'package:horopic/widgets/common_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:horopic/utils/common_functions.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool enableJs;

  const WebViewPage({super.key, required this.url, required this.title, this.enableJs = false});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller.setJavaScriptMode(widget.enableJs ? JavaScriptMode.unrestricted : JavaScriptMode.disabled);
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        flexibleSpace: getFlexibleSpace(context),
        title: widget.title == 'None' ? titleText('网页浏览') : titleText(widget.title),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
