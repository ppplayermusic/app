import WebKit
import ObjectiveC

@objc public class DumpMethods: NSObject {
    @objc public static func dump() {
        var count: UInt32 = 0
        
        print("--- WKPreferences ---")
        if let methods = class_copyMethodList(WKPreferences.self, &count) {
            for i in 0..<Int(count) {
                let selector = method_getName(methods[i])
                let name = NSStringFromSelector(selector)
                if name.lowercased().contains("media") || name.lowercased().contains("nowplaying") || name.lowercased().contains("session") || name.lowercased().contains("audio") {
                    print(name)
                }
            }
            free(methods)
        }
        
        print("--- WKWebViewConfiguration ---")
        if let methods = class_copyMethodList(WKWebViewConfiguration.self, &count) {
            for i in 0..<Int(count) {
                let selector = method_getName(methods[i])
                let name = NSStringFromSelector(selector)
                if name.lowercased().contains("media") || name.lowercased().contains("nowplaying") || name.lowercased().contains("session") || name.lowercased().contains("audio") {
                    print(name)
                }
            }
            free(methods)
        }
        
        print("--- WKWebView ---")
        if let methods = class_copyMethodList(WKWebView.self, &count) {
            for i in 0..<Int(count) {
                let selector = method_getName(methods[i])
                let name = NSStringFromSelector(selector)
                if name.lowercased().contains("media") || name.lowercased().contains("nowplaying") || name.lowercased().contains("session") || name.lowercased().contains("audio") {
                    print(name)
                }
            }
            free(methods)
        }
    }
}
