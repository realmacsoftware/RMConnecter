//
//  RMScreenshotView.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshot.h"

#import "RMScreenshotView.h"

@interface RMScreenshotView ()
@property (weak) IBOutlet NSImageView *imageView;
- (IBAction)imageDidChange:(NSImageView*)sender;
@end

@implementation RMScreenshotView

- (void)setScreenshot:(RMAppScreenshot *)screenshot;
{
    if (screenshot == _screenshot) return;
    [self willChangeValueForKey:@"screenshot"];
    _screenshot = screenshot;
    [self didChangeValueForKey:@"screenshot"];
    
    //
}

- (IBAction)imageDidChange:(NSImageView*)sender;
{
    //
}

@end
