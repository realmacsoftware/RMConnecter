//
//  RMOutlineController.m
//  Connecter
//
//  Created by Markus on 25.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMOutlineController.h"

@implementation RMOutlineController

#pragma mark Helper

- (NSString*)displayValueForItem:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        RMAppVersion *version = item;
        return version.versionString;
    }
    else if ([item isKindOfClass:[RMAppLocale class]]) {
        RMAppLocale *locale = item;
        return locale.formattedLocaleName;
    }
    return nil;
}

- (BOOL)isItemAButton:(id)item;
{
    return ([item isKindOfClass:[NSString class]] &&
            [item isEqualToString:@"Button"]);
}

#pragma mark NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        RMAppVersion *version = item;
        return version.locales.count;
    }
    return [self.versionsController.arrangedObjects count] + 1;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        RMAppVersion *version = item;
        return version.locales[index];
    }
    
    if ([self.versionsController.arrangedObjects count] > index) {
        return [self.versionsController.arrangedObjects objectAtIndex:index];
    } else {
        return @"Button";
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        return YES;
    }
    return NO;
}

#pragma mark NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item;
{
    if([item isKindOfClass:[RMAppLocale class]] || [item isKindOfClass:[RMAppVersion class]]) {
        NSTextField *textField = [[NSTextField alloc] init];
        [textField setEditable:NO];
        [textField setSelectable:YES];
        [textField setBezeled:NO];
        [textField setBackgroundColor:[NSColor clearColor]];
        
        textField.stringValue = [self displayValueForItem:item];
        
        return textField;
    }
    
    else if([self isItemAButton:item]) {
        NSButton *button = [[NSButton alloc] init];
        [button setBezelStyle:NSInlineBezelStyle];
        [button setTitle:@"Add Locale"];
        [button setTarget:self];
        [button setAction:@selector(addLocale:)];
        return button;
    }
    
    return nil;
}

- (NSIndexSet *)outlineView:(NSOutlineView *)outlineView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes;
{
    NSUInteger index = [proposedSelectionIndexes firstIndex];
    id item = [outlineView itemAtRow:index];
    
    // don't change selection, if button row is selected
    if([self isItemAButton:item]) {
        return [NSIndexSet indexSetWithIndex:[outlineView selectedRow]];
    }
    
    // find next locale, if another item is selected (e.g. a version)
    while (![item isKindOfClass:[RMAppLocale class]]) {
        index++;
        item = [outlineView itemAtRow:index];
        if (!item) return nil;
    }
    
    return [NSIndexSet indexSetWithIndex:index];
}

#pragma mark NSOutlineView Notifications

- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
{
    NSOutlineView *view = notification.object;
    RMAppLocale *locale = [view itemAtRow:view.selectedRow];
    RMAppVersion *version = [view parentForItem:locale];
    
    if (locale && version) {
        NSAssert([locale isKindOfClass:[RMAppLocale class]] && [version isKindOfClass:[RMAppVersion class]],
                 @"Selected item is not of type RMAppLocale, or parent is not of type RMAppVersion.");
        [self.versionsController setSelectedObjects:@[version]];
        [self.localesController setSelectedObjects:@[locale]];
    }
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification;
{
    NSOutlineView *view = notification.object;
    RMAppVersion *version = [notification.userInfo objectForKey:@"NSObject"];
    NSAssert([version isKindOfClass:[RMAppVersion class]], @"Expanded item is not of type RMAppVersion.");
    
    if (version == self.versionsController.selectedObjects.firstObject) {
        NSInteger row = [view rowForItem:self.localesController.selectedObjects.firstObject];
        [view selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}

#pragma mark Actions

- (void)addLocale:(NSButton*)button;
{
    if (self.addLocaleBlock) {
        self.addLocaleBlock(button);
    }
}

@end
