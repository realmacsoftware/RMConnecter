//
//  RMConnecterCredentials+Keychain.m
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import "RMConnecterCredentials+Keychain.h"

@implementation RMConnecterCredentials (Keychain)

static CFDictionaryRef CF_RETURNS_RETAINED _RMConnecterCreateKeychainQuery(NSString *username)
{
	CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	CFDictionarySetValue(query, kSecClass, kSecClassInternetPassword);
	CFDictionarySetValue(query, kSecAttrServer, CFSTR("itunesconnect.apple.com"));
	if (username != nil) {
		CFDictionarySetValue(query, kSecAttrAccount, (CFStringRef)username);
	}
	CFDictionarySetValue(query, kSecReturnAttributes, kCFBooleanTrue);
	CFDictionarySetValue(query, kSecReturnData, kCFBooleanTrue);
	return query;
}

static CFTypeRef CF_RETURNS_RETAINED _RMConnecterRetrieveKeychainItem(CFDictionaryRef query, NSError **errorRef)
{
	CFTypeRef item = NULL;
	OSStatus itemError = SecItemCopyMatching(query, &item);
	
	if (itemError != errSecSuccess) {
		if (errorRef != NULL) {
			*errorRef = [NSError errorWithDomain:NSOSStatusErrorDomain code:itemError userInfo:nil];
		}
		return nil;
	}
	
	return item;
}

+ (instancetype)findCredentialsInKeychainForUsername:(NSString *)username error:(NSError **)errorRef
{
	CFDictionaryRef query = _RMConnecterCreateKeychainQuery(username);
	CFTypeRef item = _RMConnecterRetrieveKeychainItem(query, errorRef);
	CFRelease(query);
	
	if (item == NULL) {
		return nil;
	}
	
	NSString *account = (NSString *)CFDictionaryGetValue(item, kSecAttrAccount);
	NSString *password = [[NSString alloc] initWithData:(NSData *)CFDictionaryGetValue(item, kSecValueData) encoding:NSUTF8StringEncoding];
	
	CFRelease(item);
	
	return [RMConnecterCredentials credentialsWithUsername:account password:password];
}

@end
