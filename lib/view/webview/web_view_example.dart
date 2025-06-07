import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setVerticalScrollBarEnabled(true)
          ..setNavigationDelegate(
            NavigationDelegate(
              onWebResourceError: (error) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to load: ${error.description}"),
                  ),
                );
              },
              onPageFinished: (url) {
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                });
              },
              onNavigationRequest: (request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            headers: {
              'Upgrade-Insecure-Requests': '1',
              'Connection': 'keep-alive',
            },
            Uri.parse('https://theflutterdev.com/'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (isLoading) Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _handleBackNavigation() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }
}
