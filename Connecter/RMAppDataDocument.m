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

#import "RMAppDataDocument.h"

@interface RMAppDataDocument ()

@property (nonatomic, strong) RMAppMetaData *metaData;

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
    [self.screenshotsController removeObserver:self forKeyPath:@"arrangedObjects"];
    [self.segmentedControl removeObserver:self forKeyPath:@"cell.selectedSegment"];
}

#pragma mark additional setup

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController;
{
    [super windowControllerDidLoadNib:windowController];
    
    [self.screenshotsController addObserver:self forKeyPath:@"arrangedObjects" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    [self.segmentedControl addObserver:self forKeyPath:@"cell.selectedSegment" options:0 context:nil];
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
    
    if ((object == self.screenshotsController && [keyPath isEqualToString:@"arrangedObjects"]) ||
        (object == self.segmentedControl && [keyPath isEqualToString:@"cell.selectedSegment"])) {
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

#pragma mark reading/saving the document

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError;
{
    NSData *xmlData = [[self.metaData xmlDocumentRepresentation] XMLDataWithOptions:NSXMLNodePrettyPrint];
    NSFileWrapper *xmlWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:xmlData];
    NSFileWrapper *folderWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{[self xmlFileName]:xmlWrapper}];
    return folderWrapper;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName
              error:(NSError *__autoreleasing *)outError;
{
    NSString *xmlPath = [[url path] stringByAppendingPathComponent:[self xmlFileName]];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath options:0 error:outError];
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:xmlData options:0 error:outError];
    self.metaData = [[RMAppMetaData alloc] initWithXMLElement:document.rootElement];
    
    if (*outError != nil) {
        return NO;
    } else {
        return YES;
    }
}

@end

