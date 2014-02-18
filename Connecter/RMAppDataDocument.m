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

@property (weak) IBOutlet NSPopUpButton *versionsPopup;
@property (weak) IBOutlet NSPopUpButton *localesPopup;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTokenField *keywordsField;
@property (unsafe_unretained) IBOutlet NSTextView *whatsNewField;
@property (unsafe_unretained) IBOutlet NSTextView *descriptionTextField;
@property (weak) IBOutlet NSTextField *supportUrlField;
@property (weak) IBOutlet NSTextField *softwareUrlField;
@property (weak) IBOutlet NSTextField *privacyUrlField;

@end

@implementation RMAppDataDocument

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self updatePopups];
    [self updateUI];
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

#pragma mark UI

- (RMAppVersion*)selectedVersion;
{
    NSString *selectedText = [self.versionsPopup stringValue];
    for (RMAppVersion *version in self.metaData.versions) {
        if ([version.versionString isEqualToString:selectedText]) return version;
    }
    return self.metaData.versions[0];
}

- (RMAppLocale*)selectedLocale;
{
    NSString *selectedText = [self.localesPopup objectValue];
    for (RMAppLocale *locale in [[self selectedVersion] locales]) {
        if ([locale.localeName isEqualToString:selectedText]) return locale;
    }
    return [[self selectedVersion] locales][0];
}

- (void)updatePopups;
{
    // versions popup
    [self.versionsPopup removeAllItems];
    [self.metaData.versions enumerateObjectsUsingBlock:^(RMAppVersion *version, NSUInteger idx, BOOL *stop) {
        [self.versionsPopup addItemWithTitle:version.versionString];
        if (idx==0) {
            [self.versionsPopup setObjectValue:version.versionString];
        }
    }];
    
    // locales popup
    [self.localesPopup removeAllItems];
    NSArray *locales = [[self selectedVersion] locales];
    [locales enumerateObjectsUsingBlock:^(RMAppLocale *locale, NSUInteger idx, BOOL *stop) {
        [self.localesPopup addItemWithTitle:locale.localeName];
        if (idx==0) {
            [self.localesPopup setStringValue:locale.localeName];
        }
    }];
}

- (void)updateUI;
{
    RMAppLocale *currentLocale = [self selectedLocale];
    
    self.titleTextField.objectValue = currentLocale.title;
    self.whatsNewField.string = currentLocale.whatsNew;
    self.descriptionTextField.string = currentLocale.description;
    self.keywordsField.objectValue = currentLocale.keywords;
    self.supportUrlField.objectValue = currentLocale.supportURL;
    self.softwareUrlField.objectValue = currentLocale.softwareURL;
    self.privacyUrlField.objectValue = currentLocale.privacyURL;
}

@end
