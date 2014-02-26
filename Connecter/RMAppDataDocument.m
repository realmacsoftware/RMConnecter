//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAddLocaleWindowController.h"
#import "RMScreenshotsGroupView.h"
#import "RMOutlineController.h"
#import "RMAppScreenshot.h"
#import "RMAppMetaData.h"
#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMAppDataDocument.h"

NSString *const RMAppDataErrorDomain = @"RMAppDataErrorDomain";

NSString *const RMAppDataArrangedObjectsKVOPath = @"arrangedObjects";

@interface RMAppDataDocument () <RMScreenshotsGroupViewDelegate, NSTabViewDelegate, NSOutlineViewDelegate>

@property (nonatomic, strong) RMAppMetaData *metaData;
@property (nonatomic, strong) RMOutlineController *outlineController;
@property (nonatomic, strong) RMAddLocaleWindowController *localeSelectionWindow;

@property (nonatomic, strong) IBOutlet NSArrayController *versionsController;
@property (nonatomic, strong) IBOutlet NSArrayController *localesController;
@property (nonatomic, strong) IBOutlet NSArrayController *screenshotsController;
@property (nonatomic, weak)   IBOutlet RMScreenshotsGroupView *screenshotsView;
@property (nonatomic, weak)   IBOutlet NSOutlineView *outlineView;
@property (nonatomic, weak)   IBOutlet NSTabView *tabView;

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

#pragma mark window managment

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController;
{
    [super windowControllerDidLoadNib:windowController];
    
    self.outlineController = [[RMOutlineController alloc] init];
    self.outlineController.versionsController = self.versionsController;
    self.outlineController.localesController = self.localesController;
    self.outlineView.dataSource = self.outlineController;
    self.outlineView.delegate = self.outlineController;
    [self.outlineView expandItem:nil expandChildren:YES];
    
    __weak typeof(self) blockSelf = self;
    self.outlineController.addLocaleBlock = ^(NSButton *sender){
        blockSelf.localeSelectionWindow = [[RMAddLocaleWindowController alloc] init];
        [sender.window beginSheet:blockSelf.localeSelectionWindow.window
                completionHandler:^(NSModalResponse returnCode) {
                    [blockSelf.localeSelectionWindow.window orderOut:nil];
                    blockSelf.localeSelectionWindow = nil;
                }];
    };
    
    self.screenshotsView.delegate = self;
    [self.screenshotsController addObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)removeWindowController:(NSWindowController *)windowController;
{
    [super removeWindowController:windowController];
    
    [self.screenshotsController removeObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath];
}

#pragma mark helper

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

#pragma mark KVO / NSTabViewDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context;
{
    
    if ((object == self.screenshotsController && [keyPath isEqualToString:RMAppDataArrangedObjectsKVOPath])) {
        [self updateScreenshots];
    }
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
{
    [self updateScreenshots];
}

- (void)updateScreenshots;
{
    RMAppScreenshotType type = (RMAppScreenshotType)[self.tabView.selectedTabViewItem.identifier integerValue];
    NSArray *currentScreenshots = [self.screenshotsController.arrangedObjects
                                   filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"displayTarget == %d", type]];
    self.screenshotsView.screenshots = currentScreenshots;
}

#pragma mark RMScreenshotsGroupViewDelegate

- (void)screenshotsGroupViewDidUpdateScreenshots:(RMScreenshotsGroupView*)controller;
{
    RMAppVersion *activeVersion = [self.versionsController.selectedObjects firstObject];
    RMAppLocale *activeLocale = [self.localesController.selectedObjects firstObject];
    
    // update screenshot models with correct displayTarget & update filenames
    RMAppScreenshotType currentDisplayTarget = (RMAppScreenshotType)[self.tabView.selectedTabViewItem.identifier integerValue];
    for (RMAppScreenshot *screenshot in controller.screenshots) {
        screenshot.displayTarget = currentDisplayTarget;
        
        if (screenshot.imageData != nil && [screenshot.filename hasPrefix:activeLocale.localeName] == NO) {
            NSString *versionString = [activeVersion.versionString stringByReplacingOccurrencesOfString:@"." withString:@""];
            versionString = [versionString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            versionString = [versionString stringByReplacingOccurrencesOfString:@"_" withString:@""];
            screenshot.filename = [NSString stringWithFormat: @"%@%@%d%d.png",
                                   activeLocale.localeName,
                                   versionString,
                                   (int)screenshot.displayTarget,
                                   (int)screenshot.position];
        }
    }
    
    // update model with new screenshots for current displayTarget
    NSArray *filteredScreenshots = [self.screenshotsController.arrangedObjects
                                    filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"displayTarget != %d", currentDisplayTarget]];
    activeLocale.screenshots = [filteredScreenshots arrayByAddingObjectsFromArray:controller.screenshots];
}

#pragma mark reading/saving the document

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

