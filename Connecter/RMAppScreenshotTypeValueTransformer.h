//
//  RMAppScreenshotTypeValueTransformer.h
//  Connecter
//
//  Created by Markus on 21.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RMAppScreenshotType) {
    RMAppScreenshotTypeiPhone35inch,
    RMAppScreenshotTypeiPhone4inch,
    RMAppScreenshotTypeiPad,
    RMAppScreenshotTypeMac
};

extern NSString *const RMAppScreenshotTypeValueTransformerName;

@interface RMAppScreenshotTypeValueTransformer : NSValueTransformer

@end
