//
//  RMAddLocaleWindowController.h
//  Connecter
//
//  Created by Markus on 26.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RMAppMetaData;

@interface RMAddLocaleWindowController : NSWindowController

@property (nonatomic, weak, readonly) RMAppMetaData *metaData;
@property (nonatomic, readonly) NSArray *filteredLocales;

- (id)initWithMetaData:(RMAppMetaData*)metaData;

@end
