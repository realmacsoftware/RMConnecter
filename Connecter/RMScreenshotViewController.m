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
@property (weak) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet NSTextField *filenameLabel;
@property (strong) IBOutlet NSTextField *sizeLabel;
- (IBAction)imageDidChange:(NSImageView*)sender;
@end

@implementation RMScreenshotViewController

- (IBAction)imageDidChange:(NSImageView*)sender;
{
    //
}

@end
