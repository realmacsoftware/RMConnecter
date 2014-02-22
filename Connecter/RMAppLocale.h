//
//  RMAppLocale.h
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMXMLObject.h"

#import <Foundation/Foundation.h>

@interface RMAppLocale : NSObject <RMXMLObject>

@property (nonatomic, assign) BOOL shouldDeleteLocale;

@property (nonatomic, strong) NSString *localeName;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSString *whatsNew;
@property (nonatomic, strong) NSString *softwareURL;
@property (nonatomic, strong) NSString *supportURL;
@property (nonatomic, strong) NSString *privacyURL;

@property (nonatomic, strong) NSArray *screenshots;

@end
