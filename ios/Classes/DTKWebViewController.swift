//
//  DTKWebViewController.swift
//  my_webview
//
//  Created by wit on 2021/1/20.
//

import UIKit
import WebKit
import Foundation
import SnapKit

class DTKWebViewController: UIViewController {
    var url: String?
    
    var html: String?
    var useWebViewTitle = true
    
    var callback: ((String?)->())?
    
    lazy var webView = WKWebView()
    
    lazy var progressView: UIView = {
        let tView = UIView()
        tView.frame = CGRect(x: 0, y: 0, width: 0, height: 2)
        tView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.progressBackView.addSubview(tView)
        return tView
    }()
    
    lazy var progressBackView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = .clear
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        webView.backgroundColor = .white
        
        let img = UIImage(named: "Frameworks/my_webview.framework/flutter_native_webview.bundle/icon_nav_back_gray")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(popVC))
        view.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(progressBackView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new, .old], context: nil)
        webView.addObserver(self, forKeyPath: "title", options: [.new, .old], context: nil)
        
        webView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if #available(iOS 11.0, *) {
                make.bottom.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        progressBackView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(webView)
            make.height.equalTo(2)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
    }
    
    func loadWebView() {
        if let htmlString = html {
            webView.loadHTMLString(htmlString, baseURL: nil)
            return
        }
        guard let urlString = url, let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func updateTitle() {
        if useWebViewTitle {
            title = webView.title
        }
    }
    
    deinit {
        if isViewLoaded {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            webView.removeObserver(self, forKeyPath: "title")
        }
    }
    
    @objc func popVC() {
        dismiss(animated: true) {
            self.callback?("{\"code\": \"4\",\"msg\":\"\"}")
        }
    }
}

extension DTKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let link = navigationAction.request.url?.absoluteString {
            // 拼多多授权成功
            if link.hasPrefix("https://mobile.yangkeduo.com/duo_cms_mall.html") {
                self.callback?("{\"code\": \"5\",\"msg\":\"拼多多授权成功\"}")
                decisionHandler(.cancel)
                return
            } else if link.contains("https://www.dataoke.com/pmc/oauth-info.html") {
                self.callback?("{\"code\": \"6\",\"msg\":\"淘宝授权成功\"}")
                decisionHandler(.cancel)
                return
            }
            
            if link.hasPrefix("tbopen://") ||
                link.hasPrefix("itms-apps") ||
                link.hasPrefix("alipay://") ||
                link.hasPrefix("imeituan://") ||
                link.contains("itunes.apple.com/app"),
               let url = URL(string: link),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateTitle()
        
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';",
                                   completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //        handleError(error)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.cancelWebProgress()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var credential: URLCredential?
        if let trust = challenge.protectionSpace.serverTrust {
            credential = URLCredential(trust: trust)
        }
        completionHandler(.useCredential, credential)
    }
}

extension DTKWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != true {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
    
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
}

extension DTKWebViewController {
    // MARK: 更新进度条
    func updateWebProgress(progress: Float) {
        let progressWidth = self.progressBackView.frame.size.width * CGFloat(progress)
        self.progressView.alpha = 1
        self.view.bringSubviewToFront(self.progressBackView)
        UIView.animate(withDuration: 0.2, animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: progressWidth, height: 2)
            if progress >= 1 {
                self.progressView.alpha = 0
            }
        }) { (_) in
            if progress >= 1 {
                self.cancelWebProgress()
            }
        }
    }
    
    // MARK: 取消进度条进度
    func cancelWebProgress() {
        self.progressView.alpha = 0
        self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: 2)
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else {
            return
        }
        switch key {
        case "estimatedProgress":
            handleWebViewProgress(change: change)
        case "title":
            updateTitle()
        default:
            break
        }
    }
    
    //处理WebView进度条
    func handleWebViewProgress(change: [NSKeyValueChangeKey : Any]?) {
        guard let changeValue = change else {
            return
        }
        let newProgress = (changeValue[.newKey] as? NSNumber)?.floatValue ?? Float(0.0)
        let oldProgress = (changeValue[.oldKey] as? NSNumber)?.floatValue ?? Float(0.0)
        if newProgress < oldProgress {
            return
        }
        self.updateWebProgress(progress: newProgress)
    }
}
