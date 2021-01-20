import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:my_webview/my_webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                onPressed: (){
                  MyWebview.openUrl("http://deliver.haojiequ.com/dist/index.html?v=202101121428#/strategy");
                },
                child: Text("按钮"),
              ),
              RaisedButton(
                onPressed: (){
                  MyWebview.webListen(onEvent: (msg){
                    print("+++${msg}++++");
                  });
                },
                child: Text("数据监听"),
              )
            ],
          )
        ),
      ),
    );
  }
}
