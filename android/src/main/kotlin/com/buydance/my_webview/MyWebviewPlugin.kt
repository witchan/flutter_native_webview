package com.buydance.my_webview

import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

/** MyWebviewPlugin */
class MyWebviewPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var channel : MethodChannel
  private var events: EventSink? = null
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_webview")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    val eventChannel = EventChannel(flutterPluginBinding.getBinaryMessenger(), "my_webview/event")
    eventChannel.setStreamHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "openUrl") {
      EventBus.getDefault().register(this)
     var intent= Intent(context,MyWebActivity::class.java)
      intent.flags=FLAG_ACTIVITY_NEW_TASK
      context.startActivity(intent)

    } else {
      result.notImplemented()
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    Log.e("qwer","onListenonListenonListenonListen")
    this.events=events
  }

  override fun onCancel(arguments: Any?) {
    if (null!=this.events) this.events=null
  }

  @Subscribe(threadMode = ThreadMode.MAIN)
  fun onEventReceiveMsg(eventBusBean: EventBusBean){
    when(eventBusBean.code){
      //js消息
      EventBusCode.JS_MSG->{
        Log.e("qwer","======${null==events}========"+eventBusBean.stringValue)
        events?.success(eventBusBean.stringValue)
      }
    }
  }
}
