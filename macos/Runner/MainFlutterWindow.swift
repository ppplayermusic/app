import Cocoa
import FlutterMacOS
import WebKit

class MainFlutterWindow: NSWindow, NSWindowDelegate {

  /// Timer used to locate the WKWebView once Flutter has built its widget tree.
  private var patchTimer: Timer?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    self.delegate = self

    super.awakeFromNib()

    // Start scanning for the WKWebView to inject our visibility patch.
    // Flutter creates WKWebViews lazily, so we poll until we find one.
    schedulePatchScan()
  }

  // MARK: - WKWebView visibility patch

  /// The JS to inject into EVERY frame (including cross-origin YouTube iframe).
  /// By overriding document.hidden + visibilityState at document start,
  /// YouTube's IFrame player always believes the page is visible and will
  /// not auto-pause when the window is hidden or the OS hides the view.
  private let visibilityPatchScript = """
    (function() {
      if (window.__ppVisibilityPatched) return;
      window.__ppVisibilityPatched = true;

      Object.defineProperty(document, 'hidden', {
        get: function() { return false; },
        configurable: true
      });
      Object.defineProperty(document, 'visibilityState', {
        get: function() { return 'visible'; },
        configurable: true
      });

      // Block visibilitychange from propagating so YouTube's handlers never fire.
      document.addEventListener('visibilitychange', function(e) {
        e.stopImmediatePropagation();
      }, true);
    })();
  """

  private func schedulePatchScan() {
    patchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
      guard let self = self else { timer.invalidate(); return }
      if self.injectPatches(into: self.contentView) {
        timer.invalidate()
        self.patchTimer = nil
        NSLog("[ppplayer] Visibility patch injected into WKWebView(s).")
      }
    }
  }

  /// Recursively walks the NSView tree and injects a WKUserScript into every
  /// WKWebView found. The script uses forMainFrameOnly: false so it also runs
  /// inside the cross-origin youtube-nocookie.com <iframe>.
  @discardableResult
  private func injectPatches(into view: NSView?) -> Bool {
    guard let view = view else { return false }
    var found = false

    if let webView = view as? WKWebView {
      let script = WKUserScript(
        source: visibilityPatchScript,
        injectionTime: .atDocumentStart,
        forMainFrameOnly: false   // ← runs inside YouTube's cross-origin iframe
      )
      webView.configuration.userContentController.addUserScript(script)
      // Also evaluate immediately in case the page is already loaded.
      webView.evaluateJavaScript(visibilityPatchScript, completionHandler: nil)
      found = true
    }

    for sub in view.subviews {
      if injectPatches(into: sub) { found = true }
    }
    return found
  }

  // MARK: - NSWindowDelegate: intercept minimize

  /// Replace true miniaturization with a simple hide.
  ///
  /// When macOS miniaturizes a window it suspends the WKWebView's WebContent
  /// process (a separate OS process), killing all JS timers. Hiding the window
  /// with orderOut keeps the process alive: music never stops.
  /// The user can restore the window by clicking the app's Dock icon.
  func windowShouldMiniaturize(_ sender: NSWindow) -> Bool {
    sender.orderOut(nil)
    return false
  }
}
