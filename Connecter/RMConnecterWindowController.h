//
//    RMiTunesConnecterAppDelegate.h
//    Connecter
//
//    Created by Nik Fletcher on 31/01/2014.
//
//    Copyright (c) 2014 Nik Fletcher, Realmac Software
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

#import <Cocoa/Cocoa.h>

@class RMConnecterCredentials;

@interface RMConnecterWindowController : NSWindowController

@property (unsafe_unretained) IBOutlet NSTextView *logView;
@property (weak) IBOutlet NSTextField *iTunesConnectAppSKUField;

// State Controls
@property (assign) IBOutlet NSProgressIndicator *activityQueueProgressIndicator;
@property (weak) IBOutlet NSTextField *statusTextField;

// Buttons
@property (weak) IBOutlet NSButton *downloadPackageFromiTunesConnectButton;
@property (weak) IBOutlet NSButton *verifyLocalPackageButton;
@property (weak) IBOutlet NSButton *submitLocalPackageToiTunesConnectButton;

@property (readonly, strong, nonatomic) RMConnecterCredentials *credentials;
@property (readonly, getter = isLoading, assign, nonatomic) BOOL loading;

@end
