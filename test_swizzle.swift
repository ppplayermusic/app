import WebKit
import ObjectiveC

@objc class TestWKWebView: WKWebView {
    @objc dynamic func swizzled_setHasActiveNowPlayingSession(_ active: Bool) {
        print("Intercepted _setHasActiveNowPlayingSession: \(active)")
        // Do not call original to suppress it
    }
}
