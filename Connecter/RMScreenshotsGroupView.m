//
//  RMScreenshotsGroupView.m
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMScreenshotView.h"

#import "RMScreenshotsGroupView.h"

@interface RMScreenshotsGroupView ()
@property (nonatomic, copy) NSArray *screenshotViews;
@end

@implementation RMScreenshotsGroupView

- (void)awakeFromNib;
{
    [super awakeFromNib];
    [self addScreenshotViews];
}

- (void)addScreenshotViews;
{
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        NSArray *nibObjects;
        NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([RMScreenshotView class]) bundle:nil];
        BOOL success = [nib instantiateWithOwner:nil topLevelObjects:&nibObjects];
        if (success && nibObjects != nil) {
            RMScreenshotView *view;
            for (id obj in nibObjects) {
                if ([obj isKindOfClass:[RMScreenshotView class]]) {
                    view = obj;
                    break;
                }
            }
            if(view) {
                [viewsArray addObject:view];
                [self addSubview:view];
            }
        }
    }
    self.screenshotViews = viewsArray;
    
    // relayout
    [self setFrame:self.frame];
}

- (void)setFrame:(NSRect)frameRect;
{
    [super setFrame:frameRect];
    
    NSInteger xPos=0, margin=12;
    NSInteger viewWidth = [[self.screenshotViews firstObject] frame].size.width;
    for (RMScreenshotView *view in self.screenshotViews) {
        [view setFrameOrigin:NSMakePoint(xPos, 0)];
        [view setFrameSize:NSMakeSize(viewWidth, frameRect.size.height)];
        xPos += view.frame.size.width + margin;
    }
}

#pragma mark setter

- (void)setScreenshots:(NSArray*)screenshots;
{
    for (RMAppScreenshot *screenshot in screenshots) {
        [self.screenshotViews[screenshot.position] setScreenshot:screenshot];
    }
}

@end
