//
//  RMScreenshotViewController.h
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMAppScreenshot;

@interface RMScreenshotViewController : NSViewController

@property (weak) IBOutlet NSImageView *imageView;

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, strong) RMAppScreenshot *screenshot;

@end
