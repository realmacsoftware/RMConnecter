//
//  RMDocumentWindowController.m
//  Connecter
//
//  Created by Markus on 14.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMScreenshotsGroupView.h"
#import "RMAppScreenshot.h"
#import "RMAppMetaData.h"
#import "RMAppLocale.h"

#import "RMAppDataDocument.h"

NSString *const RMAppDataErrorDomain = @"RMAppDataErrorDomain";

NSString *const RMAppDataArrangedObjectsKVOPath = @"arrangedObjects";
NSString *const RMAppDataSelectedSegmentKVOPath = @"cell.selectedSegment";

@interface RMAppDataDocument () <RMScreenshotsGroupViewDelegate>

@property (nonatomic, strong) RMAppMetaData *metaData;

@property (nonatomic, strong) IBOutlet NSArrayController *localesController;
@property (nonatomic, strong) IBOutlet NSArrayController *screenshotsController;
@property (nonatomic, weak)   IBOutlet RMScreenshotsGroupView *screenshotsView;
@property (nonatomic, weak)   IBOutlet NSSegmentedControl *segmentedControl;

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

- (void)dealloc
{
    [self.screenshotsController removeObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath];
    [self.segmentedControl removeObserver:self forKeyPath:RMAppDataSelectedSegmentKVOPath];
}

#pragma mark additional setup

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController;
{
    [super windowControllerDidLoadNib:windowController];
    
    self.screenshotsView.delegate = self;
    
    [self.screenshotsController addObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath options:NSKeyValueObservingOptionInitial context:nil];
    [self.segmentedControl addObserver:self forKeyPath:RMAppDataSelectedSegmentKVOPath options:0 context:nil];
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

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context;
{
    
    if ((object == self.screenshotsController && [keyPath isEqualToString:RMAppDataArrangedObjectsKVOPath]) ||
        (object == self.segmentedControl && [keyPath isEqualToString:RMAppDataSelectedSegmentKVOPath])) {
        [self updateScreenshots];
    }
}

- (void)updateScreenshots;
{
    RMAppScreenshotType type = (RMAppScreenshotType)self.segmentedControl.selectedSegment;
    NSArray *currentScreenshots = [self.screenshotsController.arrangedObjects
                                   filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"displayTarget == %d", type]];
    self.screenshotsView.screenshots = currentScreenshots;
}

#pragma mark RMScreenshotsGroupViewDelegate

- (void)screenshotsGroupViewDidUpdateScreenshots:(RMScreenshotsGroupView*)controller;
{
    // update screenshot models with correct type
    RMAppScreenshotType currentType = (RMAppScreenshotType)self.segmentedControl.selectedSegment;
    for (RMAppScreenshot *screenshot in controller.screenshots) {
        screenshot.displayTarget = currentType;
    }
    
    // update model
    RMAppLocale *activeLocale = [self.localesController.selectedObjects firstObject];
    activeLocale.screenshots = controller.screenshots;
}

#pragma mark reading/saving the document

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError;
{
    NSData *xmlData = [[self.metaData xmlDocumentRepresentation] XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSFileWrapper *xmlWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:xmlData];
    NSFileWrapper *folderWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{[self xmlFileName]:xmlWrapper}];
    
    for (RMAppScreenshot* screenshot in self.screenshotsController.arrangedObjects) {
        if (screenshot.imageData) {
            NSFileWrapper *filewrapper = [[NSFileWrapper alloc] initRegularFileWithContents:screenshot.imageData];
            filewrapper.preferredFilename = screenshot.filename;
            [folderWrapper addFileWrapper:filewrapper];
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
        
        return YES;
    }
    
    NSString *errorMessage = [NSString stringWithFormat:@"Could not read xml document named %@", [self xmlFileName]];
    *outError = [NSError errorWithDomain:RMAppDataErrorDomain code:0
                                userInfo:@{NSLocalizedFailureReasonErrorKey:errorMessage}];
    return NO;
}

@end

