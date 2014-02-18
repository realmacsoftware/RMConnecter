//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppMetaData.h"
#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMAppDataDocument.h"

@interface RMAppDataDocument ()

@property (nonatomic, strong) NSString *bundlePath;
@property (nonatomic, strong) RMAppMetaData *metaData;

@end

@implementation RMAppDataDocument

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
    
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithRootElement:self.metaData.xmlRepresentation];
    NSData *xmlData = [document XMLData];
    return [xmlData writeToURL:[NSURL fileURLWithPath:path] atomically:YES];
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName
              error:(NSError *__autoreleasing *)outError;
{
    NSString *xmlPath = [[url path] stringByAppendingPathComponent:[self xmlFileName]];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath options:0 error:outError];
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:outError];
    self.metaData = [[RMAppMetaData alloc] initWithXMLElement:document.rootElement];
    self.bundlePath = [url path];
    
    if (*outError != nil) {
        return NO;
    } else {
        return YES;
    }
}

@end

