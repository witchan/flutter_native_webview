package com.buydance.my_webview
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Browser
import android.text.TextUtils
import android.util.Log
import android.view.KeyEvent
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.widget.LinearLayout
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.just.agentweb.AgentWeb
import com.just.agentweb.DefaultWebClient
import com.just.agentweb.WebChromeClient
import com.just.agentweb.WebViewClient
import kotlinx.android.synthetic.main.my_webview_layout.*
import org.greenrobot.eventbus.EventBus
import org.json.JSONObject


class MyWebActivity :AppCompatActivity(), WebJsInterfaceCallback {
    private var mAgentWeb: AgentWeb?=null
//    private val schemeList= listOf("imeituan","alipay","weixin://wap/pay")
    private val schemeList= listOf("alipay")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.my_webview_layout)
        toolbar.setTitleTextColor(Color.WHITE)
        toolbar.setTitle("")
        this.setSupportActionBar(toolbar)
        if (null!=supportActionBar) supportActionBar!!.setDisplayHomeAsUpEnabled(true)
        initAgentWeb()
        setListener()
    }

    private fun initAgentWeb() {
        mAgentWeb = AgentWeb.with(this)
                .setAgentWebParent(container, LinearLayout.LayoutParams(-1, -1))
                .useDefaultIndicator()
                .setWebChromeClient(mWebChromeClient)
                .setWebViewClient(mWebViewClient)
                .setMainFrameErrorView(R.layout.agentweb_error_page, -1)
                .setSecurityType(AgentWeb.SecurityType.STRICT_CHECK)
                .setOpenOtherPageWays(DefaultWebClient.OpenOtherPageWays.ASK)
                .interceptUnkownUrl()
                .createAgentWeb()
                .ready()
                .go(intent.getStringExtra("url"))

        val settings = mAgentWeb?.getAgentWebSettings()?.webSettings
        settings?.useWideViewPort = true
        settings?.loadWithOverviewMode = true
//        mAgentWeb.getJsInterfaceHolder().addJavaObject("android",new AndroidInterface(mAgentWeb,this));
        mAgentWeb!!.jsInterfaceHolder.addJavaObject("JSBridge",AndroidInterface(this))
    }

    //js调用Android
    override fun JsCallAndroid(msg: String) {
        try {
            if (!TextUtils.isEmpty(msg)){
//                var json = jsonDecode(msg);
//                var jump_type = json["jump_type"];
//                switch(jump_type){
//                    case 9:  //关闭页面
//                    EventBusUtil.getInstance().fire(EventBusBean(SEND_WEB_CLOSE_MSG));
//                    pop(ctx);
//                    break;
//                    case 1:  //打开app淘宝详情页面
//                    push(ctx, RouterAddress.TAOBAO_GOODS_DETAIL,params: {"goodsId":json["gid"].toString()});
//                    break;
//                    case 2:// 下单攻略h5点击底部按钮
//                    toOneCentPage();
//                    break;
//                    case 3: //预约攻略页面点击底部按钮 未登录的话先跳转到一键登录  出现蒙层引导
//                    clickAppointeStrategy=true;
//                    if(noLoginToLoginPage(ctx)){
//                        toPackageHomeTab();
//                    }
//                    break;
//                    case 4:  //跳转地址选择页面（加盟申请来的，要去选择小区地址）
//                    push(ctx, RouterAddress.CHOOSE_ADDR, params: {"content":"","city":"","isWeb":true});
//                    break;
                val eventBusBean = EventBusBean(EventBusCode.JS_MSG)
                eventBusBean.stringValue=msg
                EventBus.getDefault().post(eventBusBean)
                val jsonObject = JSONObject(msg)
                val jump_type = jsonObject.optInt("jump_type")
                when(jump_type){
                    //关闭页面
                    9->finish()
                }
            }
        }catch (e:Exception){ }
    }

    private fun setListener() {
        toolbar.setNavigationOnClickListener({ v -> finish() })
    }

    private val mWebViewClient: WebViewClient = object : WebViewClient() {
        @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
        override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
            val url = request?.url.toString()
            //scheme打开页面
            if (schemeList.contains(url)){
                val intent = Intent()
                intent.setData(Uri.parse(url))
                startActivity(intent)
            }
            //拼多多商城页面，视为授权成功
            if(url.startsWith("https://mobile.yangkeduo.com/duo_cms_mall.html")){
                EventBus.getDefault().post(EventBusBean(EventBusCode.PDD_AUTH_SUCCESS))
                finish()
            }
            //淘宝授权成功
            if (url.startsWith("https://www.dataoke.com/pmc/oauth-info.html")){
                EventBus.getDefault().post(EventBusBean(EventBusCode.TB_AUTH_SUCCESS))
                finish()
            }
            return super.shouldOverrideUrlLoading(view, request)
        }

        override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
            super.onPageStarted(view, url, favicon)
        }

        override fun onPageFinished(view: WebView?, url: String?) {
            super.onPageFinished(view, url)

        }
    }



    private val mWebChromeClient: WebChromeClient = object : WebChromeClient() {
        override fun onReceivedTitle(view: WebView, title: String) {
            super.onReceivedTitle(view, title)
            if (toolbar_title != null) {
                toolbar_title.setText(title)
            }
        }
    }
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return if (mAgentWeb!!.handleKeyEvent(keyCode, event)) {
            true
        } else super.onKeyDown(keyCode, event)
    }

    override fun onPause() {
        mAgentWeb!!.webLifeCycle.onPause()
        super.onPause()
    }

    override fun onResume() {
        mAgentWeb!!.webLifeCycle.onResume()
        super.onResume()
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().post(EventBusBean(EventBusCode.WEB_CLOSE))
        mAgentWeb!!.webLifeCycle.onDestroy()
    }
}