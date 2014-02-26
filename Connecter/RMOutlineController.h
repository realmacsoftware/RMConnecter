//
//  RMOutlineController.h
//  Connecter
//
//  Created by Markus on 25.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface RMOutlineController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, weak) NSArrayController *versionsController;
@property (nonatomic, weak) NSArrayController *localesController;

@end
