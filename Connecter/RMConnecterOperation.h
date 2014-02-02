//
//  RMConnecterOperation.h
//  Connecter
//
//  Created by Damien DeVille on 2/2/14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMConnecterOperation : NSOperation

/*!
	\brief
	Create a connecter operation launching a program at the specified path with the specified arguments.
 */
- (id)initWithToolLaunchPath:(NSString *)launchPath arguments:(NSArray *)arguments;

/*!
	\brief
	Upon completion this property will be populated with the result and an eventual error can be retrieved by reference.
 */
@property (readonly, copy, atomic) NSString * (^completionProvider)(NSError **errorRef);

@end
