//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "RMAppDataDocument.h"

@interface RMAppDataDocument ()

@end

@implementation RMAppDataDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    return NSStringFromClass([self class]);
}

- (NSString*)xmlFileName;
{
    return @"metadata.xml";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError;
{
    // @TODO
    return YES;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError;
{
    NSString *xmlPath = [[url path] stringByAppendingPathComponent:[self xmlFileName]];
    self.activeXMLFile = [[RXMLElement alloc] initFromXMLFilePath:xmlPath];
    
    return YES;
}

@end
