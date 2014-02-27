//
//  RMOutlineView.m
//  Connecter
//
//  Created by Markus on 27.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMOutlineView.h"

@implementation RMOutlineView

- (IBAction)delete:(id)sender;
{
    if (self.deleteItemBlock) {
        id item = [self itemAtRow:self.selectedRow];
        self.deleteItemBlock(item);
    }
}

@end
