package com.buydance.my_webview
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity
import com.just.agentweb.AgentWeb
import com.just.agentweb.DefaultWebClient
import com.just.agentweb.WebChromeClient
import com.just.agentweb.WebViewClient
import kotlinx.android.synthetic.main.my_webview_layout.*


class MyWebActivity :AppCompatActivity() {
    private var mAgentWeb: AgentWeb?=null

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
                .go(getUrl())

        val settings = mAgentWeb?.getAgentWebSettings()?.webSettings
        settings?.useWideViewPort = true
        settings?.loadWithOverviewMode = true
//        mAgentWeb.getJsInterfaceHolder().addJavaObject("android",new AndroidInterface(mAgentWeb,this));
        mAgentWeb!!.jsInterfaceHolder.addJavaObject("",AndroidInterface())
    }


    private fun setListener() {
        toolbar.setNavigationOnClickListener({ v -> finish() })
    }

    fun getUrl(): String? {
        return "https://act6.meituan.com/clover/page/adunioncps/share_coupon_new?activity=yknUrA9Rrx&utmSource=64195&utmMedium=CEACD199E93C743251E591A8D48241616AA5DC53530BCCC4D102AEE5F85C2FC7&promotionId=20345"
    }

    private val mWebViewClient: WebViewClient = object : WebViewClient() {
//        override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
//            return super.shouldOverrideUrlLoading(view, request)
//        }
//
//        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
//
//        }

        override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
            return super.shouldOverrideUrlLoading(view, request)
        }

        override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
            super.onPageStarted(view, url, favicon)
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

    override fun onPause() {
        mAgentWeb!!.webLifeCycle.onPause()
        super.onPause()
    }

    override fun onResume() {
        mAgentWeb!!.webLifeCycle.onResume()
        super.onResume()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        Log.i("Info", "onResult:$requestCode onResult:$resultCode")
        super.onActivityResult(requestCode, resultCode, data)
    }


    override fun onDestroy() {
        super.onDestroy()
        //mAgentWeb.destroy();
        mAgentWeb!!.webLifeCycle.onDestroy()
    }
}