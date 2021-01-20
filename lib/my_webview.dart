
import 'dart:async';

import 'package:flutter/services.dart';

class MyWebview {
  static const MethodChannel _channel = const MethodChannel('my_webview');
  /// 声明监听回调通道
  static const EventChannel _eventChannel = const EventChannel('my_webview/event');

  //打开网页
  static Future<String> openUrl(url,{userAgent=""}) async {
    final String version = await _channel.invokeMethod('openUrl',{"url":url,"userAgent":userAgent});
    return version;
  }

  //数据监听
  static webListen({Function onEvent, Function onError}) async {
    assert(onEvent != null);
    _eventChannel.receiveBroadcastStream(true).listen(onEvent, onError: onError);
  }
}
