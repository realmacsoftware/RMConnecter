//
//  AppMetaData.h
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMXMLObject.h"
#import <Foundation/Foundation.h>

@interface RMAppMetaData : NSObject <RMXMLObject>

@property (nonatomic, strong) NSArray *versions;

@end
