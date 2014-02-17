//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppDataDocument.h"

@interface RMAppDataDocument ()

@end

@implementation RMAppDataDocument

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the
    // windowController has loaded the document's window.
}

- (NSString *)windowNibName
{
    return NSStringFromClass([self class]);
}

- (NSString*)xmlFileName;
{
    return @"metadata.xml";
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName
             error:(NSError *__autoreleasing *)outError;
{
    NSString *path = [[url path] stringByAppendingPathComponent:[self xmlFileName]];
    
    NSData *xmlData = [self.activeXMLFile XMLData];
    return [xmlData writeToURL:[NSURL fileURLWithPath:path] atomically:YES];
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName
              error:(NSError *__autoreleasing *)outError;
{
    NSString *xmlPath = [[url path] stringByAppendingPathComponent:[self xmlFileName]];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath options:0 error:outError];
    self.activeXMLFile = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:outError];
    self.bundlePath = [url path];
    
    if (*outError != nil) {
        return NO;
    } else {
        return YES;
    }
}

@end
