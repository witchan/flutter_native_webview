#import "MyWebviewPlugin.h"
#if __has_include(<my_webview/my_webview-Swift.h>)
#import <my_webview/my_webview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "my_webview-Swift.h"
#endif

@implementation MyWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMyWebviewPlugin registerWithRegistrar:registrar];
}
@end
