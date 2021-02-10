import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String name;
  final String url;
  WebViewScreen({this.name, this.url});
  @override
  _WebViewScreenState createState() => new _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  InAppWebViewController webView;
  String url = "";
  String name = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    name = widget.name;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name + ' !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,  
        ),
        body: Container(
          child: Column(children: <Widget>[
            Container(
                padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl: url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                    )
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop: (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (webView != null) {
                      webView.goBack();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (webView != null) {
                      webView.goForward();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (webView != null) {
                      webView.reload();
                    }
                  },
                ),
              ],
            ),
        ])),
      ),
    );
  }
}