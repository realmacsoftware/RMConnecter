//
//  RMAppScreenshot.h
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMXMLObject.h"

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RMAppScreenshotType) {
    RMAppScreenshotTypeiPhone35inch,
    RMAppScreenshotTypeiPhone4inch,
    RMAppScreenshotTypeiPad,
    RMAppScreenshotTypeMac
};

@interface RMAppScreenshot : NSObject <RMXMLObject>

@property (nonatomic, assign) RMAppScreenshotType displayTarget;
@property (nonatomic, assign) NSInteger position;

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSString *checksumType;
@property (nonatomic, assign) long size;

@end

