#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *appPath = @"/Users/n0rthstar/Desktop/hebrew/LearnHebrew.app";
        NSString *iconPath = @"/Users/n0rthstar/Desktop/hebrew/LearnHebrew.app/Contents/Resources/AppIcon.icns";
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:iconPath];
        if (!img) {
            NSLog(@"Failed to load image from %@", iconPath);
            return 1;
        }
        BOOL success = [[NSWorkspace sharedWorkspace] setIcon:img forFile:appPath options:0];
        NSLog(@"Set icon for %@: %d", appPath, success);
    }
    return 0;
}
