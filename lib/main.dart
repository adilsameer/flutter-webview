import 'dart:html';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Webview',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(
          title: 'Webview Example', url: 'https://github.com/adilsameer/'),
    );
  }
}

// below class helps you prevent from exiting from app when back pressed

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url});

  final String title;
  final String url;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  // below class control your webview widget

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: WebView(
          key: UniqueKey(),
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) => _controller = value);
            _controllerCompleter.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        )),
      ),
    );
  }
}

// Note: You also require some permissions in Android and IOS make sure you give them otherwise you will get error
