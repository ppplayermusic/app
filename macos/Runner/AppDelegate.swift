import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var methodChannel: FlutterMethodChannel?
  
  private var isPlaying = false
  private var isShuffle = false
  private var repeatMode = "none"

  override func applicationDidFinishLaunching(_ notification: Notification) {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      methodChannel = FlutterMethodChannel(name: "com.ppplayer/dock_menu", binaryMessenger: controller.engine.binaryMessenger)
      
      methodChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "updateState" {
          if let args = call.arguments as? [String: Any] {
            if let playing = args["isPlaying"] as? Bool { self?.isPlaying = playing }
            if let shuffle = args["isShuffle"] as? Bool { self?.isShuffle = shuffle }
            if let repMode = args["repeatMode"] as? String { self?.repeatMode = repMode }
          }
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
    super.applicationDidFinishLaunching(notification)
  }

  override func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
    let menu = NSMenu(title: "Dock Menu")

    let playPauseItem = NSMenuItem(title: isPlaying ? "Pause" : "Play", action: #selector(playPauseClicked), keyEquivalent: "")
    menu.addItem(playPauseItem)

    menu.addItem(NSMenuItem(title: "Next", action: #selector(nextClicked), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "Previous", action: #selector(previousClicked), keyEquivalent: ""))
    
    menu.addItem(NSMenuItem.separator())
    
    let shuffleTitle = isShuffle ? "Shuffle (On)" : "Shuffle"
    menu.addItem(NSMenuItem(title: shuffleTitle, action: #selector(shuffleClicked), keyEquivalent: ""))
    
    let repeatTitle: String
    switch repeatMode {
    case "one": repeatTitle = "Repeat (One)"
    case "all": repeatTitle = "Repeat (All)"
    default: repeatTitle = "Repeat"
    }
    menu.addItem(NSMenuItem(title: repeatTitle, action: #selector(repeatClicked), keyEquivalent: ""))

    return menu
  }

  @objc func playPauseClicked() { methodChannel?.invokeMethod("playPause", arguments: nil) }
  @objc func nextClicked() { methodChannel?.invokeMethod("next", arguments: nil) }
  @objc func previousClicked() { methodChannel?.invokeMethod("previous", arguments: nil) }
  @objc func shuffleClicked() { methodChannel?.invokeMethod("toggleShuffle", arguments: nil) }
  @objc func repeatClicked() { methodChannel?.invokeMethod("toggleRepeat", arguments: nil) }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // When we minimize the window, we call orderOut(nil) to hide it.
    // If this returns true, the app will terminate when the window is hidden.
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  /// When the user clicks the app Dock icon and the window is hidden
  /// (because we intercept minimize → hide), re-show the window.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      sender.windows.first?.makeKeyAndOrderFront(nil)
    }
    return true
  }
}
