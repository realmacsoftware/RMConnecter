//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppDataDocument.h"

@interface RMAppDataDocument ()
@property (weak) IBOutlet NSPopUpButton *versionsPopup;
@property (weak) IBOutlet NSComboBox *localesPopup;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTokenField *keywordsField;
@property (unsafe_unretained) IBOutlet NSTextView *whatsNewField;
@property (unsafe_unretained) IBOutlet NSTextView *descriptionTextField;
@end

@implementation RMAppDataDocument

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
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

#pragma mark UI

- (void)updateUI;
{
    NSXMLElement *root = self.activeXMLFile.rootElement;
    NSXMLNode *versionsElement = [[[root childAtIndex:0] childAtIndex:0] childAtIndex:0];
    
    // versions popup
    [self.versionsPopup removeAllItems];
    NSArray *versions = [versionsElement children];
    for (NSXMLElement *element in versions) {
        NSString *versionString = [[element attributeForName:@"string"] stringValue];
        [self.versionsPopup addItemWithTitle:versionString];
    }
    
    NSXMLNode *localesOfCurrentVersion = [[versions firstObject] childAtIndex:0];
    
    // locales popup
    [self.localesPopup removeAllItems];
    NSArray *locales = [localesOfCurrentVersion children];
    [locales enumerateObjectsUsingBlock:^(NSXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *localeString = [[element attributeForName:@"name"] stringValue];
        [self.localesPopup addItemWithObjectValue:localeString];
        if (idx==0) {
            [self.localesPopup setObjectValue:localeString];
        }
    }];
    
    NSXMLElement *currentLocale = [locales firstObject];
    
    NSString *title = [[[currentLocale elementsForName:@"title"] firstObject] stringValue];
    self.titleTextField.objectValue = title;
    
    NSString *description = [[[currentLocale elementsForName:@"description"] firstObject] stringValue];
    self.descriptionTextField.string = description;
    
    NSString *whatsnew = [[[currentLocale elementsForName:@"version_whats_new"] firstObject] stringValue];
    self.whatsNewField.string = whatsnew;
    
    // keywords
    NSXMLElement *keywords = [[currentLocale elementsForName:@"keywords"] firstObject];
    NSMutableString *keywordsString = [NSMutableString string];
    [[keywords children] enumerateObjectsUsingBlock:^(NSXMLElement *element, NSUInteger idx, BOOL *stop) {
        [keywordsString appendFormat:@"%@,", [element stringValue]];
    }];
    self.keywordsField.stringValue = keywordsString;
}

@end
