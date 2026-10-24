#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 3) {
            NSLog(@"Usage: macos_icon_processor <input_image> <output_png>");
            return 1;
        }
        NSString *inPath = [NSString stringWithUTF8String:argv[1]];
        NSString *outPath = [NSString stringWithUTF8String:argv[2]];

        NSImage *src = [[NSImage alloc] initWithContentsOfFile:inPath];
        if (!src) {
            NSLog(@"Could not load image at %@", inPath);
            return 1;
        }

        // macOS standard 1024x1024 canvas
        const CGFloat canvasSize = 1024.0;
        const CGFloat iconSize = 824.0; // standard macOS HIG icon squircle size
        const CGFloat originOffset = (canvasSize - iconSize) / 2.0; // 100px
        const CGFloat cornerRadius = 185.0; // standard macOS squircle corner radius

        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
            initWithBitmapDataPlanes:NULL
                          pixelsWide:(NSInteger)canvasSize
                          pixelsHigh:(NSInteger)canvasSize
                       bitsPerSample:8
                     samplesPerPixel:4
                            hasAlpha:YES
                            isPlanar:NO
                      colorSpaceName:NSDeviceRGBColorSpace
                         bytesPerRow:0
                        bitsPerPixel:0];

        NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
        [NSGraphicsContext setCurrentContext:ctx];
        [[NSGraphicsContext currentContext] setShouldAntialias:YES];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

        NSRect squircleRect = NSMakeRect(originOffset, originOffset, iconSize, iconSize);

        // 1. Draw subtle ambient drop shadow beneath squircle
        NSShadow *shadow = [[NSShadow alloc] init];
        [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.38]];
        [shadow setShadowOffset:NSMakeSize(0, -14)];
        [shadow setShadowBlurRadius:28.0];

        [NSGraphicsContext saveGraphicsState];
        [shadow set];
        NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRoundedRect:squircleRect xRadius:cornerRadius yRadius:cornerRadius];
        [[NSColor blackColor] set];
        [shadowPath fill];
        [NSGraphicsContext restoreGraphicsState];

        // 2. Clip to Apple squircle and draw image
        [NSGraphicsContext saveGraphicsState];
        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:squircleRect xRadius:cornerRadius yRadius:cornerRadius];
        [clipPath addClip];

        // Draw source image centered and filling the squircle
        NSRect srcRect = NSMakeRect(0, 0, src.size.width, src.size.height);
        [src drawInRect:squircleRect fromRect:srcRect operation:NSCompositingOperationCopy fraction:1.0];

        // 3. Add subtle top highlight and border rim
        NSBezierPath *strokePath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(squircleRect, 0.5, 0.5) xRadius:cornerRadius yRadius:cornerRadius];
        [strokePath setLineWidth:1.5];
        [[NSColor colorWithCalibratedWhite:1.0 alpha:0.18] set];
        [strokePath stroke];

        [NSGraphicsContext restoreGraphicsState];

        NSData *pngData = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
        [pngData writeToFile:outPath atomically:YES];
        NSLog(@"Successfully generated Apple HIG squircle icon at %@", outPath);
    }
    return 0;
}
