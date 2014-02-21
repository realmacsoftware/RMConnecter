//
//  RMScreenshotViewController.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshot.h"

#import "RMScreenshotViewController.h"

@interface RMScreenshotViewController ()
@end

@implementation RMScreenshotViewController

- (void)setScreenshot:(RMAppScreenshot *)screenshot;
{
    if (screenshot == _screenshot) return;
    [self willChangeValueForKey:@"screenshot"];
    _screenshot = screenshot;
    [self didChangeValueForKey:@"screenshot"];
    
    self.imageView.image = [[NSImage alloc] initWithData:screenshot.imageData];
}

- (IBAction)imageDidChange:(NSImageView*)sender;
{
    if (sender.image)
    {
        // get PNG representation
        [sender.image lockFocus];
        NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:
                                       NSMakeRect(0, 0, sender.image.size.width, sender.image.size.height)];
        NSData *imageData = [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
        [sender.image unlockFocus];
        
        // update screenshot
        self.screenshot.imageData = imageData;
    }
    else
    {
        // remove screenshot
        self.screenshot = nil;
    }
}

@end
