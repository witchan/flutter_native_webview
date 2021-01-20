
import 'dart:async';

import 'package:flutter/services.dart';

class MyWebview {
  static const MethodChannel _channel =
      const MethodChannel('my_webview');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
