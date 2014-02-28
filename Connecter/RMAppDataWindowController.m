//
//  RMAppDataWindowController.m
//  Connecter
//
//  Created by Markus on 28.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

// Controller
#import "RMAddLocaleWindowController.h"
#import "RMOutlineViewController.h"

// Views
#import "RMScreenshotsGroupView.h"
#import "RMOutlineView.h"

// Model
#import "RMAppDataDocument.h"
#import "RMAppScreenshot.h"
#import "RMAppMetaData.h"
#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMAppDataWindowController.h"

NSString *const RMAppDataArrangedObjectsKVOPath = @"arrangedObjects";

@interface RMAppDataWindowController () <RMScreenshotsGroupViewDelegate, NSTabViewDelegate, NSOutlineViewDelegate>

@property (nonatomic, strong) RMOutlineViewController *outlineController;
@property (nonatomic, strong) RMAddLocaleWindowController *addLocaleWindowController;

@property (nonatomic, strong) IBOutlet NSArrayController *versionsController;
@property (nonatomic, strong) IBOutlet NSArrayController *localesController;
@property (nonatomic, strong) IBOutlet NSArrayController *screenshotsController;
@property (nonatomic, weak)   IBOutlet RMScreenshotsGroupView *screenshotsView;
@property (nonatomic, weak)   IBOutlet RMOutlineView *outlineView;
@property (nonatomic, weak)   IBOutlet NSTabView *tabView;

@end

@implementation RMAppDataWindowController

- (id)init
{
    return [super initWithWindowNibName:NSStringFromClass([self class])];
}

- (void)dealloc;
{
    [self.screenshotsController removeObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // setup outlineController / outlineView
    self.outlineController = [[RMOutlineViewController alloc] init];
    self.outlineController.versionsController = self.versionsController;
    self.outlineController.localesController = self.localesController;
    self.outlineView.dataSource = self.outlineController;
    self.outlineView.delegate = self.outlineController;
    [self.outlineView expandItem:nil expandChildren:YES];
    
    // add new locales action
    __weak typeof(self) blockSelf = self;
    self.outlineController.addLocaleBlock = ^(NSButton *sender){
        RMAddLocaleWindowController *addLocaleController = [[RMAddLocaleWindowController alloc] initWithMetaData:blockSelf.rmDocument.metaData];
        blockSelf.addLocaleWindowController = addLocaleController;
        [sender.window beginSheet:addLocaleController.window
                completionHandler:^(NSModalResponse returnCode) {
                    if (returnCode == NSModalResponseOK) {
                        [blockSelf.outlineView reloadData];
                    }
                    [addLocaleController.window orderOut:nil];
                    blockSelf.addLocaleWindowController = nil;
                }];
    };
    
    // delete locales action
    self.outlineView.deleteItemBlock = ^(id item){
        if ([item isKindOfClass:[RMAppLocale class]]) {
            [blockSelf showDeleteAlertWithConfirmedBlock:^(){
                RMAppLocale *locale = item;
                locale.shouldDeleteLocale = YES;
                [blockSelf.outlineView reloadData];
            }];
        }
    };
    
    // setup screenshots view
    self.screenshotsView.delegate = self;
    [self.screenshotsController addObserver:self forKeyPath:RMAppDataArrangedObjectsKVOPath options:NSKeyValueObservingOptionInitial context:nil];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
{
    return [NSString stringWithFormat: @"%@ - Connector", displayName];
}

#pragma mark NSAlert helper

- (void)showDeleteAlertWithConfirmedBlock:(void(^)(void))confirmedBlock;
{
    if (!confirmedBlock) return;
    
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"Delete"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"Delete Locale?"];
	[alert setInformativeText:@"All attached data will be deleted, including any screenshot. This can't be restored."];
	
	[alert beginSheetModalForWindow:[self.outlineView window] completionHandler:^ (NSModalResponse returnCode) {
		if (returnCode == NSAlertFirstButtonReturn) {
			confirmedBlock();
		}
	}];
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

#pragma mark helper

- (RMAppDataDocument*)rmDocument;
{
    return self.document;
}

@end
