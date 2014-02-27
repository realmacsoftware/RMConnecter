//
//  RMOutlineViewController.h
//  Connecter
//
//  Created by Markus on 25.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class RMOutlineViewController;
typedef void(^OutlineControllerAddLocaleBlock)(id sender);

@interface RMOutlineViewController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, weak) NSArrayController *versionsController;
@property (nonatomic, weak) NSArrayController *localesController;

@property (nonatomic, copy) OutlineControllerAddLocaleBlock addLocaleBlock;

@end
