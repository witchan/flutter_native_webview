package com.buydance.my_webview

import android.webkit.JavascriptInterface
import org.greenrobot.eventbus.EventBus

class AndroidInterface(private val listener:WebJsInterfaceCallback) {
    @JavascriptInterface
    fun postMessage(msg: String) {
        val eventBusBean = EventBusBean(EventBusCode.JS_MSG)
        eventBusBean.stringValue=msg
        EventBus.getDefault().post(eventBusBean)
//        listener.JsCallAndroid(msg)
    }
}