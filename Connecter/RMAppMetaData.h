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

@property (nonatomic, strong) NSString *metadataToken;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *vendorID;

@property (nonatomic, strong) NSArray *versions;

- (NSXMLDocument*)xmlDocumentRepresentation;

@end
