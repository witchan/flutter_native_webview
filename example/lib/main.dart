import 'dart:convert';

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
  var json="";

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
              Text(json),
              RaisedButton(
                onPressed: (){
                  // MyWebview.openUrl("http://deliver.haojiequ.com/dist/index.html?v=202101121428#/strategy");
                  // MyWebview.openUrl("https://m.ctrip.com/webapp/vacations/tour/around?allianceid=1301645&sid=3866139&ouid=1518239ae0aba0a186");
                  // MyWebview.openUrl("https://act6.meituan.com/clover/page/adunioncps/share_coupon_new?activity=OwMkGzn6oK&utmSource=64195&utmMedium=D2BE8C23340CFAD33F143CFD4CF75F88D573FF4D12BA4094BB1EE0A6C2BF5C7E&promotionId=21389");
                  MyWebview.openUrl("https://act6.meituan.com/clover/page/adunioncps/share_coupon_new?activity=yknUrA9Rrx&utmSource=64195&utmMedium=D2BE8C23340CFAD33F143CFD4CF75F88D573FF4D12BA4094BB1EE0A6C2BF5C7E&promotionId=20345");
                },
                child: Text("按钮"),
              ),
              RaisedButton(
                onPressed: (){
                  MyWebview.webListen(onEvent: (msg){
                    setState(() {
                      json=msg.toString();
                    });
                    //json 格式{"code":1,"msg":"{"jump_type":2}"}
                    var decode = jsonDecode(msg);
                    var code = decode["code"];
                    var m = decode["msg"];
                    print("返回数据：code:${code}   msg:${m}");
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
