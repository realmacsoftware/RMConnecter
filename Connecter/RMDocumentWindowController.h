//
//  RMDocumentWindowController.h
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RXMLElement;

@interface RMDocumentWindowController : NSWindowController

@property (nonatomic, assign) RXMLElement *activeXMLFile;

@end
