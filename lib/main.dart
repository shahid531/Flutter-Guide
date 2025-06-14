import 'package:flutter/material.dart';
import 'package:flutter_guide/view/webview/web_view_example.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WebViewExample());
  }
}
