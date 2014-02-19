//
//  RMScreenshotView.h
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMAppScreenshot;

@interface RMScreenshotView : NSView

@property (nonatomic, weak) RMAppScreenshot *screenshot;

@end
