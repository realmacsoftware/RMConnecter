//
//  RMConnecterCredentials.m
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMConnecterCredentials.h"

@implementation RMConnecterCredentials

+ (instancetype)credentialsWithUsername:(NSString *)username password:(NSString *)password
{
	RMConnecterCredentials *credentials = [[self alloc] init];
	[credentials setUsername:username];
	[credentials setPassword:password];
	return credentials;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSMutableSet *keyPaths = [NSMutableSet setWithSet:[super keyPathsForValuesAffectingValueForKey:key]];
	
	if ([key isEqualToString:@"valid"]) {
		[keyPaths addObject:@"username"];
		[keyPaths addObject:@"password"];
	}
	
	return keyPaths;
}

- (BOOL)isValid
{
	return ([[self username] length] > 0 && [[self password] length] > 0);
}

@end
