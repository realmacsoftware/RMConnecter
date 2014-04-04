//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

// Controller
#import "RMAppDataWindowController.h"

// Model
#import "RMAppScreenshot.h"
#import "RMAppMetaData.h"
#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMAppDataDocument.h"

NSString *const RMAppDataErrorDomain = @"RMAppDataErrorDomain";

@interface RMAppDataDocument ()
@property (nonatomic, strong) RMAppMetaData *metaData;
@end

@implementation RMAppDataDocument

- (id)initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    self = [super initWithType:typeName error:outError];
    if (self) {
        if (!self.metaData) {
            self.metaData = [[RMAppMetaData alloc] init];
        }
    }
    return self;
}

#pragma mark create window controller

- (void)makeWindowControllers;
{
    [self addWindowController:[[RMAppDataWindowController alloc] init]];
}

#pragma mark reading/saving the document

- (NSString*)xmlFileName;
{
    return @"metadata.xml";
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError;
{
    NSData *xmlData = [[self.metaData xmlDocumentRepresentation] XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSFileWrapper *xmlWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:xmlData];
    NSFileWrapper *folderWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{[self xmlFileName]:xmlWrapper}];

    // save screenshots
    for (RMAppVersion *version in self.metaData.versions) {
        for (RMAppLocale *locale in version.locales) {
            for (RMAppScreenshot* screenshot in locale.screenshots) {
                if (screenshot.imageData) {
                    NSFileWrapper *filewrapper = [[NSFileWrapper alloc] initRegularFileWithContents:screenshot.imageData];
                    filewrapper.preferredFilename = screenshot.filename;
                    [folderWrapper addFileWrapper:filewrapper];
                }
            }
        }
    }
    
    return folderWrapper;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError;
{
    NSDictionary *fileWrappers = [fileWrapper fileWrappers];
    
    // parse xml file
    NSData *xmlData = [fileWrappers[[self xmlFileName]] regularFileContents];
    if (xmlData) {
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:outError];
        self.metaData = [[RMAppMetaData alloc] initWithXMLElement:document.rootElement];
        
        // read screenshots
        for (RMAppVersion *version in self.metaData.versions) {
            for (RMAppLocale *locale in version.locales) {
                for (RMAppScreenshot* screenshot in locale.screenshots) {
                    NSFileWrapper *fileWrapper = fileWrappers[screenshot.filename];
                    if (fileWrapper) {
                        screenshot.imageData = [fileWrapper regularFileContents];
                    }
                }
            }
        }
        
        return YES;
    }
    
    NSString *errorMessage = [NSString stringWithFormat:@"Could not read xml document named %@", [self xmlFileName]];
    *outError = [NSError errorWithDomain:RMAppDataErrorDomain code:0
                                userInfo:@{NSLocalizedFailureReasonErrorKey:errorMessage}];
    return NO;
}

@end

