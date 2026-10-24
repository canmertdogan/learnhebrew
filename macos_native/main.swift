import Cocoa
import WebKit
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate, WKScriptMessageHandler {
    var window: NSWindow!
    var webView: WKWebView!
    let synth = AVSpeechSynthesizer()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1080, height: 780)
        let winWidth: CGFloat = min(1040, screenRect.width * 0.85)
        let winHeight: CGFloat = min(760, screenRect.height * 0.85)
        let rect = NSRect(
            x: screenRect.origin.x + (screenRect.width - winWidth) / 2,
            y: screenRect.origin.y + (screenRect.height - winHeight) / 2,
            width: winWidth,
            height: winHeight
        )

        window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "למד עברית · Learn Hebrew"
        window.minSize = NSSize(width: 680, height: 520)

        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "nativeTts")

        // Bridge window.speechSynthesis fallback to native macOS AVSpeechSynthesizer
        let bridgeJs = """
        window.Store && (window.Store.speak = function(hebrew) {
          var plain = hebrew.replace(/[\\u0591-\\u05C7]/g, '');
          if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativeTts) {
            window.webkit.messageHandlers.nativeTts.postMessage(plain);
          } else if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
            var u = new SpeechSynthesisUtterance(plain);
            u.lang = 'he-IL';
            u.rate = 0.85;
            window.speechSynthesis.speak(u);
          }
        });
        """
        let script = WKUserScript(source: bridgeJs, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)

        webView = WKWebView(frame: window.contentView!.bounds, configuration: config)
        webView.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(webView)

        if let resPath = Bundle.main.resourcePath {
            let indexUrl = URL(fileURLWithPath: resPath).appendingPathComponent("index.html")
            let dirUrl = URL(fileURLWithPath: resPath)
            webView.loadFileURL(indexUrl, allowingReadAccessTo: dirUrl)
        }

        setupMenu()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativeTts", let text = message.body as? String {
            if synth.isSpeaking {
                synth.stopSpeaking(at: .immediate)
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "he-IL")
            utterance.rate = 0.43
            synth.speak(utterance)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func setupMenu() {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Quit Learn Hebrew", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        NSApp.mainMenu = mainMenu
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
