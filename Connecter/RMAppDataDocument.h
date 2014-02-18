//
//  RMDocumentWindowController.h
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RMAppDataDocument : NSDocument

@property (nonatomic, strong) NSString *bundlePath;
@property (nonatomic, strong) NSXMLDocument *activeXMLFile;

@end