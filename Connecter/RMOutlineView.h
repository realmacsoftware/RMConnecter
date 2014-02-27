//
//  RMOutlineView.h
//  Connecter
//
//  Created by Markus on 27.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^RMOutlineViewDeleteItemBlock)(id item);

@interface RMOutlineView : NSOutlineView

@property (nonatomic, copy) RMOutlineViewDeleteItemBlock deleteItemBlock;

@end
