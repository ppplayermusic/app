import Foundation
import WebKit

extension WKWebView {
    private static var hasSwizzledHasActive = false
    
    @objc static func swizzleHasActiveNowPlayingSession() {
        guard !hasSwizzledHasActive else { return }
        hasSwizzledHasActive = true
        let orig = NSSelectorFromString("_setHasActiveNowPlayingSession:")
        let swiz = #selector(swizzled_setHasActiveNowPlayingSession(_:))
        
        if let origMethod = class_getInstanceMethod(WKWebView.self, orig),
           let swizMethod = class_getInstanceMethod(WKWebView.self, swiz) {
            method_exchangeImplementations(origMethod, swizMethod)
            print("Swizzled _setHasActiveNowPlayingSession:")
        } else {
            print("Failed to find _setHasActiveNowPlayingSession:")
        }
    }
    
    @objc func swizzled_setHasActiveNowPlayingSession(_ active: Bool) {
        print("INTERCEPTED _setHasActiveNowPlayingSession: \(active)")
        swizzled_setHasActiveNowPlayingSession(false) // Optionally force it to false
    }
}

WKWebView.swizzleHasActiveNowPlayingSession()
