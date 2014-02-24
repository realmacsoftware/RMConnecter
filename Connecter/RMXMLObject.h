//
//  XMLObject.h
//  Connecter
//
//  Created by Markus on 18.02.14.
//  Copyright (c) 2014 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RMXMLObject <NSObject>

- (id)initWithXMLElement:(NSXMLElement*)xmlElement;
- (NSXMLElement*)xmlRepresentation;

@end