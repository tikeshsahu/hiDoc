import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'dart:html' as html;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url});

  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String? finalUrl;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      finalUrl = widget.url;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: WebView(
          initialUrl: finalUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController WebViewController) {
            setState(() {
              controller.complete(WebViewController);
            });
          },
        ),
      );
    } else {
      //html.window.open(finalUrl!, "_self");
    }
    return Container();
  }
}
