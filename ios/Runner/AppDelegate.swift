import Flutter
import UIKit
import AVFoundation
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  
  private var patchTimer: Timer?
  private let visibilityPatchScript = """
    Object.defineProperty(document, 'hidden', { get: () => false });
    Object.defineProperty(document, 'visibilityState', { get: () => 'visible' });
    document.dispatchEvent(new Event('visibilitychange'));
  """

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to set audio session category: \\(error)")
    }

    schedulePatchScan()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func schedulePatchScan() {
    patchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
      guard let self = self else { timer.invalidate(); return }
      
      let scenes = UIApplication.shared.connectedScenes
      let windowScenes = scenes.compactMap { $0 as? UIWindowScene }
      let windows = windowScenes.flatMap { $0.windows }
      
      var found = false
      for window in windows {
        if self.injectPatches(into: window) {
          found = true
        }
      }
      
      if found {
        timer.invalidate()
        self.patchTimer = nil
        NSLog("[ppplayer] Visibility patch injected into WKWebView(s) on iOS.")
      }
    }
  }

  @discardableResult
  private func injectPatches(into view: UIView) -> Bool {
    var found = false

    if let webView = view as? WKWebView {
      let script = WKUserScript(
        source: visibilityPatchScript,
        injectionTime: .atDocumentStart,
        forMainFrameOnly: false
      )
      
      var hasInjected = false
      for s in webView.configuration.userContentController.userScripts {
        if s.source == self.visibilityPatchScript {
           hasInjected = true
           break
        }
      }
      
      if !hasInjected {
          webView.configuration.userContentController.addUserScript(script)
          webView.evaluateJavaScript(self.visibilityPatchScript, completionHandler: nil)
      }
      found = true
    }

    for sub in view.subviews {
      if injectPatches(into: sub) { found = true }
    }
    return found
  }
}
