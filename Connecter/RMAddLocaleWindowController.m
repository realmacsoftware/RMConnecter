//
//  RMAddLocaleWindowController.m
//  Connecter
//
//  Created by Markus on 26.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAddLocaleWindowController.h"

@interface RMAddLocaleWindowController ()

@end

@implementation RMAddLocaleWindowController

- (id)init
{
    return [super initWithWindowNibName:NSStringFromClass([self class]) owner:self];
}

- (IBAction)cancel:(id)sender;
{
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseCancel];
}

- (IBAction)addLocale:(id)sender;
{
    [self.window.sheetParent endSheet:self.window
                           returnCode:NSModalResponseOK];
}

@end
