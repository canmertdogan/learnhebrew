#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) AVSpeechSynthesizer *synth;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.synth = [[AVSpeechSynthesizer alloc] init];

    // Explicitly set dock icon
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    NSString *iconPath = [resPath stringByAppendingPathComponent:@"AppIcon.icns"];
    NSImage *iconImg = [[NSImage alloc] initWithContentsOfFile:iconPath];
    if (iconImg) {
        [NSApp setApplicationIconImage:iconImg];
    }

    NSRect screenRect = [[NSScreen mainScreen] visibleFrame];
    CGFloat winW = MIN(1040.0, screenRect.size.width * 0.85);
    CGFloat winH = MIN(760.0, screenRect.size.height * 0.85);
    NSRect rect = NSMakeRect(
        screenRect.origin.x + (screenRect.size.width - winW) / 2.0,
        screenRect.origin.y + (screenRect.size.height - winH) / 2.0,
        winW,
        winH
    );

    NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    self.window = [[NSWindow alloc] initWithContentRect:rect styleMask:style backing:NSBackingStoreBuffered defer:NO];
    [self.window setTitle:@"למד עברית · Learn Hebrew"];
    [self.window setMinSize:NSMakeSize(680, 520)];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"nativeTts"];

    NSString *bridgeJs =
        @"window.addEventListener('DOMContentLoaded', function() {"
        @"  if (window.Store) {"
        @"    window.Store.speak = function(hebrew) {"
        @"      var plain = hebrew.replace(/[\\u0591-\\u05C7]/g, '');"
        @"      if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativeTts) {"
        @"        window.webkit.messageHandlers.nativeTts.postMessage(plain);"
        @"      }"
        @"    };"
        @"  }"
        @"});";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:bridgeJs injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];

    self.webView = [[WKWebView alloc] initWithFrame:[[self.window contentView] bounds] configuration:config];
    [self.webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self.window contentView] addSubview:self.webView];

    NSURL *indexUrl = [NSURL fileURLWithPath:[resPath stringByAppendingPathComponent:@"index.html"]];
    NSURL *dirUrl = [NSURL fileURLWithPath:resPath];
    [self.webView loadFileURL:indexUrl allowingReadAccessToURL:dirUrl];

    NSMenu *mainMenu = [[NSMenu alloc] init];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [mainMenu addItem:appMenuItem];
    NSMenu *appMenu = [[NSMenu alloc] init];
    [appMenu addItemWithTitle:@"Quit Learn Hebrew" action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenuItem setSubmenu:appMenu];
    [NSApp setMainMenu:mainMenu];

    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"nativeTts"] && [message.body isKindOfClass:[NSString class]]) {
        NSString *text = (NSString *)message.body;
        if ([self.synth isSpeaking]) {
            [self.synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        }
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"he-IL"];
        utterance.rate = 0.43f;
        [self.synth speakUtterance:utterance];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app setActivationPolicy:NSApplicationActivationPolicyRegular];
        [app run];
    }
    return 0;
}
