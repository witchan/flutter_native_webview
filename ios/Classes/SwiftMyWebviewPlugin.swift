import Flutter
import UIKit

public class SwiftMyWebviewPlugin: NSObject, FlutterPlugin {
    
    //    var flutterResult: FlutterResult?
    static var eventChannel: FlutterEventChannel?
    static var sink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "my_webview", binaryMessenger: registrar.messenger())
        let instance = SwiftMyWebviewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        eventChannel = FlutterEventChannel(name: "my_webview/event", binaryMessenger: (UIApplication.shared.delegate as? FlutterAppDelegate )?.window.rootViewController as! FlutterBinaryMessenger)
        eventChannel!.setStreamHandler(instance)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "openUrl" {
            guard let params = call.arguments as? [String: Any], let url = params["url"] as? String  else {
                return
            }
            let vc = DTKWebViewController()
            vc.url = url
            vc.callback = {(msg) in
                SwiftMyWebviewPlugin.sink?(msg)
            }
            let navi = UINavigationController(rootViewController: vc)
            let rootVC = UIApplication.shared.keyWindow!.rootViewController!
            
            navi.modalPresentationStyle = .custom
            navi.transitioningDelegate = FLTransitionManager.shared
            rootVC.present(navi, animated: true, completion: nil)
        } else {
            result("0")
        }
    }
}

extension SwiftMyWebviewPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        SwiftMyWebviewPlugin.sink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    
}
