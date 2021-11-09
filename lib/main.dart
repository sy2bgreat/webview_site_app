import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoding = true;
  String siteName = "www.daum.net";

  late TextEditingController _editingContorller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingContorller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Center(
          child: Column(
            children: [
              const Text("Web VIEW"),
              TextField(
                controller: _editingContorller,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.url,
                decoration:
                    const InputDecoration(hintText: "put the site's name"),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                siteName = _editingContorller.text;
                _controller.future
                    .then((value) => value.loadUrl('https://$siteName'));
              });
            },
            icon: const Icon(Icons.query_stats),
          )
        ],
        toolbarHeight: 100,
      ),
      body: Stack(children: [
        WebView(
          initialUrl: "https://$siteName",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageFinished: (finish) {
            setState(() {
              isLoding = false;
            });
          },
          onPageStarted: (start) {
            setState(() {
              isLoding = true;
            });
          },
        ),
        isLoding
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(),
      ]),
      floatingActionButton: FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.data!.goBack();
              },
            );
          }
          return Stack();
        },
      ),
    );
  }
}
