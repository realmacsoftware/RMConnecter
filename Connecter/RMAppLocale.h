//
//  RMAppLocale.h
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMXMLObject.h"

#import <Foundation/Foundation.h>

@interface RMAppLocale : NSObject <RMXMLObject, NSCopying>

@property (nonatomic, assign) BOOL shouldDeleteLocale;

@property (nonatomic, copy) NSString *localeName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *appDescription;
@property (nonatomic, copy) NSString *whatsNew;
@property (nonatomic, copy) NSString *softwareURL;
@property (nonatomic, copy) NSString *supportURL;
@property (nonatomic, copy) NSString *privacyURL;

@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSArray *screenshots;

@end


@interface RMAppLocale (TreeController)
@property (nonatomic, readonly) NSArray *children;
@end
