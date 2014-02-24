//
//  RMScreenshotsGroupView.h
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshot.h"

#import <Cocoa/Cocoa.h>

@protocol RMScreenshotsGroupViewDelegate;

@interface RMScreenshotsGroupView : NSView

@property (nonatomic, strong) NSArray *screenshots;

@property (nonatomic, weak) id<RMScreenshotsGroupViewDelegate> delegate;

@end


@protocol RMScreenshotsGroupViewDelegate <NSObject>
- (void)screenshotsGroupViewDidUpdateScreenshots:(RMScreenshotsGroupView*)controller;
@end

