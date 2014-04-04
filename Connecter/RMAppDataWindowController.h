//
//  RMAppDataWindowController.h
//  Connecter
//
//  Created by Markus on 28.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMAppDataDocument;

@interface RMAppDataWindowController : NSWindowController

@property (nonatomic, readonly) RMAppDataDocument *rmDocument;

@end
