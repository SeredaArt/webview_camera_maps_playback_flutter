import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Elephants Dream'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controllerWeb;
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    _controller = TextEditingController();
    _controllerWeb = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            _isLoading = true;
            setState(() {});
          },
          onPageFinished: (String url) {
            _isLoading = false;
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _fowardEnable() async {
    return await _controllerWeb.canGoForward();
  }

  Future<bool> _backEnable() async {
    return await _controllerWeb.canGoBack();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Введите адрес',
                ),
                onSubmitted: (url) {
                  _controllerWeb.loadRequest(Uri.parse(url));
                },
              ),
              actions: [
                FutureBuilder(
                    future: _backEnable(),
                    builder: (context, snapshot) {
                      bool backEnable = snapshot.data ?? false;
                      return IconButton(
                        onPressed: () {
                          backEnable ? _controllerWeb.goBack() : ();
                        },
                        icon: backEnable
                            ? const Icon(Icons.replay_10)
                            : const Icon(Icons.replay_10, color: Colors.grey),
                      );
                    }),
                FutureBuilder(
                    future: _fowardEnable(),
                    builder: (context, snapshot) {
                      bool forwardEnable = snapshot.data ?? false;
                      return IconButton(
                        onPressed: () {
                          forwardEnable ? _controllerWeb.goForward() : ();
                        },
                        icon: forwardEnable
                            ? const Icon(Icons.forward_10)
                            : const Icon(Icons.forward_10, color: Colors.grey),
                      );
                    }),
                IconButton(
                    onPressed: () {
                      _controllerWeb.reload();
                    },
                    icon: _isLoading
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.refresh)),
              ]),
          body: WebViewWidget(controller: _controllerWeb)),
    );
  }
}
