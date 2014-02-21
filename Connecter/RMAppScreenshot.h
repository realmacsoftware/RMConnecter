//
//  RMAppScreenshot.h
//  Connecter
//
//  Created by Markus on 19.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMAppScreenshotTypeValueTransformer.h"
#import "RMXMLObject.h"

#import <Foundation/Foundation.h>

@interface RMAppScreenshot : NSObject <RMXMLObject>

@property (nonatomic, assign) RMAppScreenshotType displayTarget;
@property (nonatomic, assign) int position;

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *checksum;
@property (nonatomic, strong) NSString *checksumType;
@property (nonatomic, assign) int size;

- (NSString*)generateFilename;

@end

