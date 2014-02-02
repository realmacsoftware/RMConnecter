//
//  RMConnecterCredentials.h
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMConnecterCredentials : NSObject

+ (instancetype)credentialsWithUsername:(NSString *)username password:(NSString *)password;

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;

@property (readonly, getter = isValid, assign, nonatomic) BOOL valid;

@end
