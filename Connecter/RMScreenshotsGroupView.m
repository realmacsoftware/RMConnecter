//
//  RMScreenshotsGroupView.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMScreenshotViewController.h"

#import "RMScreenshotsGroupView.h"

@interface RMScreenshotsGroupView ()
@property (nonatomic, copy) NSArray *screenshotViewController;
@end

@implementation RMScreenshotsGroupView

- (void)awakeFromNib;
{
    [super awakeFromNib];
    [self addScreenshotViews];
}

- (void)addScreenshotViews;
{
    NSMutableArray *controllerArray = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        RMScreenshotViewController *controller = [[RMScreenshotViewController alloc] initWithNibName:@"RMScreenshotViewController" bundle:nil];
        controller.position = i+1;
        [controllerArray addObject:controller];
        [self addSubview:controller.view];
    }
    self.screenshotViewController = controllerArray;
    
    // relayout
    [self setFrame:self.frame];
}

- (void)setFrame:(NSRect)frameRect;
{
    [super setFrame:frameRect];
    
    NSInteger xPos=0, margin=12;
    NSInteger viewWidth = [[[self.screenshotViewController firstObject] view] frame].size.width;
    for (NSView *view in [self.screenshotViewController valueForKey:@"view"]) {
        [view setFrameOrigin:NSMakePoint(xPos, 0)];
        [view setFrameSize:NSMakeSize(viewWidth, frameRect.size.height)];
        xPos += view.frame.size.width + margin;
    }
}

#pragma mark setter

- (void)setScreenshots:(NSArray*)screenshots;
{
    _screenshots = screenshots;

    for (RMScreenshotViewController *controller in self.screenshotViewController) {
        controller.screenshot = nil;
    }
    
    for (RMAppScreenshot *screenshot in screenshots) {
        int index = screenshot.position-1;
        if(self.screenshotViewController.count > index) {
            [self.screenshotViewController[index] setScreenshot:screenshot];
        }
    }
}

@end
