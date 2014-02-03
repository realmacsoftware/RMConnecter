//
//  RMConnecterCredentials+Keychain.h
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMConnecterCredentials.h"

@interface RMConnecterCredentials (Keychain)

/*!
	\brief
	Attempt to retrieve credentials for `itunesconnect.apple.com` from the keychain.
	Note that calling this methot might lead to a modal security alert asking for keychain permission being presented to the user.
 */
+ (instancetype)findCredentialsInKeychainForUsername:(NSString *)username error:(NSError **)errorRef;

@end
