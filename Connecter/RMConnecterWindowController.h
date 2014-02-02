//
//  RMConnecterWindowController.h
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RMConnecterWindowController : NSWindowController

@property (unsafe_unretained) IBOutlet NSTextView *logView;
@property (weak) IBOutlet NSTextField *iTunesConnectAppSKUField;

// Sign-in Fields
@property (assign) IBOutlet NSTextField *iTunesConnectUsernameField;
@property (assign) IBOutlet NSSecureTextField *iTunesConnectPasswordField;

// State Controls
@property (assign) IBOutlet NSProgressIndicator *activityQueueProgressIndicator;
@property (weak) IBOutlet NSTextField *statusTextField;

// Buttons
@property (weak) IBOutlet NSButton *downloadPackageFromiTunesConnectButton;
@property (weak) IBOutlet NSButton *verifyLocalPackageButton;
@property (weak) IBOutlet NSButton *submitLocalPackageToiTunesConnectButton;

@end
