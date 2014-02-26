//
//  RMOutlineDataSource.m
//  Connecter
//
//  Created by Markus on 25.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppVersion.h"
#import "RMAppLocale.h"

#import "RMOutlineDataSource.h"

@implementation RMOutlineDataSource

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

#pragma mark NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        RMAppVersion *version = item;
        return version.locales.count;
    }
    return [self.versionsController.arrangedObjects count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
{
    if ([item isKindOfClass:[RMAppVersion class]]) {
        RMAppVersion *version = item;
        return version.locales[index];
    }
    return [self.versionsController.arrangedObjects objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
{
    if ([item isKindOfClass:[RMAppLocale class]]) {
        return NO;
    }
    return YES;
}

#pragma mark NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item;
{
    NSTextField *textField = [[NSTextField alloc] init];
    [textField setEditable:NO];
    [textField setSelectable:YES];
    [textField setBezeled:NO];
    [textField setBackgroundColor:[NSColor clearColor]];
    
    textField.stringValue = [self displayValueForItem:item];
    
    return textField;
}

- (NSIndexSet *)outlineView:(NSOutlineView *)outlineView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes;
{
    NSUInteger index = [proposedSelectionIndexes firstIndex];
    id item = [outlineView itemAtRow:index];
    while ([item isKindOfClass:[RMAppVersion class]]) {
        index++;
        item = [outlineView itemAtRow:index];
        if (!item) return nil;
    }
    return [NSIndexSet indexSetWithIndex:index];
}

@end
